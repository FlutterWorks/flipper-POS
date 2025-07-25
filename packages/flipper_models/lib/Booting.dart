import 'package:flipper_models/helperModels/branch.dart';
import 'package:flipper_models/helperModels/business.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/permission.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;

mixin Booting {
  Future<void> saveNeccessaryData(IUser user,
      {bool usenewVersion = false}) async {
    for (ITenant tenant in user.tenants) {
      await _addOrUpdateTenant(
        tenant,
        user.id.toString(),
        usenewVersion: usenewVersion,
      );
    }
  }

  Future<void> _addOrUpdateTenant(ITenant tenant, String userId,
      {required bool usenewVersion}) async {
    final Tenant iTenant = Tenant(
      isDefault: false,
      name: tenant.name,
      businessId: tenant.businessId,
      nfcEnabled: tenant.nfcEnabled ?? false,
      email: tenant.email,
      userId: int.tryParse(userId),
      phoneNumber: tenant.phoneNumber,
      pin: tenant.pin,
    );

    await addOrUpdateBusinesses(
      tenant.businesses ?? [],
      userId,
      usenewVersion: usenewVersion,
    );
    await addOrUpdateBranches(
      tenant.branches ?? [],
      usenewVersion: usenewVersion,
    );

    await addOrUpdateTenant(
      iTenant,
      userId,
    );
  }

  Future<void> addOrUpdateTenant(
    Tenant iTenant,
    String userId,
  ) async {
    Tenant? exist =
        await ProxyService.strategy.getTenant(userId: int.parse(userId));
    if (exist == null) {
      await ProxyService.strategy.updateTenant(
          businessId: iTenant.businessId,
          branchId: ProxyService.box.getBranchId()!,
          name: iTenant.name,
          userId: int.parse(userId),
          tenantId: iTenant.id,
          sessionActive: (userId == iTenant.userId));
    }
  }

  Future<void> addOrUpdatePermissions(List<IPermission> permissions,
      {required bool usenewVersion}) async {
    final List<LPermission> permissionToAdd = [];
    final List<String> features = ['Sales', 'Inventory', 'Reports', 'Settings'];
    // permissions = permissions.isEmpty? await ProxyService.strategy.permissions(userId: ProxyService.box.getUserId()!): permissions;
    /// check that all features above are saved with admin access
    /// TODO: improve this, because permission might be empty and the user logging in is not admin
    if (permissions.isEmpty) {
      /// if permissions are empty this means if it is not the first time we are logging in
      /// in this case we just need to check if all permission for admin were saved corectly
      for (String feature in features) {
        talker.warning(
            "Permission with userId: ${ProxyService.box.getUserId()!}");
        List<Access> hasAccess = await ProxyService.strategy.access(
            userId: ProxyService.box.getUserId()!,
            featureName: feature,
            fetchRemote: true);
        if (hasAccess.isEmpty) {
          await ProxyService.strategy.addAccess(
            branchId: ProxyService.box.getBranchId()!,
            businessId: ProxyService.box.getBusinessId()!,
            userId: ProxyService.box.getUserId()!,
            featureName: feature,
            accessLevel: 'Admin'.toLowerCase(),
            status: 'active',
            userType: "Admin",
          );
        }
      }
    }
    for (IPermission permission in permissions) {
      final perm = LPermission(
        name: permission.name,
        userId: permission.userId,
      );
      permissionToAdd.add(perm);

      // Check if the permission is "admin" and handle access creation
      if (permission.name.toLowerCase() == 'admin') {
        for (String featureName in features) {
          final List<Access> existingAccess = await ProxyService.strategy
              .access(
                  userId: permission.userId,
                  featureName: featureName,
                  fetchRemote: true);

          if (existingAccess.isEmpty) {
            await ProxyService.strategy.addAccess(
              branchId: ProxyService.box.getBranchId()!,
              businessId: ProxyService.box.getBusinessId()!,
              userId: permission.userId,
              featureName: featureName,
              accessLevel: 'Admin'.toLowerCase(),
              status: 'active',
              userType: "Admin",
            );
          }
        }
      }
    }
  }

  Future<void> addOrUpdateBranches(List<IBranch> branches,
      {required bool usenewVersion}) async {
    for (IBranch branch in branches) {
      if (branch.serverId == null) continue;
      Branch? exist =
          await ProxyService.strategy.branch(serverId: branch.serverId!);
      if (exist == null) {
        await ProxyService.strategy.addBranch(
          serverId: branch.serverId!,
          location: branch.location ?? "",
          description: branch.description,
          name: branch.name!,
          businessId: branch.businessId!,
          longitude: branch.longitude,
          latitude: branch.latitude,
          isDefault: false,
          active: false,
          lastTouched: branch.lastTouched,
          deletedAt: branch.deletedAt,
        );
      }
    }
  }

  Future<void> addOrUpdateBusinesses(List<IBusiness> businesses, String userId,
      {required bool usenewVersion}) async {
    for (IBusiness business in businesses) {
      await ProxyService.strategy.addBusiness(
        id: business.id,
        phoneNumber: business.phoneNumber!,
        userId: business.userId is String
            ? int.parse(business.userId)
            : business.userId,
        encryptionKey: business.encryptionKey ?? "",
        serverId: business.serverId,
        name: business.name,
        currency: business.currency,
        categoryId: business.categoryId.toString(),
        latitude: business.latitude,
        longitude: business.longitude,
        timeZone: business.timeZone,
        country: business.country,
        businessUrl: business.businessUrl,
        hexColor: business.hexColor,
        imageUrl: business.imageUrl,
        type: business.type,
        active: false,
        chatUid: business.chatUid,
        metadata: business.metadata,
        role: business.role,
        lastSeen: business.lastSeen,
        firstName: business.firstName,
        lastName: business.lastName,
        createdAt: DateTime.now().toIso8601String(),
        deviceToken: business.deviceToken,
        backUpEnabled: business.backUpEnabled,
        subscriptionPlan: business.subscriptionPlan,
        nextBillingDate: business.nextBillingDate,
        previousBillingDate: business.previousBillingDate,
        isLastSubscriptionPaymentSucceeded:
            business.isLastSubscriptionPaymentSucceeded,
        backupFileId: business.backupFileId,
        email: business.email,
        lastDbBackup: business.lastDbBackup,
        fullName: business.fullName,
        tinNumber: business.tinNumber,
        bhfId: "00",
        dvcSrlNo: business.dvcSrlNo,
        adrs: business.adrs,
        taxEnabled: business.taxEnabled,
        taxServerUrl: "",
        isDefault: false,
        businessTypeId: business.businessTypeId,
        lastTouched: business.lastTouched,
        deletedAt: business.deletedAt,
      );
    }
  }

  Future<void> handleLoginErrorInBooting(http.Response response) async {
    if (response.statusCode == 401) {
      throw SessionException(term: "session expired");
    } else if (response.statusCode == 500) {
      throw PinError(term: "Not found");
    } else {
      throw UnknownError(term: response.statusCode.toString());
    }
  }

  Future<void> setDefaultApp(IUser user) async {
    final String defaultAppValue = user.tenants.isEmpty
        ? 'null'
        : ProxyService.box.getDefaultApp() != "POS"
            ? ProxyService.box.getDefaultApp() ?? "POS"
            : user.tenants.first.businesses!.first.businessTypeId.toString();

    await ProxyService.box
        .writeString(key: 'defaultApp', value: defaultAppValue);
  }

  Future<void> configureTheBox(String userPhone, IUser user) async {
    await ProxyService.box.writeString(key: 'userPhone', value: userPhone);
    await ProxyService.box
        .writeString(key: 'bearerToken', value: user.token ?? "");

    talker.warning("Upon login: UserId ${user.id}: UserPhone: ${userPhone}");

    /// the token from firebase that link this user with firebase
    /// so it can be used to login to other devices
    await ProxyService.box.writeString(key: 'uid', value: user.uid ?? "");
    await ProxyService.box.writeInt(key: 'userId', value: user.id!);

    int? branchId = user.tenants.first.branches?.first.serverId;
    int? businessId = user.tenants.first.businesses?.first.serverId;
    if (branchId == null) {
      // get any local saved branch
      Branch branch = await ProxyService.strategy.activeBranch();
      branchId = branch.serverId!;
    }

    // get any local saved business

    await ProxyService.box
        .writeInt(key: 'branchId', value: user.tenants.isEmpty ? 0 : branchId);

    if (businessId != null) {
      await ProxyService.box.writeInt(
          key: 'businessId', value: user.tenants.isEmpty ? 0 : businessId);
    }
    await ProxyService.box.writeString(
        key: 'encryptionKey',
        value: user.tenants.first.businesses?.first.encryptionKey ?? "");
  }
}
