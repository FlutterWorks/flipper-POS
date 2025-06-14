library flipper_models;

import 'dart:developer';

// import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/app_service.dart';
import 'package:flipper_services/locator.dart' as loc;
import 'package:flutter/cupertino.dart';

import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'gate.dart';

class SignupViewModel extends ReactiveViewModel {
  final appService = loc.getIt<AppService>();
  final _routerService = locator<RouterService>();
  bool registerStart = false;

  String? longitude = '1';
  String? latitude = '1';

  String? kName;
  void setName({String? name}) {
    kName = name;
  }

  String? kFullName;
  void setFullName({String? name}) {
    kFullName = name;
  }

  String? kCountry;
  void setCountry({String? country}) {
    kCountry = country;
  }

  String? _tin;
  String? get tin => _tin;
  set tin(String? value) {
    _tin = value;
    notifyListeners();
  }

  var _businessType = null;
  BusinessType get businessType => _businessType;
  set businessType(BusinessType value) {
    _businessType = value;
    notifyListeners();
  }

  void registerLocation() async {
    final permission = await ProxyService.location.hasLocationPermission();
    if (permission) {
      final Map<String, String> location =
          await ProxyService.location.getLocations();
      longitude = location['longitude'];
      latitude = location['latitude'];

      notifyListeners();
    } else {
      final Map<String, String> location =
          await ProxyService.location.getLocations();
      longitude = location['longitude'];
      latitude = location['latitude'];
      notifyListeners();
    }
  }

  BuildContext? context;
  Future<void> signup() async {
    try {
      startRegistering();
      setDefaultApp();

      String? referralCode = getReferralCode();

      Business? business = await registerTenant(referralCode);

      if (business != null) {
        await postRegistrationTasks(business);
      }
    } catch (e, stackTrace) {
      stopRegistering();
      talker.error(stackTrace.toString());
      throw Exception(stackTrace);
    }
  }

  void startRegistering() {
    registerStart = true;
    notifyListeners();
  }

  void stopRegistering() {
    registerStart = false;
    notifyListeners();
  }

  void setDefaultApp() {
    ProxyService.box.writeString(key: defaultApp, value: businessType.id);
  }

  String? getReferralCode() {
    return ProxyService.box.readString(key: 'referralCode');
  }

  Future<Business?> registerTenant(String? referralCode) async {
    try {
      int userId = ProxyService.box.getUserId()!;
      String phoneNumber = ProxyService.box.getUserPhone()!;
      final business = {
        'name': kName,
        'latitude': latitude,
        'longitude': longitude,
        'phoneNumber': phoneNumber,
        'currency': 'RWF',
        'createdAt': DateTime.now().toIso8601String(),
        'userId': userId,
        "tinNumber": tin != null ? int.parse(tin!) : 1111,
        'businessTypeId': "1", //businessType.id, // default to 1 for now
        'type': 'Business',
        'bhfid': '00',
        'referredBy': referralCode ?? 'Organic',
        'fullName': kFullName,
        'country': kCountry
      };
      talker.info(business.toString());
      final bus = await ProxyService.strategy
          .signup(business: business, flipperHttpClient: ProxyService.http);
      return bus;
    } catch (e, s) {
      talker.error(s);
      talker.error(e);
      rethrow;
    }
  }

  Future<void> postRegistrationTasks(Business busine) async {
    await saveBusinessId(busine);
    Business? business = await getBusiness(busine.serverId);
    List<Branch> branches = await getBranches(business!);
    await saveBranchId(branches);

    appService.appInit();
    await createDefaultCategory(branches);
    await createDefaultColor(branches);
    // save default Access permission as admin on key features
    // await addDefaultUnits();
    ProxyService.forceDateEntry.dataBootstrapper();

    LoginInfo().isLoggedIn = true;
    LoginInfo().redirecting = false;
    LoginInfo().needSignUp = false;
    _routerService.navigateTo(StartUpViewRoute());
  }

  Future<void> saveBusinessId(Business business) {
    return ProxyService.box.writeInt(
      key: 'businessId',
      value: business.serverId,
    );
  }

  Future<Business?> getBusiness(int businessId) async {
    return await ProxyService.strategy.getBusiness(businessId: businessId);
  }

  Future<List<Branch>> getBranches(Business business) async {
    return ProxyService.strategy
        .branches(serverId: business.serverId, fetchOnline: false);
  }

  Future<void> saveBranchId(List<Branch> branches) {
    return ProxyService.box
        .writeInt(key: 'branchId', value: branches[0].serverId!);
  }

  Future<void> createDefaultCategory(List<Branch> branches) async {
    final Category category = Category(
      active: true,
      focused: true,
      name: "NONE",
      branchId: branches[0].serverId!,
    );
    ProxyService.strategy.create<Category>(data: category);
  }

  Future<void> createDefaultColor(List<Branch> branches) async {
    final PColor color = PColor(
      colors: [
        '#d63031',
        '#0984e3',
        '#e84393',
        '#2d3436',
        '#6c5ce7',
        '#74b9ff',
        '#ff7675',
        '#a29bfe'
      ],
      active: false,
      lastTouched: DateTime.now().toUtc(),
      branchId: branches[0].serverId,
      name: 'color',
    );
    ProxyService.strategy.create<PColor>(data: color);
  }
}
