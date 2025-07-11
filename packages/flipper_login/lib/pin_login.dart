import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/GlobalLogError.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

class PinLogin extends StatefulWidget {
  PinLogin({Key? key}) : super(key: key);

  @override
  State<PinLogin> createState() => _PinLoginState();
}

class _PinLoginState extends State<PinLogin> with CoreMiscellaneous {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  bool _isProcessing = false;
  bool _isObscure = true;

  // Method to handle PIN login and its associated flow
  Future<void> _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isProcessing = true;
      });

      try {
        await ProxyService.box.writeBool(key: 'pinLogin', value: true);

        final pin = await _getPin();
        if (pin == null) throw PinError(term: "Not found");

        // Update local authentication
        await ProxyService.box.writeBool(key: 'isAnonymous', value: true);

        // Check if a PIN with this userId already exists in the local database
        final userId = int.tryParse(pin.userId);
        final existingPin = await ProxyService.strategy
            .getPinLocal(userId: userId!, alwaysHydrate: false);

        Pin thePin;
        if (existingPin != null) {
          // Update the existing PIN instead of creating a new one
          thePin = existingPin;

          // Update fields with the latest information
          thePin.phoneNumber = pin.phoneNumber;
          thePin.branchId = pin.branchId;
          thePin.businessId = pin.businessId;
          thePin.ownerName = pin.ownerName;

          print(
              "Using existing PIN with userId: ${pin.userId}, ID: ${thePin.id}");
        } else {
          // Create a new PIN if none exists
          thePin = Pin(
            userId: userId,
            pin: userId,
            branchId: pin.branchId,
            businessId: pin.businessId,
            ownerName: pin.ownerName,
            phoneNumber: pin.phoneNumber,
          );
          print("Creating new PIN with userId: ${pin.userId}");
        }

        await ProxyService.strategy.login(
          pin: thePin,
          isInSignUpProgress: false,
          flipperHttpClient: ProxyService.http,
          skipDefaultAppSetup: false,
          userPhone: pin.phoneNumber,
        );
        await ProxyService.strategy.completeLogin(thePin);
      } catch (e, s) {
        await _handleLoginError(e, s);
      } finally {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // Get PIN from local service
  Future<IPin?> _getPin() async {
    return await ProxyService.strategy.getPin(
      pinString: _pinController.text,
      flipperHttpClient: ProxyService.http,
    );
  }

  // Error handling for login - uses centralized error handling but keeps UI-specific code here
  Future<void> _handleLoginError(dynamic e, StackTrace s) async {
    // Use the centralized error handling from AuthMixin
    // Navigation is now handled directly in the auth_mixin.dart
    final errorDetails = await ProxyService.strategy.handleLoginError(e, s);

    // Extract the error information
    final String errorMessage = errorDetails['errorMessage'];
    GlobalErrorHandler.logError(
      e,
      stackTrace: s,
      type: 'Pin Login Error',
      extra: {
        'error_type': e.runtimeType.toString(),
      },
    );

    // Only show error message if we have one - navigation is handled in auth_mixin
    if (errorMessage.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          width: 250,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          content: Text(errorMessage, style: primaryTextStyle),
        ),
      );
    }
  }

  // Toggles the PIN visibility
  void _togglePasswordVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            key: Key('PinLogin'),
            body: Stack(
              children: [
                SizedBox(width: 85, child: back.CustomBackButton()),
                Center(
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      width: 300,
                      child: Padding(
                        padding:
                            const EdgeInsets.fromLTRB(8.0, 100.0, 8.0, 0.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPinField(),
                            const SizedBox(height: 16.0),
                            _buildLoginButton(model),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Builds the PIN input field
  Widget _buildPinField() {
    return TextFormField(
      obscureText: _isObscure,
      decoration: InputDecoration(
        labelStyle: primaryTextStyle,
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
          onPressed: _togglePasswordVisibility,
        ),
        enabled: true,
        border: const OutlineInputBorder(),
        labelText: "Enter your PIN",
      ),
      controller: _pinController,
      validator: (text) {
        if (text == null || text.isEmpty) {
          return "PIN is required";
        }
        return null;
      },
    );
  }

  // Builds the login button
  Widget _buildLoginButton(LoginViewModel model) {
    return Container(
      color: Colors.white70,
      width: double.infinity,
      height: 40,
      child: !_isProcessing
          ? BoxButton(
              key: Key("pinLoginButton_desktop"),
              borderRadius: 2,
              onTap: _handleLogin,
              title: 'Log in',
              busy: _isProcessing,
            )
          : const Padding(
              key: Key('busyButton'),
              padding: EdgeInsets.only(left: 0, right: 0),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: BoxButton(
                  title: 'Log in',
                  busy: true,
                ),
              ),
            ),
    );
  }
}
