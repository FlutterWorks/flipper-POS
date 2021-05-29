import 'dart:io';

import 'package:flipper_models/objectbox.g.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/spenn.dart';
import 'package:flipper_models/variation.dart';

import 'package:flipper_models/variant_stock.dart';

import 'package:flipper_models/unit.dart';

import 'package:flipper_models/sync.dart';

import 'package:flipper_models/stock.dart';

import 'package:flipper_models/product.dart';

import 'package:flipper_models/login.dart';

import 'package:flipper_models/color.dart';

import 'package:flipper_models/category.dart';

import 'package:flipper_models/business.dart';

import 'package:flipper_models/branch.dart';
import 'package:path_provider/path_provider.dart';
import 'abstractions/api.dart';

class ObjectBoxApi implements Api {
  late Store _store;
  ObjectBoxApi({required Directory dir}) {
    // Note: getObjectBoxModel() is generated for you in objectbox.g.dart
    _store = Store(getObjectBoxModel(), directory: dir.path + '/objectbox');
  }
  @override
  Future<List<Unit>> units({required String branchId}) async {
    return _store
        .box<Unit>()
        .getAll()
        .where((unit) => unit.branchId == branchId)
        .toList();
  }

  @override
  Future<int> addUnits({required Map data}) async {
    for (Map map in data['units']) {
      final box = _store.box<Unit>();

      final unit = Unit(
        active: false,
        branchId: data['branchId'],
        table: data['table'],
        channels: data['channels'],
        value: map['value'],
        name: map['name'],
      );

      box.put(unit);
    }
    return 200;
  }

  @override
  Future<int> addVariant(
      {required List<Variation> data,
      required double retailPrice,
      required double supplyPrice}) {
    // TODO: implement addVariant
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches({required String businessId}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> businesses() {
    // TODO: implement businesses
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> categories({required String branchId}) {
    // TODO: implement categories
    throw UnimplementedError();
  }

  @override
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderF order}) {
    // TODO: implement collectCashPayment
    throw UnimplementedError();
  }

  @override
  Future<List<PColor>> colors({required String branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  Future<int> create<T>({required Map data, required String endPoint}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<OrderF> createOrder(
      {required double customAmount,
      required Variation variation,
      required double price,
      bool useProductName = false,
      String orderType = 'custom',
      double quantity = 1}) {
    // TODO: implement createOrder
    throw UnimplementedError();
  }

  @override
  Future<Product> createProduct({required Product product}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<bool> delete({required String id, String? endPoint}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<PColor> getColor({required String id, String? endPoint}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<Variation> getCustomProductVariant() {
    // TODO: implement getCustomProductVariant
    throw UnimplementedError();
  }

  @override
  Future<Product> getProduct({required String id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> isTempProductExist() {
    // TODO: implement isTempProductExist
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<Login> login({required String phone}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<List<OrderF>> orders() {
    // TODO: implement orders
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> products() {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<int> signup({required Map business}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Spenn> spennPayment({required double amount, required phoneNumber}) {
    // TODO: implement spennPayment
    throw UnimplementedError();
  }

  @override
  Future<Stock> stockByVariantId({required String variantId}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  Stream<Stock> stockByVariantIdStream({required String variantId}) {
    // TODO: implement stockByVariantIdStream
    throw UnimplementedError();
  }

  @override
  Future<List<Stock>> stocks({required String productId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  Future<int> update<T>({required Map data, required String endPoint}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<Variation> variant({required String variantId}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  Future<List<VariantStock>> variantStock(
      {required String branchId, required String variantId}) {
    // TODO: implement variantStock
    throw UnimplementedError();
  }

  @override
  Future<List<Variation>> variants(
      {required String branchId, required String productId}) {
    // TODO: implement variants
    throw UnimplementedError();
  }

  @override
  Future<SyncF> authenticateWithOfflineDb({required String userId}) {
    // TODO: implement authenticateWithOfflineDb
    throw UnimplementedError();
  }
}
