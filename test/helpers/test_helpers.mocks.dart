// Mocks generated by Mockito 5.2.0 from annotations
// in flipper_rw/test/helpers/test_helpers.dart.
// Do not manually edit this file.

import 'dart:async' as _i12;
import 'dart:ui' as _i2;

import 'package:firebase_core/firebase_core.dart' as _i3;
import 'package:firebase_messaging/firebase_messaging.dart' as _i11;
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart'
    as _i4;
import 'package:flipper_models/isar_models.dart' as _i8;
import 'package:flipper_rw/stack.dart' as _i6;
import 'package:flipper_services/abstractions/location.dart' as _i19;
import 'package:flipper_services/abstractions/remote.dart' as _i10;
import 'package:flipper_services/abstractions/storage.dart' as _i17;
import 'package:flipper_services/app_service.dart' as _i18;
import 'package:flipper_services/billing_service.dart' as _i20;
import 'package:flipper_services/keypad_service.dart' as _i14;
import 'package:flipper_services/language_service.dart' as _i9;
import 'package:flipper_services/product_service.dart' as _i13;
import 'package:flipper_services/setting_service.dart' as _i15;
import 'package:flutter/material.dart' as _i16;
import 'package:logger/src/logger.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;
import 'package:stacked/stacked.dart' as _i7;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeLocale_0 extends _i1.Fake implements _i2.Locale {}

class _FakeFirebaseApp_1 extends _i1.Fake implements _i3.FirebaseApp {}

class _FakeNotificationSettings_2 extends _i1.Fake
    implements _i4.NotificationSettings {}

class _FakeLogger_3 extends _i1.Fake implements _i5.Logger {}

class _FakeStack_4<T> extends _i1.Fake implements _i6.Stack<T> {}

class _FakeReactiveValue_5<T> extends _i1.Fake implements _i7.ReactiveValue<T> {
}

class _FakeBusiness_6 extends _i1.Fake implements _i8.Business {}

class _FakePoints_7 extends _i1.Fake implements _i8.Points {}

class _FakeSubscription_8 extends _i1.Fake implements _i8.Subscription {}

/// A class which mocks [Language].
///
/// See the documentation for Mockito's code generation for more information.
class MockLanguage extends _i1.Mock implements _i9.Language {
  @override
  void setLocale({String? lang}) =>
      super.noSuchMethod(Invocation.method(#setLocale, [], {#lang: lang}),
          returnValueForMissingStub: null);
}

/// A class which mocks [LanguageService].
///
/// See the documentation for Mockito's code generation for more information.
class MockLanguageService extends _i1.Mock implements _i9.LanguageService {
  @override
  _i2.Locale get locale => (super.noSuchMethod(Invocation.getter(#locale),
      returnValue: _FakeLocale_0()) as _i2.Locale);
  @override
  void setLocale({String? lang}) =>
      super.noSuchMethod(Invocation.method(#setLocale, [], {#lang: lang}),
          returnValueForMissingStub: null);
  @override
  void listenToReactiveValues(List<dynamic>? reactiveValues) =>
      super.noSuchMethod(
          Invocation.method(#listenToReactiveValues, [reactiveValues]),
          returnValueForMissingStub: null);
  @override
  void addListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [Remote].
///
/// See the documentation for Mockito's code generation for more information.
class MockRemote extends _i1.Mock implements _i10.Remote {
  @override
  void setDefault() => super.noSuchMethod(Invocation.method(#setDefault, []),
      returnValueForMissingStub: null);
  @override
  void fetch() => super.noSuchMethod(Invocation.method(#fetch, []),
      returnValueForMissingStub: null);
  @override
  bool isChatAvailable() =>
      (super.noSuchMethod(Invocation.method(#isChatAvailable, []),
          returnValue: false) as bool);
  @override
  bool isSpennPaymentAvailable() =>
      (super.noSuchMethod(Invocation.method(#isSpennPaymentAvailable, []),
          returnValue: false) as bool);
  @override
  bool isReceiptOnEmail() =>
      (super.noSuchMethod(Invocation.method(#isReceiptOnEmail, []),
          returnValue: false) as bool);
  @override
  bool isAddCustomerToSaleAvailable() =>
      (super.noSuchMethod(Invocation.method(#isAddCustomerToSaleAvailable, []),
          returnValue: false) as bool);
  @override
  bool isPrinterAvailable() =>
      (super.noSuchMethod(Invocation.method(#isPrinterAvailable, []),
          returnValue: false) as bool);
  @override
  bool forceDateEntry() =>
      (super.noSuchMethod(Invocation.method(#forceDateEntry, []),
          returnValue: false) as bool);
  @override
  bool isAnalyticFeatureAvailable() =>
      (super.noSuchMethod(Invocation.method(#isAnalyticFeatureAvailable, []),
          returnValue: false) as bool);
  @override
  bool isSubmitDeviceTokenEnabled() =>
      (super.noSuchMethod(Invocation.method(#isSubmitDeviceTokenEnabled, []),
          returnValue: false) as bool);
  @override
  bool scannSelling() =>
      (super.noSuchMethod(Invocation.method(#scannSelling, []),
          returnValue: false) as bool);
  @override
  void config() => super.noSuchMethod(Invocation.method(#config, []),
      returnValueForMissingStub: null);
  @override
  bool isMenuAvailable() =>
      (super.noSuchMethod(Invocation.method(#isMenuAvailable, []),
          returnValue: false) as bool);
  @override
  bool isDiscountAvailable() =>
      (super.noSuchMethod(Invocation.method(#isDiscountAvailable, []),
          returnValue: false) as bool);
  @override
  bool isOrderAvailable() =>
      (super.noSuchMethod(Invocation.method(#isOrderAvailable, []),
          returnValue: false) as bool);
  @override
  bool isBackupAvailable() =>
      (super.noSuchMethod(Invocation.method(#isBackupAvailable, []),
          returnValue: false) as bool);
  @override
  bool isRemoteLoggingDynamicLinkEnabled() => (super.noSuchMethod(
      Invocation.method(#isRemoteLoggingDynamicLinkEnabled, []),
      returnValue: false) as bool);
  @override
  bool isAccessiblityFeatureAvailable() => (super.noSuchMethod(
      Invocation.method(#isAccessiblityFeatureAvailable, []),
      returnValue: false) as bool);
  @override
  bool isMapAvailable() =>
      (super.noSuchMethod(Invocation.method(#isMapAvailable, []),
          returnValue: false) as bool);
  @override
  bool isAInvitingMembersAvailable() =>
      (super.noSuchMethod(Invocation.method(#isAInvitingMembersAvailable, []),
          returnValue: false) as bool);
  @override
  bool isSyncAvailable() =>
      (super.noSuchMethod(Invocation.method(#isSyncAvailable, []),
          returnValue: false) as bool);
  @override
  bool isGoogleLoginAvailable() =>
      (super.noSuchMethod(Invocation.method(#isGoogleLoginAvailable, []),
          returnValue: false) as bool);
  @override
  bool isTwitterLoginAvailable() =>
      (super.noSuchMethod(Invocation.method(#isTwitterLoginAvailable, []),
          returnValue: false) as bool);
  @override
  bool isFacebookLoginAvailable() =>
      (super.noSuchMethod(Invocation.method(#isFacebookLoginAvailable, []),
          returnValue: false) as bool);
  @override
  bool isResetSettingEnabled() =>
      (super.noSuchMethod(Invocation.method(#isResetSettingEnabled, []),
          returnValue: false) as bool);
  @override
  bool isLinkedDeviceAvailable() =>
      (super.noSuchMethod(Invocation.method(#isLinkedDeviceAvailable, []),
          returnValue: false) as bool);
  @override
  String supportLine() =>
      (super.noSuchMethod(Invocation.method(#supportLine, []), returnValue: '')
          as String);
}

/// A class which mocks [FirebaseMessaging].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseMessaging extends _i1.Mock implements _i11.FirebaseMessaging {
  @override
  _i3.FirebaseApp get app => (super.noSuchMethod(Invocation.getter(#app),
      returnValue: _FakeFirebaseApp_1()) as _i3.FirebaseApp);
  @override
  set app(_i3.FirebaseApp? _app) =>
      super.noSuchMethod(Invocation.setter(#app, _app),
          returnValueForMissingStub: null);
  @override
  bool get isAutoInitEnabled =>
      (super.noSuchMethod(Invocation.getter(#isAutoInitEnabled),
          returnValue: false) as bool);
  @override
  _i12.Stream<String> get onTokenRefresh =>
      (super.noSuchMethod(Invocation.getter(#onTokenRefresh),
          returnValue: Stream<String>.empty()) as _i12.Stream<String>);
  @override
  Map<dynamic, dynamic> get pluginConstants =>
      (super.noSuchMethod(Invocation.getter(#pluginConstants),
          returnValue: <dynamic, dynamic>{}) as Map<dynamic, dynamic>);
  @override
  _i12.Future<_i4.RemoteMessage?> getInitialMessage() =>
      (super.noSuchMethod(Invocation.method(#getInitialMessage, []),
              returnValue: Future<_i4.RemoteMessage?>.value())
          as _i12.Future<_i4.RemoteMessage?>);
  @override
  _i12.Future<void> deleteToken() => (super.noSuchMethod(
      Invocation.method(#deleteToken, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
  @override
  _i12.Future<String?> getAPNSToken() =>
      (super.noSuchMethod(Invocation.method(#getAPNSToken, []),
          returnValue: Future<String?>.value()) as _i12.Future<String?>);
  @override
  _i12.Future<String?> getToken({String? vapidKey}) => (super.noSuchMethod(
      Invocation.method(#getToken, [], {#vapidKey: vapidKey}),
      returnValue: Future<String?>.value()) as _i12.Future<String?>);
  @override
  bool isSupported() => (super.noSuchMethod(Invocation.method(#isSupported, []),
      returnValue: false) as bool);
  @override
  _i12.Future<_i4.NotificationSettings> getNotificationSettings() =>
      (super.noSuchMethod(Invocation.method(#getNotificationSettings, []),
              returnValue: Future<_i4.NotificationSettings>.value(
                  _FakeNotificationSettings_2()))
          as _i12.Future<_i4.NotificationSettings>);
  @override
  _i12.Future<_i4.NotificationSettings> requestPermission(
          {bool? alert = true,
          bool? announcement = false,
          bool? badge = true,
          bool? carPlay = false,
          bool? criticalAlert = false,
          bool? provisional = false,
          bool? sound = true}) =>
      (super.noSuchMethod(
              Invocation.method(#requestPermission, [], {
                #alert: alert,
                #announcement: announcement,
                #badge: badge,
                #carPlay: carPlay,
                #criticalAlert: criticalAlert,
                #provisional: provisional,
                #sound: sound
              }),
              returnValue: Future<_i4.NotificationSettings>.value(
                  _FakeNotificationSettings_2()))
          as _i12.Future<_i4.NotificationSettings>);
  @override
  _i12.Future<void> sendMessage(
          {String? to,
          Map<String, String>? data,
          String? collapseKey,
          String? messageId,
          String? messageType,
          int? ttl}) =>
      (super.noSuchMethod(
              Invocation.method(#sendMessage, [], {
                #to: to,
                #data: data,
                #collapseKey: collapseKey,
                #messageId: messageId,
                #messageType: messageType,
                #ttl: ttl
              }),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i12.Future<void>);
  @override
  _i12.Future<void> setAutoInitEnabled(bool? enabled) => (super.noSuchMethod(
      Invocation.method(#setAutoInitEnabled, [enabled]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
  @override
  _i12.Future<void> setForegroundNotificationPresentationOptions(
          {bool? alert = false, bool? badge = false, bool? sound = false}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #setForegroundNotificationPresentationOptions,
                  [],
                  {#alert: alert, #badge: badge, #sound: sound}),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i12.Future<void>);
  @override
  _i12.Future<void> subscribeToTopic(String? topic) => (super.noSuchMethod(
      Invocation.method(#subscribeToTopic, [topic]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
  @override
  _i12.Future<void> unsubscribeFromTopic(String? topic) => (super.noSuchMethod(
      Invocation.method(#unsubscribeFromTopic, [topic]),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
}

/// A class which mocks [ProductService].
///
/// See the documentation for Mockito's code generation for more information.
class MockProductService extends _i1.Mock implements _i13.ProductService {
  @override
  _i5.Logger get log =>
      (super.noSuchMethod(Invocation.getter(#log), returnValue: _FakeLogger_3())
          as _i5.Logger);
  @override
  String get barCode =>
      (super.noSuchMethod(Invocation.getter(#barCode), returnValue: '')
          as String);
  @override
  List<_i8.Discount> get discounts =>
      (super.noSuchMethod(Invocation.getter(#discounts),
          returnValue: <_i8.Discount>[]) as List<_i8.Discount>);
  @override
  List<_i8.Product> get products =>
      (super.noSuchMethod(Invocation.getter(#products),
          returnValue: <_i8.Product>[]) as List<_i8.Product>);
  @override
  set products(List<_i8.Product>? value) =>
      super.noSuchMethod(Invocation.setter(#products, value),
          returnValueForMissingStub: null);
  @override
  List<_i8.Stock?> get stocks => (super.noSuchMethod(Invocation.getter(#stocks),
      returnValue: <_i8.Stock?>[]) as List<_i8.Stock?>);
  @override
  void setBarcode(String? value) =>
      super.noSuchMethod(Invocation.method(#setBarcode, [value]),
          returnValueForMissingStub: null);
  @override
  dynamic setProductUnit({String? unit}) =>
      super.noSuchMethod(Invocation.method(#setProductUnit, [], {#unit: unit}));
  @override
  dynamic setCurrentProduct({_i8.Product? product}) => super.noSuchMethod(
      Invocation.method(#setCurrentProduct, [], {#product: product}));
  @override
  _i12.Future<void> variantsProduct({int? productId}) => (super.noSuchMethod(
      Invocation.method(#variantsProduct, [], {#productId: productId}),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
  @override
  _i12.Stream<List<_i8.Product>> loadProducts({int? branchId}) =>
      (super.noSuchMethod(
              Invocation.method(#loadProducts, [], {#branchId: branchId}),
              returnValue: Stream<List<_i8.Product>>.empty())
          as _i12.Stream<List<_i8.Product>>);
  @override
  _i12.Future<void> filtterProduct({String? searchKey, int? branchId}) =>
      (super.noSuchMethod(
              Invocation.method(#filtterProduct, [],
                  {#searchKey: searchKey, #branchId: branchId}),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i12.Future<void>);
  @override
  _i12.Future<_i8.Product?> getProductByBarCode({String? code}) =>
      (super.noSuchMethod(
              Invocation.method(#getProductByBarCode, [], {#code: code}),
              returnValue: Future<_i8.Product?>.value())
          as _i12.Future<_i8.Product?>);
  @override
  _i12.Future<List<_i8.Stock?>> loadStockByProductId({int? productId}) => (super
      .noSuchMethod(
          Invocation.method(#loadStockByProductId, [], {#productId: productId}),
          returnValue: Future<List<_i8.Stock?>>.value(<_i8.Stock?>[])) as _i12
      .Future<List<_i8.Stock?>>);
  @override
  void listenToReactiveValues(List<dynamic>? reactiveValues) =>
      super.noSuchMethod(
          Invocation.method(#listenToReactiveValues, [reactiveValues]),
          returnValueForMissingStub: null);
  @override
  void addListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [KeyPadService].
///
/// See the documentation for Mockito's code generation for more information.
class MockKeyPadService extends _i1.Mock implements _i14.KeyPadService {
  @override
  _i5.Logger get log =>
      (super.noSuchMethod(Invocation.getter(#log), returnValue: _FakeLogger_3())
          as _i5.Logger);
  @override
  _i6.Stack<dynamic> get stack => (super.noSuchMethod(Invocation.getter(#stack),
      returnValue: _FakeStack_4<dynamic>()) as _i6.Stack<dynamic>);
  @override
  set stack(_i6.Stack<dynamic>? _stack) =>
      super.noSuchMethod(Invocation.setter(#stack, _stack),
          returnValueForMissingStub: null);
  @override
  String get key =>
      (super.noSuchMethod(Invocation.getter(#key), returnValue: '') as String);
  @override
  int get countOrderItems =>
      (super.noSuchMethod(Invocation.getter(#countOrderItems), returnValue: 0)
          as int);
  @override
  double get amountTotal =>
      (super.noSuchMethod(Invocation.getter(#amountTotal), returnValue: 0.0)
          as double);
  @override
  int get check =>
      (super.noSuchMethod(Invocation.getter(#check), returnValue: 0) as int);
  @override
  List<_i8.Order> get tickets => (super
          .noSuchMethod(Invocation.getter(#tickets), returnValue: <_i8.Order>[])
      as List<_i8.Order>);
  @override
  double get totalPayable =>
      (super.noSuchMethod(Invocation.getter(#totalPayable), returnValue: 0.0)
          as double);
  @override
  double get totalDiscount =>
      (super.noSuchMethod(Invocation.getter(#totalDiscount), returnValue: 0.0)
          as double);
  @override
  dynamic setItemsOnSale({int? count}) => super
      .noSuchMethod(Invocation.method(#setItemsOnSale, [], {#count: count}));
  @override
  void addKey(String? key) =>
      super.noSuchMethod(Invocation.method(#addKey, [key]),
          returnValueForMissingStub: null);
  @override
  dynamic setAmount({double? amount}) =>
      super.noSuchMethod(Invocation.method(#setAmount, [], {#amount: amount}));
  @override
  dynamic setCashReceived({double? amount}) => super
      .noSuchMethod(Invocation.method(#setCashReceived, [], {#amount: amount}));
  @override
  void toggleCheckbox({int? variantId}) => super.noSuchMethod(
      Invocation.method(#toggleCheckbox, [], {#variantId: variantId}),
      returnValueForMissingStub: null);
  @override
  _i12.Future<List<_i8.Order>> getTickets() =>
      (super.noSuchMethod(Invocation.method(#getTickets, []),
              returnValue: Future<List<_i8.Order>>.value(<_i8.Order>[]))
          as _i12.Future<List<_i8.Order>>);
  @override
  void setTotalPayable({double? amount}) => super.noSuchMethod(
      Invocation.method(#setTotalPayable, [], {#amount: amount}),
      returnValueForMissingStub: null);
  @override
  void setTotalDiscount({double? amount}) => super.noSuchMethod(
      Invocation.method(#setTotalDiscount, [], {#amount: amount}),
      returnValueForMissingStub: null);
  @override
  void setOrder(_i8.Order? order) =>
      super.noSuchMethod(Invocation.method(#setOrder, [order]),
          returnValueForMissingStub: null);
  @override
  _i12.Future<_i8.Order?> getOrder({int? branchId}) => (super.noSuchMethod(
      Invocation.method(#getOrder, [], {#branchId: branchId}),
      returnValue: Future<_i8.Order?>.value()) as _i12.Future<_i8.Order?>);
  @override
  _i12.Future<_i8.Order?> getOrderById({int? id}) =>
      (super.noSuchMethod(Invocation.method(#getOrderById, [], {#id: id}),
          returnValue: Future<_i8.Order?>.value()) as _i12.Future<_i8.Order?>);
  @override
  void reset() => super.noSuchMethod(Invocation.method(#reset, []),
      returnValueForMissingStub: null);
  @override
  void customQtyIncrease({int? qty}) =>
      super.noSuchMethod(Invocation.method(#customQtyIncrease, [], {#qty: qty}),
          returnValueForMissingStub: null);
  @override
  void increaseQty() => super.noSuchMethod(Invocation.method(#increaseQty, []),
      returnValueForMissingStub: null);
  @override
  void decreaseQty() => super.noSuchMethod(Invocation.method(#decreaseQty, []),
      returnValueForMissingStub: null);
  @override
  void pop() => super.noSuchMethod(Invocation.method(#pop, []),
      returnValueForMissingStub: null);
  @override
  void listenToReactiveValues(List<dynamic>? reactiveValues) =>
      super.noSuchMethod(
          Invocation.method(#listenToReactiveValues, [reactiveValues]),
          returnValueForMissingStub: null);
  @override
  void addListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [SettingsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSettingsService extends _i1.Mock implements _i15.SettingsService {
  @override
  _i5.Logger get log =>
      (super.noSuchMethod(Invocation.getter(#log), returnValue: _FakeLogger_3())
          as _i5.Logger);
  @override
  _i7.ReactiveValue<_i16.ThemeMode> get themeMode =>
      (super.noSuchMethod(Invocation.getter(#themeMode),
              returnValue: _FakeReactiveValue_5<_i16.ThemeMode>())
          as _i7.ReactiveValue<_i16.ThemeMode>);
  @override
  bool get enablePrinter =>
      (super.noSuchMethod(Invocation.getter(#enablePrinter), returnValue: false)
          as bool);
  @override
  bool get sendDailReport => (super
          .noSuchMethod(Invocation.getter(#sendDailReport), returnValue: false)
      as bool);
  @override
  bool get isAttendanceEnabled =>
      (super.noSuchMethod(Invocation.getter(#isAttendanceEnabled),
          returnValue: false) as bool);
  @override
  void setThemeMode(_i16.ThemeMode? mode) =>
      super.noSuchMethod(Invocation.method(#setThemeMode, [mode]),
          returnValueForMissingStub: null);
  @override
  _i12.Future<bool> updateSettings({Map<dynamic, dynamic>? map}) =>
      (super.noSuchMethod(Invocation.method(#updateSettings, [], {#map: map}),
          returnValue: Future<bool>.value(false)) as _i12.Future<bool>);
  @override
  _i12.Future<_i8.Setting?> settings() => (super.noSuchMethod(
      Invocation.method(#settings, []),
      returnValue: Future<_i8.Setting?>.value()) as _i12.Future<_i8.Setting?>);
  @override
  _i12.Future<bool> isDailyReportEnabled() =>
      (super.noSuchMethod(Invocation.method(#isDailyReportEnabled, []),
          returnValue: Future<bool>.value(false)) as _i12.Future<bool>);
  @override
  _i12.Future<bool> enabledPrint() =>
      (super.noSuchMethod(Invocation.method(#enabledPrint, []),
          returnValue: Future<bool>.value(false)) as _i12.Future<bool>);
  @override
  void enablePrint({bool? bool}) =>
      super.noSuchMethod(Invocation.method(#enablePrint, [], {#bool: bool}),
          returnValueForMissingStub: null);
  @override
  void getEnableReportToggleState() =>
      super.noSuchMethod(Invocation.method(#getEnableReportToggleState, []),
          returnValueForMissingStub: null);
  @override
  void getEnableAttendanceToggleState() =>
      super.noSuchMethod(Invocation.method(#getEnableAttendanceToggleState, []),
          returnValueForMissingStub: null);
  @override
  void toggleAttendanceSetting() =>
      super.noSuchMethod(Invocation.method(#toggleAttendanceSetting, []),
          returnValueForMissingStub: null);
  @override
  void toggleDailyReportSetting() =>
      super.noSuchMethod(Invocation.method(#toggleDailyReportSetting, []),
          returnValueForMissingStub: null);
  @override
  _i12.Future<Function?> enableAttendance({bool? bool, Function? callback}) =>
      (super.noSuchMethod(
          Invocation.method(
              #enableAttendance, [], {#bool: bool, #callback: callback}),
          returnValue: Future<Function?>.value()) as _i12.Future<Function?>);
  @override
  void listenToReactiveValues(List<dynamic>? reactiveValues) =>
      super.noSuchMethod(
          Invocation.method(#listenToReactiveValues, [reactiveValues]),
          returnValueForMissingStub: null);
  @override
  void addListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [LocalStorage].
///
/// See the documentation for Mockito's code generation for more information.
class MockLocalStorage extends _i1.Mock implements _i17.LocalStorage {
  @override
  dynamic read({String? key}) =>
      super.noSuchMethod(Invocation.method(#read, [], {#key: key}));
  @override
  dynamic remove({String? key}) =>
      super.noSuchMethod(Invocation.method(#remove, [], {#key: key}));
  @override
  bool write({String? key, dynamic value}) => (super.noSuchMethod(
      Invocation.method(#write, [], {#key: key, #value: value}),
      returnValue: false) as bool);
  @override
  bool getNeedAccountLinkWithPhone() =>
      (super.noSuchMethod(Invocation.method(#getNeedAccountLinkWithPhone, []),
          returnValue: false) as bool);
  @override
  bool isPoroformaMode() =>
      (super.noSuchMethod(Invocation.method(#isPoroformaMode, []),
          returnValue: false) as bool);
  @override
  bool isTrainingMode() =>
      (super.noSuchMethod(Invocation.method(#isTrainingMode, []),
          returnValue: false) as bool);
  @override
  bool isAnonymous() => (super.noSuchMethod(Invocation.method(#isAnonymous, []),
      returnValue: false) as bool);
  @override
  bool isAutoPrintEnabled() =>
      (super.noSuchMethod(Invocation.method(#isAutoPrintEnabled, []),
          returnValue: false) as bool);
  @override
  bool isAutoBackupEnabled() =>
      (super.noSuchMethod(Invocation.method(#isAutoBackupEnabled, []),
          returnValue: false) as bool);
  @override
  bool hasSignedInForAutoBackup() =>
      (super.noSuchMethod(Invocation.method(#hasSignedInForAutoBackup, []),
          returnValue: false) as bool);
}

/// A class which mocks [AppService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppService extends _i1.Mock implements _i18.AppService {
  @override
  _i5.Logger get log =>
      (super.noSuchMethod(Invocation.getter(#log), returnValue: _FakeLogger_3())
          as _i5.Logger);
  @override
  List<_i8.Category> get categories =>
      (super.noSuchMethod(Invocation.getter(#categories),
          returnValue: <_i8.Category>[]) as List<_i8.Category>);
  @override
  _i8.Business get business => (super.noSuchMethod(Invocation.getter(#business),
      returnValue: _FakeBusiness_6()) as _i8.Business);
  @override
  List<_i8.Unit> get units =>
      (super.noSuchMethod(Invocation.getter(#units), returnValue: <_i8.Unit>[])
          as List<_i8.Unit>);
  @override
  List<_i8.PColor> get colors => (super.noSuchMethod(Invocation.getter(#colors),
      returnValue: <_i8.PColor>[]) as List<_i8.PColor>);
  @override
  String get currentColor =>
      (super.noSuchMethod(Invocation.getter(#currentColor), returnValue: '')
          as String);
  @override
  bool get hasLoggedInUser => (super
          .noSuchMethod(Invocation.getter(#hasLoggedInUser), returnValue: false)
      as bool);
  @override
  List<_i8.Business> get contacts =>
      (super.noSuchMethod(Invocation.getter(#contacts),
          returnValue: <_i8.Business>[]) as List<_i8.Business>);
  @override
  void setCustomer(_i8.Customer? customer) =>
      super.noSuchMethod(Invocation.method(#setCustomer, [customer]),
          returnValueForMissingStub: null);
  @override
  dynamic setCurrentColor({String? color}) => super
      .noSuchMethod(Invocation.method(#setCurrentColor, [], {#color: color}));
  @override
  dynamic setBusiness({_i8.Business? business}) => super
      .noSuchMethod(Invocation.method(#setBusiness, [], {#business: business}));
  @override
  void loadCategories() =>
      super.noSuchMethod(Invocation.method(#loadCategories, []),
          returnValueForMissingStub: null);
  @override
  _i12.Future<void> loadUnits() => (super.noSuchMethod(
      Invocation.method(#loadUnits, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
  @override
  _i12.Future<void> loadColors() => (super.noSuchMethod(
      Invocation.method(#loadColors, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
  @override
  bool isLoggedIn() => (super.noSuchMethod(Invocation.method(#isLoggedIn, []),
      returnValue: false) as bool);
  @override
  _i12.Future<void> loadContacts() => (super.noSuchMethod(
      Invocation.method(#loadContacts, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
  @override
  _i12.Future<void> appInit() => (super.noSuchMethod(
      Invocation.method(#appInit, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
  @override
  _i12.Future<bool> setActiveBranch({_i8.Business? businesses}) =>
      (super.noSuchMethod(
          Invocation.method(#setActiveBranch, [], {#businesses: businesses}),
          returnValue: Future<bool>.value(false)) as _i12.Future<bool>);
  @override
  _i12.Future<void> setActiveBusiness(List<_i8.Business>? businesses) =>
      (super.noSuchMethod(Invocation.method(#setActiveBusiness, [businesses]),
              returnValue: Future<void>.value(),
              returnValueForMissingStub: Future<void>.value())
          as _i12.Future<void>);
  @override
  _i12.Future<void> bootstraper() => (super.noSuchMethod(
      Invocation.method(#bootstraper, []),
      returnValue: Future<void>.value(),
      returnValueForMissingStub: Future<void>.value()) as _i12.Future<void>);
  @override
  void listenToReactiveValues(List<dynamic>? reactiveValues) =>
      super.noSuchMethod(
          Invocation.method(#listenToReactiveValues, [reactiveValues]),
          returnValueForMissingStub: null);
  @override
  void addListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(void Function()? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}

/// A class which mocks [FlipperLocation].
///
/// See the documentation for Mockito's code generation for more information.
class MockFlipperLocation extends _i1.Mock implements _i19.FlipperLocation {
  @override
  _i12.Future<Map<String, String>> getLocation() => (super.noSuchMethod(
          Invocation.method(#getLocation, []),
          returnValue: Future<Map<String, String>>.value(<String, String>{}))
      as _i12.Future<Map<String, String>>);
  @override
  _i12.Future<bool> doWeHaveLocationPermission() =>
      (super.noSuchMethod(Invocation.method(#doWeHaveLocationPermission, []),
          returnValue: Future<bool>.value(false)) as _i12.Future<bool>);
}

/// A class which mocks [BillingService].
///
/// See the documentation for Mockito's code generation for more information.
class MockBillingService extends _i1.Mock implements _i20.BillingService {
  @override
  _i5.Logger get log =>
      (super.noSuchMethod(Invocation.getter(#log), returnValue: _FakeLogger_3())
          as _i5.Logger);
  @override
  _i12.Future<_i8.Voucher?> useVoucher({int? voucher, int? userId}) =>
      (super.noSuchMethod(
              Invocation.method(
                  #useVoucher, [], {#voucher: voucher, #userId: userId}),
              returnValue: Future<_i8.Voucher?>.value())
          as _i12.Future<_i8.Voucher?>);
  @override
  _i8.Points addPoints({int? points, int? userId}) => (super.noSuchMethod(
      Invocation.method(#addPoints, [], {#points: points, #userId: userId}),
      returnValue: _FakePoints_7()) as _i8.Points);
  @override
  _i12.Future<_i8.Subscription> updateSubscription(
          {int? userId,
          int? interval,
          List<_i8.Feature>? features,
          String? descriptor,
          double? amount}) =>
      (super.noSuchMethod(
              Invocation.method(#updateSubscription, [], {
                #userId: userId,
                #interval: interval,
                #features: features,
                #descriptor: descriptor,
                #amount: amount
              }),
              returnValue:
                  Future<_i8.Subscription>.value(_FakeSubscription_8()))
          as _i12.Future<_i8.Subscription>);
  @override
  _i12.Future<bool> activeSubscription() =>
      (super.noSuchMethod(Invocation.method(#activeSubscription, []),
          returnValue: Future<bool>.value(false)) as _i12.Future<bool>);
  @override
  void monitorSubscription({int? userId}) => super.noSuchMethod(
      Invocation.method(#monitorSubscription, [], {#userId: userId}),
      returnValueForMissingStub: null);
}
