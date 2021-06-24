import 'package:flipper/constants.dart';
import 'package:flipper_models/business.dart';
import 'package:flipper_models/login.dart';
import 'package:flipper_models/product_mock.dart';
import 'package:flipper_models/variation_mock.dart';
import 'package:flipper_models/stock_mock.dart';
import 'package:flipper_models/order_mock.dart';
import 'package:flipper_models/variants.dart';
import 'package:flipper_services/abstractions/api.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/keypad_service.dart';
import 'package:flipper_services/product_service.dart';
import 'package:flipper_services/setting_service.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';
import 'test_helpers.mocks.dart';
import 'package:flipper_services/locator.dart';

@GenerateMocks([], customMocks: [
  MockSpec<Api>(returnNullOnMissingStub: true),
  MockSpec<ProductService>(returnNullOnMissingStub: true),
  MockSpec<KeyPadService>(returnNullOnMissingStub: true),
  MockSpec<SettingsService>(returnNullOnMissingStub: true),
  MockSpec<LocalStorage>(returnNullOnMissingStub: true),
  MockSpec<AppService>(returnNullOnMissingStub: true),
  MockSpec<NavigationService>(returnNullOnMissingStub: true),
])
Api getAndRegisterApi(
    {bool hasLoggedInUser = false,
    List<Business>? businesses,
    Map? data,
    String? uri,
    List<Variant>? variations}) {
  _removeRegistrationIfExists<Api>();
  final service = MockApi();
  when(service.login()).thenAnswer(
    (_) async => Login(
      id: 1,
      email: 'email',
      synced: 1,
      name: 'ric',
      newUser: false,
      token: 't',
    ),
  );

  when(service.businesses()).thenAnswer((_) async => businesses!);
  when(service.addVariant(data: variations, retailPrice: 0.0, supplyPrice: 0.0))
      .thenAnswer((_) async => 200);
  when(service.getCustomProductVariant())
      .thenAnswer((_) async => variationMock);
  when(service.createOrder(
          customAmount: 0.0, variation: variationMock, price: 0.0, quantity: 1))
      .thenAnswer((_) async => orderMock);
  when(service.orders()).thenAnswer((_) async => [orderMock]);
  when(service.stockByVariantId(variantId: variationMock.id))
      .thenAnswer((_) async => stockMock);
  if (data != null) {
    when(service.update(data: data, endPoint: uri))
        .thenAnswer((_) async => 200);
  }
  when(service.branches(businessId: 10)).thenAnswer((_) async => [branchMock]);
  locator.registerSingleton<Api>(service);
  return service;
}

AppService getAndRegisterAppService(
    {bool hasLoggedInUser = false,
    int branchId = 11,
    String userid = 'UID',
    int businessId = 10}) {
  _removeRegistrationIfExists<AppService>();
  final service = MockAppService();
  when(service.hasLoggedInUser).thenReturn(hasLoggedInUser);
  when(service.branchId).thenReturn(branchId);
  when(service.userid).thenReturn(userid);
  when(service.businessId).thenReturn(businessId);
  when(service.currentColor).thenReturn('#ee5253');
  when(service.isLoggedIn()).thenAnswer((realInvocation) => hasLoggedInUser);
  locator.registerSingleton<AppService>(service);

  return service;
}

KeyPadService getAndRegisterKeyPadServiceUnmocked() {
  _removeRegistrationIfExists<KeyPadService>();
  final service = KeyPadService();
  locator.registerSingleton<KeyPadService>(service);
  return service;
}

KeyPadService getAndRegisterKeyPadService() {
  final service = MockKeyPadService();
  when(service.orders).thenReturn([orderMock]);

  return service;
}

ProductService getAndRegisterProductService(
    {String currentUnit = 'kg', int branchId = 11, String userId = 'UID'}) {
  _removeRegistrationIfExists<ProductService>();
  final service = MockProductService();
  when(service.currentUnit).thenReturn(currentUnit);
  when(service.branchId).thenReturn(branchId);
  when(service.userId).thenReturn(userId);
  when(service.product).thenReturn(productMock);
  locator.registerSingleton<ProductService>(service);
  return service;
}

NavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockSettingsService getAndRegisterSettingsService() {
  _removeRegistrationIfExists<SettingsService>();
  final service = MockSettingsService();
  //some mocking here
  when(service.updateSettings(map: anyNamed("map")))
      .thenAnswer((realInvocation) => Future<bool>.value(true));
  locator.registerSingleton<SettingsService>(service);
  return service;
}

MockLocalStorage getAndRegisterLocalStorage() {
  _removeRegistrationIfExists<LocalStorage>();
  final service = MockLocalStorage();
  when(service.read(key: 'userId')).thenAnswer((_) => '300');
  //TODOrepace TOKEN   here
  when(service.read(key: 'bearerToken')).thenAnswer((_) => 'TOKEN');
  when(service.read(key: 'branchId')).thenAnswer((_) => 11);
  when(service.read(key: 'businessId')).thenAnswer((_) => 10);
  when(service.read(key: pageKey)).thenAnswer((_) => 'XXX');
  when(service.write(key: pageKey, value: 'key')).thenAnswer((_) => true);

  locator.registerSingleton<LocalStorage>(service);
  return service;
}

void registerServices() {
  getAndRegisterApi();
  getAndRegisterNavigationService();
  getAndRegisterSettingsService();
  getAndRegisterLocalStorage();
  getAndRegisterAppService();
  getAndRegisterProductService();
  getAndRegisterKeyPadServiceUnmocked();
  getAndRegisterKeyPadService();
}

void unregisterServices() {
  locator.unregister<Api>();
  locator.unregister<NavigationService>();
  locator.unregister<SettingsService>();
  locator.unregister<LocalStorage>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
