import 'package:flipper_models/realm_model_export.dart';

abstract class DefaultInterface {
  Future<Branch?> defaultBranch();
  Future<Business?> defaultBusiness();
}
