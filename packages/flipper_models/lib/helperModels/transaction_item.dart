import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
import 'DateTimeConverter.dart';
part 'transaction_item.g.dart';

@JsonSerializable()
class TransactionItem extends IJsonSerializable {
  int? id;
  late String name;

  late int transactionId;
  late int variantId;
  // quantity
  late double qty;
  late double price;
  double? discount;
  String? type;
  late double remainingStock;
  late String createdAt;
  late String updatedAt;
  late bool isTaxExempted;
  bool? isRefunded;

  /// property to help us adding new item to transaction
  bool? doneWithTransaction;
  bool? active;

  // RRA fields
  // discount rate
  double? dcRt;
  // discount amount
  double? dcAmt;

  double? taxblAmt;
  double? taxAmt;

  double? totAmt;

  /// properties from respective variants
  /// these properties will be populated when adding a variant to transactionItem from a variant
  /// I believe there can be a smart way to clean this duplicate code
  /// but I want things to work in first place then I can refactor later.
  /// add RRA fields
  String? itemSeq;
  // insurance code
  String? isrccCd;
  // insurance name
  String? isrccNm;
  // premium rate
  String? isrcRt;
  // insurance amount
  String? isrcAmt;
  // taxation type code.
  String? taxTyCd;
  // bar code
  String? bcd;
  // Item code
  String? itemClsCd;
  // Item type code
  String? itemTyCd;
  // Item standard name
  String? itemStdNm;
  // Item origin
  String? orgnNatCd;
  // packaging unit code
  String? pkg;
  // item code
  String? itemCd;

  String? pkgUnitCd;

  String? qtyUnitCd;
  // same as name but for rra happiness
  String? itemNm;
  // unit price
  // check if prc is saved as same as retailPrice again this property is same as price on this model!
  late double prc;
  // supply amount
  double? splyAmt;
  int? tin;
  String? bhfId;
  double? dftPrc;
  String? addInfo;
  String? isrcAplcbYn;
  String? useYn;
  String? regrId;
  String? regrNm;
  String? modrId;
  String? modrNm;
  double? supplyPriceAtSale;

  @JsonKey(
      includeIfNull: true, fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? lastTouched;
  @JsonKey(fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? deletedAt;
  String action;

  int branchId;

  static DateTime? _dateTimeFromJson(String? json) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.fromJson(json);
  }

  static String? _dateTimeToJson(DateTime? dateTime) {
    const dateTimeConverter = DateTimeConverter();
    return dateTimeConverter.toJson(dateTime);
  }

  TransactionItem({
    required this.id,
    required this.action,
    required this.name,
    required this.transactionId,
    required this.variantId,
    required this.qty,
    required this.price,
    required this.branchId,
    required this.remainingStock,
    required this.createdAt,
    required this.updatedAt,
    required this.isTaxExempted,
    required this.prc,
    this.discount,
    this.type,
    this.isRefunded,
    this.doneWithTransaction,
    this.active,
    this.dcRt,
    this.dcAmt,
    this.taxblAmt,
    this.taxAmt,
    this.totAmt,
    this.itemSeq,
    this.isrccCd,
    this.isrccNm,
    this.isrcRt,
    this.isrcAmt,
    this.taxTyCd,
    this.bcd,
    this.itemClsCd,
    this.itemTyCd,
    this.itemStdNm,
    this.orgnNatCd,
    this.pkg,
    this.itemCd,
    this.pkgUnitCd,
    this.qtyUnitCd,
    this.itemNm,
    this.splyAmt,
    this.tin,
    this.bhfId,
    this.dftPrc,
    this.addInfo,
    this.isrcAplcbYn,
    this.useYn,
    this.regrId,
    this.regrNm,
    this.modrId,
    this.modrNm,
    this.lastTouched,
    this.deletedAt,
    this.supplyPriceAtSale,
  });

  factory TransactionItem.fromJson(Map<String, dynamic> json) {
    json['deletedAt'] = json['deletedAt'] == null ||
            (json['deletedAt'] is String && json['deletedAt'].isEmpty)
        ? null
        : json['deletedAt'];

    json['lastTouched'] =
        json['lastTouched'].toString().isEmpty || json['lastTouched'] == null
            ? DateTime.now()
            : DateTime.parse(json['lastTouched'] ?? DateTime.now())
                .toIso8601String();

    return _$TransactionItemFromJson(json);
  }

  @override
  Map<String, dynamic> toJson() => _$TransactionItemToJson(this);
}
