import 'dart:async';

import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/utils/test_data/dummy_transaction_generator.dart';

mixin TransactionItemMixin implements TransactionItemInterface {
  Repository get repository;

  @override
  Future<void> addTransactionItem({
    ITransaction? transaction,
    required bool ignoreForReport,
    required bool partOfComposite,
    required DateTime lastTouched,
    required double discount,
    bool? doneWithTransaction,
    double? compositePrice,
    required double quantity,
    required double currentStock,
    Variant? variation,
    required double amountTotal,
    required String name,
    TransactionItem? item,
  }) async {
    try {
      // Validate that either `item` or `variation` is provided
      if (item == null && variation == null) {
        throw ArgumentError('Either `item` or `variation` must be provided.');
      }
      if (transaction == null) {
        throw ArgumentError('Transaction cannot be null.');
      }

      // Defensive check: Ensure the parent transaction exists in the repository
      // This helps prevent foreign key constraint errors if the transaction
      // hasn't been fully committed yet, or if there's a timing issue.
      ITransaction? committedTransaction = (await repository.get<ITransaction>(
        query: Query(where: [Where('id').isExactly(transaction.id)]),
        policy: OfflineFirstGetPolicy.localOnly,
      ))
          .firstOrNull;

      if (committedTransaction == null) {
        // If not found, try to upsert it to ensure it exists and is committed
        await repository.upsert<ITransaction>(transaction);
        committedTransaction = (await repository.get<ITransaction>(
          query: Query(where: [Where('id').isExactly(transaction.id)]),
          policy: OfflineFirstGetPolicy.localOnly,
        ))
            .firstOrNull;

        if (committedTransaction == null) {
          talker.warning(
              'Parent transaction with ID ${transaction.id} could not be committed or found. Cannot add item.');
          throw Exception(
              'Parent transaction not found or could not be committed for item insertion.');
        }
      }
      // Use the committedTransaction for further operations
      transaction = committedTransaction;

      TransactionItem transactionItem;
      num taxAmt = 0;

      if (item != null) {
        // Use the provided `TransactionItem`
        transactionItem = item;

        transactionItem.ignoreForReport = ignoreForReport;
        transactionItem.qty = quantity; // Update quantity
        transactionItem.doneWithTransaction =
            doneWithTransaction ?? transactionItem.doneWithTransaction;
        // Check if retailPrice is not null before performing calculations
        if (variation?.retailPrice != null) {
          // Ensure precise calculation for decimal quantities
          transactionItem.taxblAmt = (variation!.retailPrice! * quantity)
              .toDouble(); // Recalculate taxblAmt with explicit double conversion
          transactionItem.totAmt = (variation.retailPrice! * quantity)
              .toDouble(); // Recalculate totAmt with explicit double conversion
          transactionItem.remainingStock = currentStock - quantity;
        } else {
          // Handle the case where retailPrice is null
          throw ArgumentError(
              'Retail price is required for transaction item calculations');
        }
      } else {
        // Create a new `TransactionItem` from the `variation` object
        final double price = variation!.retailPrice!;

        // Calculate discount amount based on dcRt
        final double dcRt = variation.dcRt ?? 0.0;
        final double originalAmount = (price * quantity).toDouble();
        final double dcAmt = (originalAmount * dcRt) / 100;

        // Calculate price after discount
        final double priceAfterDiscount = originalAmount - dcAmt;

        // Log tax calculation inputs
        talker.info('TAX CALCULATION - INPUTS:');
        talker.info('  variation.taxTyCd: ${variation.taxTyCd}');
        talker.info('  price: $price');
        talker.info('  quantity: $quantity');
        talker.info('  originalAmount (price * quantity): $originalAmount');
        talker.info('  dcRt: $dcRt');
        talker.info('  dcAmt: $dcAmt');
        talker.info('  priceAfterDiscount: $priceAfterDiscount');
        talker.info('  amountTotal: $amountTotal');

        // Calculate tax amount
        num taxblAmt;
        num totAmt;

        if (variation.taxTyCd == 'B') {
          // For taxTyCd == 'B', tax is included in the price
          // Use priceAfterDiscount (which accounts for discount) instead of amountTotal
          taxAmt =
              double.parse((priceAfterDiscount * 18 / 118).toStringAsFixed(2));
          taxblAmt = priceAfterDiscount - taxAmt;
          totAmt = priceAfterDiscount;

          talker.info('  TAX CALCULATION - TYPE B (with discount):');
          talker.info('    Formula: priceAfterDiscount * 18 / 118');
          talker.info(
              '    Calculation: $priceAfterDiscount * 18 / 118 = $taxAmt');
          talker.info('    taxblAmt = priceAfterDiscount - taxAmt = $taxblAmt');
          talker.info('    totAmt = priceAfterDiscount = $totAmt');

          // For comparison with previous calculation
          double oldTaxAmt =
              double.parse((amountTotal * 18 / 118).toStringAsFixed(2));
          talker.info(
              '    Previous calculation (without discount): $amountTotal * 18 / 118 = $oldTaxAmt');

          // Example calculation with actual values
          talker.info('    Example with actual values:');
          talker.info('      originalAmount = $originalAmount');
          talker.info('      dcRt = $dcRt');
          talker.info('      dcAmt = $originalAmount * $dcRt = $dcAmt');
          talker.info(
              '      priceAfterDiscount = $originalAmount - $dcAmt = $priceAfterDiscount');
          talker
              .info('      taxAmt = $priceAfterDiscount * 18 / 118 = $taxAmt');
        } else {
          // For other tax types, tax is added to the price
          taxblAmt = priceAfterDiscount;
          taxAmt = double.parse((taxblAmt * 18 / 100).toStringAsFixed(2));
          totAmt = taxblAmt + taxAmt;

          talker.info('  TAX CALCULATION - OTHER TYPE (with discount):');
          talker.info('    taxblAmt = priceAfterDiscount = $taxblAmt');
          talker.info('    Formula: taxblAmt * 18 / 100');
          talker.info('    Calculation: $taxblAmt * 18 / 100 = $taxAmt');
          talker.info('    totAmt = taxblAmt + taxAmt = $totAmt');
        }

        final qtyUnitCd = variation.qtyUnitCd;

        transactionItem = TransactionItem(
          itemNm: variation.itemNm ?? variation.name, // Required
          lastTouched: lastTouched, // Required
          name: name, // Use the passed `name` parameter
          qty: quantity, // Required
          price: price, // Required
          discount:
              dcAmt, // Use the calculated discount amount instead of the passed parameter
          prc: price, // Required
          splyAmt: variation.supplyPrice,
          taxTyCd: variation.taxTyCd,
          bcd: variation.bcd,
          itemClsCd: variation.itemClsCd,
          itemTyCd: variation.itemTyCd,
          itemStdNm: variation.itemStdNm,
          orgnNatCd: variation.orgnNatCd,
          pkg: variation.pkg,
          itemCd: variation.itemCd,
          pkgUnitCd: variation.pkgUnitCd,
          qtyUnitCd: qtyUnitCd,
          tin: variation.tin,
          bhfId: variation.bhfId,
          dftPrc: variation.dftPrc,
          addInfo: variation.addInfo,
          isrcAplcbYn: variation.isrcAplcbYn,
          useYn: variation.useYn,
          regrId: variation.regrId,
          regrNm: variation.regrNm,
          stock: variation.stock,
          taxPercentage: variation.taxPercentage,
          color: variation.color,
          sku: variation.sku,
          productId: variation.productId,
          unit: variation.unit,
          productName: variation.productName,
          categoryId: variation.categoryId,
          categoryName: variation.categoryName,
          taxName: variation.taxName,
          supplyPrice: variation.supplyPrice,
          retailPrice: variation.retailPrice,
          spplrItemNm: variation.spplrItemNm,
          totWt: variation.totWt,
          netWt: variation.netWt,
          spplrNm: variation.spplrNm,
          agntNm: variation.agntNm,
          invcFcurAmt: variation.invcFcurAmt?.toInt() ?? 0,
          invcFcurCd: variation.invcFcurCd,
          invcFcurExcrt: variation.invcFcurExcrt,
          exptNatCd: variation.exptNatCd,
          dclNo: variation.dclNo,
          taskCd: variation.taskCd,
          dclDe: variation.dclDe,
          hsCd: variation.hsCd,
          imptItemSttsCd: variation.imptItemSttsCd,
          isShared: variation.isShared,

          assigned: variation.assigned,
          spplrItemClsCd: variation.spplrItemClsCd,
          spplrItemCd: variation.spplrItemCd,

          modrId: variation.modrId,
          modrNm: variation.modrNm,
          branchId: (await ProxyService.strategy.activeBranch()).id,
          ebmSynced: false, // Assuming default value
          partOfComposite: partOfComposite,
          compositePrice: compositePrice,
          quantityRequested: quantity.toInt(),
          quantityApproved: 0,
          quantityShipped: 0,
          transactionId: transaction.id,
          variantId: variation.id,
          remainingStock: currentStock - quantity,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          isRefunded: false, // Assuming default value
          doneWithTransaction: doneWithTransaction ?? false,
          active: true,
          dcRt: variation.dcRt,
          dcAmt: dcAmt,
          taxblAmt: taxblAmt.toDouble(),
          taxAmt: taxAmt.toDouble(),
          totAmt: totAmt.toDouble(),
          itemSeq: variation.itemSeq,
          isrccCd: variation.isrccCd,
          isrccNm: variation.isrccNm,
          isrcRt: variation.isrcRt,
          isrcAmt: variation.isrcAmt,
          supplyPriceAtSale: variation.supplyPrice, // Populate new field
        );
      }

      // Upsert the item in the repository
      await repository.upsert<TransactionItem>(transactionItem);

      // Re-fetch the transactionItem to ensure it has its brick_id populated
      // and is fully committed before proceeding.
      final committedTransactionItem = (await repository.get<TransactionItem>(
        query: Query(where: [Where('id').isExactly(transactionItem.id)]),
        policy: OfflineFirstGetPolicy.localOnly,
      ))
          .firstOrNull;

      if (committedTransactionItem == null) {
        throw Exception(
            'Failed to retrieve committed TransactionItem after upsert.');
      }
      transactionItem = committedTransactionItem; // Use the committed version

      // Fetch all items for the transaction and update their `itemSeq`
      final allItems = await repository.get<TransactionItem>(
        query: Query(
          where: [Where('transactionId').isExactly(transaction.id)],
        ),
      );

      // Sort items by `createdAt`
      allItems.sort((a, b) => a.createdAt!.compareTo(b.createdAt!));

      // Update `itemSeq` for each item
      for (var i = 0; i < allItems.length; i++) {
        allItems[i].itemSeq = i + 1; // itemSeq should start from 1
        await repository.upsert<TransactionItem>(allItems[i]);
      }

      // Calculate and update the transaction's subtotal
      double newSubTotal =
          allItems.fold(0, (sum, item) => sum + (item.price * item.qty));

      // Re-fetch the transaction to ensure we have the latest, fully-persisted version
      // before updating its items list and upserting it.
      final latestTransaction = (await repository.get<ITransaction>(
        query: Query(where: [Where('id').isExactly(transaction.id)]),
        policy: OfflineFirstGetPolicy.localOnly,
      ))
          .firstOrNull;

      if (latestTransaction == null) {
        throw Exception(
            'Failed to retrieve latest ITransaction before final upsert.');
      }

      // Only update if the subtotal has changed or is zero
      if (latestTransaction.subTotal == 0 ||
          latestTransaction.subTotal != newSubTotal) {
        await ProxyService.strategy.updateTransaction(
          transaction: latestTransaction,
          subTotal: newSubTotal,
          cashReceived: ProxyService.box.getCashReceived(),
          taxAmount: (latestTransaction.taxAmount ?? 0) + taxAmt,
          updatedAt: DateTime.now(),
          lastTouched: DateTime.now(),
        );
      }
      latestTransaction.items = allItems;
      await repository.upsert<ITransaction>(latestTransaction);
    } catch (e, s) {
      talker.error(s);
      rethrow;
    }
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams({
    String? transactionId,
    String? branchId,
    String? branchIdString,
    DateTime? startDate,
    DateTime? endDate,
    bool? doneWithTransaction,
    bool? active,
    String? requestId,
    bool fetchRemote = false,
    bool forceRealData = true,
  }) {
    List<Where> _buildConditions(dynamic branchIdValue) {
      final List<Where> conditions = [];
      conditions.add(Where('ignoreForReport').isExactly(false));
      if (branchIdValue != null) {
        conditions.add(Where('branchId').isExactly(branchIdValue));
      }
      if (transactionId != null) {
        conditions.add(Where('transactionId').isExactly(transactionId));
      }
      if (requestId != null) {
        conditions.add(Where('inventoryRequestId').isExactly(requestId));
      }
      // Handle date filtering with proper support for single date scenarios
      if (startDate != null || endDate != null) {
        // Case 1: Both dates provided (date range)
        if (startDate != null && endDate != null) {
          talker.info(
              'Date Range: \x1B[35m${startDate.toIso8601String()} to ${endDate.toIso8601String()}\x1B[0m');

          // startDate is the lower bound (inclusive)
          conditions.add(Where('createdAt')
              .isGreaterThanOrEqualTo(startDate.toIso8601String()));

          // endDate + 1 day is the upper bound (inclusive) to include all entries on the end date
          conditions.add(Where('createdAt').isLessThanOrEqualTo(
              endDate.add(const Duration(days: 1)).toIso8601String()));
        }
        // Case 2: Only startDate provided (everything from this date onwards)
        else if (startDate != null) {
          talker.info(
              'From Date: \x1B[35m${startDate.toIso8601String()}\x1B[0m onwards');
          conditions.add(Where('createdAt')
              .isGreaterThanOrEqualTo(startDate.toIso8601String()));
        }
        // Case 3: Only endDate provided (everything up to this date)
        else if (endDate != null) {
          talker
              .info('Until Date: \x1B[35m${endDate.toIso8601String()}\x1B[0m');
          conditions.add(Where('createdAt').isLessThanOrEqualTo(
              endDate.add(const Duration(days: 1)).toIso8601String()));
        }
      }
      if (doneWithTransaction != null) {
        conditions
            .add(Where('doneWithTransaction').isExactly(doneWithTransaction));
      }
      if (active != null) {
        conditions.add(Where('active').isExactly(active));
      }
      return conditions;
    }

    Stream<List<TransactionItem>> _branchStream(dynamic branchIdValue,
        {bool forceRealData = true}) {
      if ((ProxyService.box.enableDebug() ?? false) && !forceRealData) {
        return Stream.value(
            DummyTransactionGenerator.generateDummyTransactionItems(
          transactionId: transactionId ?? "",
          branchId: int.tryParse(branchIdValue.toString()) ?? 0,
        ));
      }
      final query = Query(
        where: _buildConditions(branchIdValue),
        orderBy: [OrderBy('createdAt', ascending: false)],
      );
      return repository.subscribe<TransactionItem>(
        query: query,
        policy: fetchRemote == true
            ? OfflineFirstGetPolicy.alwaysHydrate
            : OfflineFirstGetPolicy.localOnly,
      );
    }

    // Prefer string branchId, fallback to int, else fallback to no branchId
    if (branchIdString != null) {
      final stringStream = _branchStream(branchIdString);
      if (branchId != null) {
        final intStream = _branchStream(branchId);
        return stringStream.asyncExpand(
            (items) => items.isNotEmpty ? Stream.value(items) : intStream);
      }
      return stringStream;
    }
    if (branchId != null) {
      return _branchStream(branchId);
    }
    // No branchId provided
    return _branchStream(null);
  }

  @override
  FutureOr<List<TransactionItem>> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    String? branchId,
    String? variantId,
    String? id,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
    bool forceRealData = true,
  }) async {
    if ((ProxyService.box.enableDebug() ?? false) && !forceRealData) {
      return DummyTransactionGenerator.generateDummyTransactionItems(
        transactionId: transactionId ?? "",
        branchId: int.parse(branchId ?? "0"),
        count: 10,
      );
    }
    final items = await repository.get<TransactionItem>(
        policy: fetchRemote
            ? OfflineFirstGetPolicy.awaitRemoteWhenNoneExist
            : OfflineFirstGetPolicy.localOnly,
        query: Query(where: [
          if (transactionId != null)
            Where('transactionId').isExactly(transactionId),
          if (branchId != null) Where('branchId').isExactly(branchId),
          if (id != null) Where('id').isExactly(id),
          if (doneWithTransaction != null)
            Where('doneWithTransaction').isExactly(doneWithTransaction),
          if (active != null) Where('active').isExactly(active),
          if (variantId != null) Where('variantId').isExactly(active),
          if (requestId != null)
            Where('inventoryRequestId').isExactly(requestId),
        ]));
    return items;
  }

  @override
  FutureOr<void> updateTransactionItem(
      {double? qty,
      bool? ignoreForReport,
      required String transactionItemId,
      double? discount,
      bool? active,
      double? taxAmt,
      int? quantityApproved,
      int? quantityRequested,
      bool? ebmSynced,
      bool? isRefunded,
      bool? incrementQty,
      double? price,
      double? prc,
      bool? doneWithTransaction,
      int? quantityShipped,
      double? taxblAmt,
      double? totAmt,
      double? dcRt,
      double? dcAmt}) async {
    TransactionItem? item = (await repository.get<TransactionItem>(
            query: Query(where: [
      Where('id', value: transactionItemId, compare: Compare.exact),
    ])))
        .firstOrNull;
    if (item != null) {
      item.qty = incrementQty == true ? item.qty + 1 : qty ?? item.qty;
      item.discount = discount ?? item.discount;
      item.ignoreForReport = ignoreForReport ?? item.ignoreForReport;
      item.active = active ?? item.active;
      item.price = price ?? item.price;
      item.prc = prc ?? item.price;
      item.isRefunded = isRefunded ?? item.isRefunded;
      item.ebmSynced = ebmSynced ?? item.ebmSynced;
      item.quantityApproved =
          (item.quantityApproved ?? 0) + (quantityApproved ?? 0);
      item.quantityRequested = incrementQty == true
          ? (item.qty + 1).toInt()
          : qty?.toInt() ?? item.qty.toInt();

      // Recalculate based on potentially updated price and quantity
      num currentPrice = item.price;
      num currentQty = qty ?? item.qty.toDouble();
      num currentTaxPercentage = item.taxPercentage ?? 0.0;
      String currentTaxTyCd = item.taxTyCd ?? 'B'; // Default to 'B'

      // Recalculate discount amount (dcAmt) and price after discount
      double originalAmount = (currentPrice * currentQty).toDouble();
      num currentDcRt = item.dcRt ?? 0.0;
      double calculatedDcAmt = (originalAmount * currentDcRt) / 100;
      double priceAfterDiscount = originalAmount - calculatedDcAmt;

      // Recalculate taxblAmt, taxAmt, and totAmt
      double calculatedTaxblAmt;
      double calculatedTaxAmt;
      double calculatedTotAmt;

      if (currentTaxTyCd == 'B') {
        // Tax is included in the price
        calculatedTaxAmt = double.parse((priceAfterDiscount *
                currentTaxPercentage /
                (100 + currentTaxPercentage))
            .toStringAsFixed(2));
        calculatedTaxblAmt = priceAfterDiscount - calculatedTaxAmt;
        calculatedTotAmt = priceAfterDiscount;
      } else {
        // Tax is added to the price
        calculatedTaxblAmt = priceAfterDiscount;
        calculatedTaxAmt = double.parse(
            (calculatedTaxblAmt * currentTaxPercentage / 100)
                .toStringAsFixed(2));
        calculatedTotAmt = calculatedTaxblAmt + calculatedTaxAmt;
      }

      item.taxAmt = taxAmt ?? calculatedTaxAmt;
      item.taxblAmt = taxblAmt ?? calculatedTaxblAmt;
      item.totAmt = totAmt ?? calculatedTotAmt;
      item.dcAmt = dcAmt ?? calculatedDcAmt;

      // Update splyAmt if variant is available
      Variant? variant =
          await ProxyService.strategy.getVariant(id: item.variantId);

      item.splyAmt =
          (item.supplyPriceAtSale ?? variant?.supplyPrice ?? 1) * currentQty;

      item.quantityShipped = quantityShipped ?? item.quantityShipped;
      item.doneWithTransaction =
          doneWithTransaction ?? item.doneWithTransaction;
      repository.upsert(policy: OfflineFirstUpsertPolicy.optimisticLocal, item);
    }
  }
}
