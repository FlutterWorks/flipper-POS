import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:pocketbase/pocketbase.dart';
part 'transaction.g.dart';

@JsonSerializable()
@Collection()
class Transaction extends IJsonSerializable {
  // @JsonKey(name: 'localId')
  Id? id;
  late String reference;
  late String transactionNumber;
  @Index()
  late int branchId;
  @Index(composite: [CompositeIndex('branchId')])
  late String status;
  late String transactionType;
  late double subTotal;
  late String paymentType;
  late double cashReceived;
  late double customerChangeDue;
  late String createdAt;
  // add receipt type offerered on this transaction
  /// a comma separated of the receipt type offered on this transaction eg. NR, NS etc...
  String? receiptType;
  String? updatedAt;

  int? customerId;
  String? note;

  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  @Index()
  String? remoteId;
  String action;
  int? localId;
  String? ticketName;
  @Index()
  DateTime? deletedAt;
  Transaction({
    required this.reference,
    required this.transactionNumber,
    required this.branchId,
    required this.status,
    required this.transactionType,
    required this.subTotal,
    required this.paymentType,
    required this.cashReceived,
    required this.customerChangeDue,
    required this.createdAt,
    this.receiptType,
    this.updatedAt,
    this.customerId,
    this.note,
    this.id,
    required this.lastTouched,
    required this.action,
    this.remoteId,
    this.ticketName,
    this.deletedAt,
  });

  factory Transaction.fromRecord(RecordModel record) =>
      Transaction.fromJson(record.toJson());

  factory Transaction.fromJson(Map<String, dynamic> json) {
    /// assign remoteId to the value of id because this method is used to encode
    /// data from remote server and id from remote server is considered remoteId on local
    json['deletedAt'] = json['deletedAt'] == null ||
            (json['deletedAt'] is String && json['deletedAt'].isEmpty)
        ? null
        : json['deletedAt'];
    json['remoteId'] ??= json['id'].toString();
    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now().toIso8601String()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();
    json['id'] = json['localId'];
    return _$TransactionFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = _$TransactionToJson(this);
    if (id != null) {
      data['localId'] = id;
      data['businessPhoneNumber'] = ProxyService.box.getUserPhone();
      data['businessId'] = ProxyService.box.getBusinessId();
    }
    return data;
  }
}
