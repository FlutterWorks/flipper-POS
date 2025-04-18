import 'dart:async';

import 'package:flipper_models/db_model_export.dart';

abstract class TransactionItemInterface {
  Future<void> addTransactionItem({
    ITransaction? transaction,
    required bool partOfComposite,
    required DateTime lastTouched,
    required double discount,
    double? compositePrice,
    bool? doneWithTransaction,
    required double quantity,
    required double currentStock,
    Variant? variation,
    required double amountTotal,
    required String name,
    TransactionItem? item,
  });
  FutureOr<List<TransactionItem>> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    int? branchId,
    String? variantId,
    String? id,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
  });
  Stream<List<TransactionItem>> transactionItemsStreams({
    String? transactionId,
    int? branchId,
    DateTime? startDate,
    DateTime? endDate,
    bool? doneWithTransaction,
    bool? active,
    String? requestId,
    bool fetchRemote = false,
  });

  FutureOr<void> updateTransactionItem(
      {double? qty,
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
      double? splyAmt,
      bool? doneWithTransaction,
      int? quantityShipped,
      double? taxblAmt,
      double? totAmt,
      double? dcRt,
      double? dcAmt});
}
