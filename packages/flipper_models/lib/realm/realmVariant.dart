import 'package:realm/realm.dart';

part 'realmVariant.g.dart'; // Generated by Realm

@RealmModel()
class _RealmVariant {
  late String id;
  @PrimaryKey()
  @MapTo('_id')
  late ObjectId realmId;
  late String name;

  late String color;
  late String sku;
  late String productId;
  late String unit;
  late String productName;
  late int branchId;
  late String? taxName;
  double? taxPercentage;
  late bool isTaxExempted;

  // Additional RRA fields
  String? itemSeq;
  String? isrccCd;
  String? isrccNm;
  String? isrcRt;
  String? isrcAmt;
  String? taxTyCd;
  String? bcd;
  String? itemClsCd;
  String? itemTyCd;
  String? itemStdNm;
  String? orgnNatCd;
  String? pkg;
  String? itemCd;
  String? pkgUnitCd;
  String? qtyUnitCd;
  String? itemNm;
  double? qty;
  double? prc;
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
  double? rsdQty;

  DateTime? lastTouched;

  late double supplyPrice;
  late double retailPrice;

  late String action;

  DateTime? deletedAt;

  // ... constructors and other methods remain the same
  void updateProperties(RealmVariant other) {
    id = other.id;
    name = other.name;
    color = other.color;
    sku = other.sku;
    productId = other.productId;
    unit = other.unit;
    productName = other.productName;
    branchId = other.branchId;
    taxName = other.taxName;
    taxPercentage = other.taxPercentage;
    isTaxExempted = other.isTaxExempted;
    itemSeq = other.itemSeq;
    isrccCd = other.isrccCd;
    isrccNm = other.isrccNm;
    isrcRt = other.isrcRt;
    isrcAmt = other.isrcAmt;
    taxTyCd = other.taxTyCd;
    bcd = other.bcd;
    itemClsCd = other.itemClsCd;
    itemTyCd = other.itemTyCd;
    itemStdNm = other.itemStdNm;
    orgnNatCd = other.orgnNatCd;
    pkg = other.pkg;
    itemCd = other.itemCd;
    pkgUnitCd = other.pkgUnitCd;
    qtyUnitCd = other.qtyUnitCd;
    itemNm = other.itemNm;
    qty = other.qty;
    prc = other.prc;
    splyAmt = other.splyAmt;
    tin = other.tin;
    bhfId = other.bhfId;
    dftPrc = other.dftPrc;
    addInfo = other.addInfo;
    isrcAplcbYn = other.isrcAplcbYn;
    useYn = other.useYn;
    regrId = other.regrId;
    regrNm = other.regrNm;
    modrId = other.modrId;
    modrNm = other.modrNm;
    rsdQty = other.rsdQty;
    lastTouched = other.lastTouched;
    supplyPrice = other.supplyPrice;
    retailPrice = other.retailPrice;
    action = other.action;
    deletedAt = other.deletedAt;
  }
}
