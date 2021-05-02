// Mocks generated by Mockito 5.0.6 from annotations
// in flipper/test/view_models/api_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i7;

import 'package:flipper_models/models/branch.dart' as _i9;
import 'package:flipper_models/models/business.dart' as _i8;
import 'package:flipper_models/models/category.dart' as _i11;
import 'package:flipper_models/models/color.dart' as _i4;
import 'package:flipper_models/models/login.dart' as _i2;
import 'package:flipper_models/models/product.dart' as _i5;
import 'package:flipper_models/models/stock.dart' as _i10;
import 'package:flipper_models/models/sync.dart' as _i3;
import 'package:flipper_models/models/unit.dart' as _i12;
import 'package:flipper_models/models/variant_stock.dart' as _i13;
import 'package:flipper_services/abstractions/api.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: comment_references
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: prefer_const_constructors

// ignore_for_file: avoid_redundant_argument_values

class _FakeLogin extends _i1.Fake implements _i2.Login {}

class _FakeSync extends _i1.Fake implements _i3.Sync {}

class _FakePColor extends _i1.Fake implements _i4.PColor {}

class _FakeProduct extends _i1.Fake implements _i5.Product {}

/// A class which mocks [Api].
///
/// See the documentation for Mockito's code generation for more information.
class MockApi<T> extends _i1.Mock implements _i6.Api<T> {
  MockApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i2.Login> login({String? phone}) =>
      (super.noSuchMethod(Invocation.method(#login, [], {#phone: phone}),
              returnValue: Future<_i2.Login>.value(_FakeLogin()))
          as _i7.Future<_i2.Login>);
  @override
  _i7.Future<List<_i5.Product>> products() =>
      (super.noSuchMethod(Invocation.method(#products, []),
              returnValue: Future<List<_i5.Product>>.value(<_i5.Product>[]))
          as _i7.Future<List<_i5.Product>>);
  @override
  _i7.Future<int> signup({Map<dynamic, dynamic>? business}) =>
      (super.noSuchMethod(Invocation.method(#signup, [], {#business: business}),
          returnValue: Future<int>.value(0)) as _i7.Future<int>);
  @override
  _i7.Future<_i3.Sync> authenticateWithOfflineDb({String? userId}) =>
      (super.noSuchMethod(
          Invocation.method(#authenticateWithOfflineDb, [], {#userId: userId}),
          returnValue:
              Future<_i3.Sync>.value(_FakeSync())) as _i7.Future<_i3.Sync>);
  @override
  _i7.Future<List<_i8.Business>?> businesses() =>
      (super.noSuchMethod(Invocation.method(#businesses, []),
              returnValue: Future<List<_i8.Business>?>.value(<_i8.Business>[]))
          as _i7.Future<List<_i8.Business>?>);
  @override
  _i7.Future<List<_i9.Branch>> branches({String? businessId}) =>
      (super.noSuchMethod(
              Invocation.method(#branches, [], {#businessId: businessId}),
              returnValue: Future<List<_i9.Branch>>.value(<_i9.Branch>[]))
          as _i7.Future<List<_i9.Branch>>);
  @override
  _i7.Future<List<_i10.Stock>> stocks({String? productId}) => (super
          .noSuchMethod(Invocation.method(#stocks, [], {#productId: productId}),
              returnValue: Future<List<_i10.Stock>>.value(<_i10.Stock>[]))
      as _i7.Future<List<_i10.Stock>>);
  @override
  _i7.Future<List<_i4.PColor>> colors({String? branchId}) =>
      (super.noSuchMethod(Invocation.method(#colors, [], {#branchId: branchId}),
              returnValue: Future<List<_i4.PColor>>.value(<_i4.PColor>[]))
          as _i7.Future<List<_i4.PColor>>);
  @override
  _i7.Future<List<_i11.Category>> categories({String? branchId}) =>
      (super.noSuchMethod(
              Invocation.method(#categories, [], {#branchId: branchId}),
              returnValue: Future<List<_i11.Category>>.value(<_i11.Category>[]))
          as _i7.Future<List<_i11.Category>>);
  @override
  _i7.Future<List<_i12.Unit>> units({String? branchId}) =>
      (super.noSuchMethod(Invocation.method(#units, [], {#branchId: branchId}),
              returnValue: Future<List<_i12.Unit>>.value(<_i12.Unit>[]))
          as _i7.Future<List<_i12.Unit>>);
  @override
  _i7.Future<int> create<T>({Map<dynamic, dynamic>? data, String? endPoint}) =>
      (super.noSuchMethod(
          Invocation.method(#create, [], {#data: data, #endPoint: endPoint}),
          returnValue: Future<int>.value(0)) as _i7.Future<int>);
  @override
  _i7.Future<int> update<T>({Map<dynamic, dynamic>? data, String? endPoint}) =>
      (super.noSuchMethod(
          Invocation.method(#update, [], {#data: data, #endPoint: endPoint}),
          returnValue: Future<int>.value(0)) as _i7.Future<int>);
  @override
  _i7.Future<bool> delete({String? id, String? endPoint}) =>
      (super.noSuchMethod(
          Invocation.method(#delete, [], {#id: id, #endPoint: endPoint}),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
  @override
  _i7.Future<_i4.PColor> getColor({String? id, String? endPoint}) =>
      (super.noSuchMethod(
              Invocation.method(#getColor, [], {#id: id, #endPoint: endPoint}),
              returnValue: Future<_i4.PColor>.value(_FakePColor()))
          as _i7.Future<_i4.PColor>);
  @override
  _i7.Future<List<_i13.VariantStock>> variantStock(
          {String? branchId, String? variantId}) =>
      (super.noSuchMethod(
          Invocation.method(
              #variantStock, [], {#branchId: branchId, #variantId: variantId}),
          returnValue: Future<List<_i13.VariantStock>>.value(
              <_i13.VariantStock>[])) as _i7.Future<List<_i13.VariantStock>>);
  @override
  _i7.Future<List<_i13.VariantStock>> variantProduct(
          {String? branchId, String? productId}) =>
      (super.noSuchMethod(
              Invocation.method(#variantProduct, [],
                  {#branchId: branchId, #productId: productId}),
              returnValue:
                  Future<List<_i13.VariantStock>>.value(<_i13.VariantStock>[]))
          as _i7.Future<List<_i13.VariantStock>>);
  @override
  _i7.Future<int> addUnits({Map<dynamic, dynamic>? data}) =>
      (super.noSuchMethod(Invocation.method(#addUnits, [], {#data: data}),
          returnValue: Future<int>.value(0)) as _i7.Future<int>);
  @override
  _i7.Future<int> addVariant({Map<dynamic, dynamic>? data}) =>
      (super.noSuchMethod(Invocation.method(#addVariant, [], {#data: data}),
          returnValue: Future<int>.value(0)) as _i7.Future<int>);
  @override
  _i7.Future<_i5.Product> getProduct({String? id}) =>
      (super.noSuchMethod(Invocation.method(#getProduct, [], {#id: id}),
              returnValue: Future<_i5.Product>.value(_FakeProduct()))
          as _i7.Future<_i5.Product>);
  @override
  _i7.Future<_i5.Product> createProduct({_i5.Product? product}) =>
      (super.noSuchMethod(
              Invocation.method(#createProduct, [], {#product: product}),
              returnValue: Future<_i5.Product>.value(_FakeProduct()))
          as _i7.Future<_i5.Product>);
  @override
  _i7.Future<List<_i5.Product>> isTempProductExist() =>
      (super.noSuchMethod(Invocation.method(#isTempProductExist, []),
              returnValue: Future<List<_i5.Product>>.value(<_i5.Product>[]))
          as _i7.Future<List<_i5.Product>>);
  @override
  _i7.Future<bool> logOut() =>
      (super.noSuchMethod(Invocation.method(#logOut, []),
          returnValue: Future<bool>.value(false)) as _i7.Future<bool>);
}
