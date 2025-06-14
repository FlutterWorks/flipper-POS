import 'dart:async';

import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

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
        throw ArgumentError('Either `item` or `variation` must be provided.');
      }

      TransactionItem transactionItem;

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
        // Ensure precise calculation for decimal quantities
        final double taxblAmt = (price * quantity).toDouble();
        final double taxAmt =
            double.parse((amountTotal * 18 / 118).toStringAsFixed(2));
        // Ensure precise calculation for decimal quantities
        final double totAmt = (price * quantity).toDouble();
        final double dcAmt =
            (price * (variation.qty ?? 1.0)) * (variation.dcRt ?? 0.0);

        transactionItem = TransactionItem(
          itemNm: variation.itemNm ?? variation.name, // Required
          lastTouched: lastTouched, // Required
          name: name, // Use the passed `name` parameter
          qty: quantity, // Required
          price: price, // Required
          discount: discount, // Use the passed `discount` parameter
          prc: price, // Required
          splyAmt: variation.supplyPrice,
          taxTyCd: variation.taxTyCd,
          bcd: variation.bcd,
          itemClsCd: variation.itemClsCd,
          itemTyCd: variation.itemTyCd,
          itemStdNm: variation.itemStdNm,
          orgnNatCd: variation.orgnNatCd,
          pkg: variation.pkg.toString(),
          itemCd: variation.itemCd,
          pkgUnitCd: variation.pkgUnitCd,
          qtyUnitCd: variation.qtyUnitCd,
          tin: variation.tin,
          bhfId: variation.bhfId,
          dftPrc: variation.dftPrc,
          addInfo: variation.addInfo,
          isrcAplcbYn: variation.isrcAplcbYn,
          useYn: variation.useYn,
          regrId: variation.regrId,
          regrNm: variation.regrNm,

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
          taxblAmt: taxblAmt,
          taxAmt: taxAmt,
          totAmt: totAmt,
          itemSeq: variation.itemSeq,
          isrccCd: variation.isrccCd,
          isrccNm: variation.isrccNm,
          isrcRt: variation.isrcRt,
          isrcAmt: variation.isrcAmt,
        );
      }

      // Upsert the item in the repository
      await repository.upsert<TransactionItem>(transactionItem);

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

      // Only update if the subtotal has changed or is zero
      if (transaction.subTotal == 0 || transaction.subTotal != newSubTotal) {
        await ProxyService.strategy.updateTransaction(
          transaction: transaction,
          subTotal: newSubTotal,
          updatedAt: DateTime.now(),
          lastTouched: DateTime.now(),
        );
      }
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

    Stream<List<TransactionItem>> _branchStream(dynamic branchIdValue) {
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
  }) async {
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
      item.taxAmt = taxAmt ?? item.taxAmt;
      item.isRefunded = isRefunded ?? item.isRefunded;
      item.ebmSynced = ebmSynced ?? item.ebmSynced;
      item.quantityApproved =
          (item.quantityApproved ?? 0) + (quantityApproved ?? 0);
      item.quantityRequested = incrementQty == true
          ? (item.qty + 1).toInt()
          : qty?.toInt() ?? item.qty.toInt();
      Variant? variant =
          await ProxyService.strategy.getVariant(id: item.variantId);
      double currentQty = qty ?? item.qty;
      item.splyAmt = (variant?.supplyPrice ?? 1) * currentQty;
      talker.info('qty: $currentQty');
      talker.info('supplyPrice: ${variant?.supplyPrice}');
      talker.info('splyAmt: ${item.splyAmt}');
      item.quantityShipped = quantityShipped ?? item.quantityShipped;
      // Fix the calculation for taxblAmt and totAmt to properly factor in quantity
      // Ensure precise calculation for decimal quantities
      item.taxblAmt =
          taxblAmt ?? ((variant?.retailPrice ?? 1) * currentQty).toDouble();
      item.totAmt =
          totAmt ?? ((variant?.retailPrice ?? 1) * currentQty).toDouble();
      talker.info('taxblAmt: ${item.taxblAmt}');
      talker.info('totAmt: ${item.totAmt}');
      item.doneWithTransaction =
          doneWithTransaction ?? item.doneWithTransaction;
      repository.upsert(policy: OfflineFirstUpsertPolicy.optimisticLocal, item);
    }
  }
}
