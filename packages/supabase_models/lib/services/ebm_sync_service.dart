// ignore_for_file: prefer_const_constructors

import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/ICustomer.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';

/// Service responsible for synchronizing data with the EBM (Electronic Billing Machine) system.
/// Handles synchronization of variants, transactions, and customers with the tax authority's system.

/// Service that manages synchronization between the local database and the EBM system.
/// Provides methods to sync product variants, transactions, and customer data with the tax authority.
class EbmSyncService {
  /// Repository instance for database operations
  final Repository repository;

  /// Creates an instance of [EbmSyncService] with the provided [repository].
  EbmSyncService(this.repository);

  /// Synchronizes a product variant with the EBM system, including its stock information.
  ///
  /// This method handles:
  /// 1. Saving item and stock master data for the variant
  /// 2. Creating or updating transactions if needed
  /// 3. Calculating taxes
  /// 4. Syncing stock movements
  ///
  /// Parameters:
  /// - [variant]: The product variant to sync (optional if transaction is provided)
  /// - [serverUrl]: The base URL of the EBM server
  /// - [transaction]: Existing transaction (optional, will create one if not provided)
  /// - [sarTyCd]: Transaction type code (e.g., '06' for stock adjustment, '11' for sale)
  ///
  /// Returns: `true` if synchronization was successful, `false` otherwise
  Future<bool> syncVariantWithEbm({
    Variant? variant,
    required String serverUrl,
    ITransaction? transaction,
    String? sarTyCd,
  }) async {
    /// variant is used to save item and stock master and stock In
    /// transaction is used to save stock io
    /// sarTyCd is used to determine the type of transaction
    if (variant != null) {
      await ProxyService.tax.saveItem(variation: variant, URI: serverUrl);

      /// skip saving a service in stock master
      if (variant.itemCd != null &&
          variant.itemCd!.isNotEmpty &&
          variant.itemCd! == "3") {
        throw Exception("Service item cannot be saved in stock master");
      }
      await ProxyService.tax.saveStockMaster(variant: variant, URI: serverUrl);
    }

    Business? business = await ProxyService.strategy
        .getBusiness(businessId: ProxyService.box.getBusinessId()!);
    ITransaction? pendingTransaction;
    if (transaction == null && variant != null) {
      pendingTransaction = await ProxyService.strategy.manageTransaction(
        transactionType: TransactionType.adjustment,
        isExpense: true,
        status: PENDING,
        branchId: ProxyService.box.getBranchId()!,
      );
      await ProxyService.strategy.assignTransaction(
        variant: variant,
        doneWithTransaction: true,
        invoiceNumber: 0,
        updatableQty: variant.stock?.currentStock,
        pendingTransaction: pendingTransaction!,
        business: business!,
        randomNumber: DateTime.now().millisecondsSinceEpoch % 1000000,
        sarTyCd: "06",
      );
    } else {
      pendingTransaction = transaction;
    }
    double totalvat = 0;
    double taxB = 0;
    List<TransactionItem> items = await repository.get<TransactionItem>(
        query: Query(
            where: [Where('transactionId').isExactly(pendingTransaction!.id)]));
    Configurations taxConfigTaxB = (await repository.get<Configurations>(
            query: Query(where: [Where('taxType').isExactly("B")])))
        .first;
    for (var item in items) {
      if (item.taxTyCd == "B") {
        taxB += (item.price * item.qty);
      }
    }
    final totalTaxB = Repository.calculateTotalTax(taxB, taxConfigTaxB);
    totalvat = totalTaxB;

    try {
      /// stock io will be used to either save stock out or stock in, this will be determined by sarTyCd
      /// if sarTyCd is 11 then it is a sale
      /// if sarTyCd is 06 then it is a stock adjustment
      final responseSaveStockInput = await ProxyService.tax.saveStockItems(
        transaction: pendingTransaction,
        tinNumber: ProxyService.box.tin().toString(),
        bhFId: (await ProxyService.box.bhfId()) ?? "00",
        customerName: null,
        custTin: null,
        regTyCd: "A",
        sarTyCd: sarTyCd ?? pendingTransaction.sarTyCd!,
        custBhfId: pendingTransaction.customerBhfId,
        totalSupplyPrice: pendingTransaction.subTotal!,
        totalvat: totalvat,
        totalAmount: pendingTransaction.subTotal!,
        remark: pendingTransaction.remark ?? "",
        ocrnDt: pendingTransaction.updatedAt ?? DateTime.now().toUtc(),
        URI: serverUrl,
      );
      if (responseSaveStockInput.resultCd == "000") {
        if (variant != null) {
          variant.ebmSynced = true;
          pendingTransaction.status = COMPLETE;
          pendingTransaction.ebmSynced = true;
          await repository.upsert(pendingTransaction);
          await repository.upsert(variant);
          ProxyService.notification
              .sendLocalNotification(body: "Synced ${variant.itemCd}");
          return true;
        }
      }
    } catch (e, s) {
      talker.error(e, s);
    }
    return false;
  }

  /// Synchronizes a transaction with the EBM system.
  ///
  /// This method will sync all items in the transaction and mark the transaction
  /// as synced if successful. Only processes transactions that are complete and
  /// haven't been synced before.
  ///
  /// Parameters:
  /// - [instance]: The transaction to sync
  /// - [serverUrl]: The base URL of the EBM server
  ///
  /// Returns: `true` if synchronization was successful or not needed, `false` otherwise
  Future<bool> syncTransactionWithEbm(
      {required ITransaction instance, required String serverUrl}) async {
    if (instance.status == COMPLETE) {
      if (instance.customerName == null ||
          instance.customerTin == null ||
          instance.sarNo == null ||
          instance.receiptType == "TS" ||
          instance.receiptType == "PS" ||
          instance.ebmSynced!) {
        return false;
      }
      talker.info("Syncing transaction with ${instance.items?.length} items");

      // Variant variant = Variant.copyFromTransactionItem(item);
      // get transaction items
      await syncVariantWithEbm(
          serverUrl: serverUrl, transaction: instance, sarTyCd: "11");

      // If all items synced successfully, mark transaction as synced
      instance.ebmSynced = true;
      await repository.upsert(instance);
      talker
          .info("Successfully synced all items for transaction ${instance.id}");

      return true;
    }
    return true;
  }

  /// Synchronizes customer information with the EBM system.
  ///
  /// This method sends customer data to the tax authority's system and updates
  /// the local record to mark it as synced.
  ///
  /// Parameters:
  /// - [instance]: The customer to sync
  /// - [serverUrl]: The base URL of the EBM server
  ///
  /// Returns: `true` if synchronization was successful, `false` otherwise
  Future<bool> syncCustomerWithEbm(
      {required Customer instance, required String serverUrl}) async {
    try {
      final response = await ProxyService.tax.saveCustomer(
        customer: ICustomer.fromJson(instance.toFlipperJson()),
        URI: serverUrl,
      );
      if (response.resultCd == "000") {
        instance.ebmSynced = true;
        await repository.upsert<Customer>(instance);
        return true;
      }
    } catch (e, s) {
      talker.error(e, s);
    }
    return false;
  }
}
