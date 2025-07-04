import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_dashboard/widgets/back_button.dart' as back;
import 'package:intl/intl.dart';

class DrawerScreen extends StatefulHookConsumerWidget {
  const DrawerScreen({Key? key, required this.open, required this.drawer})
      : super(key: key);
  final String open;
  final Drawers drawer;

  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends ConsumerState<DrawerScreen>
    with CoreMiscellaneous {
  final _controller = TextEditingController();
  final _sub = GlobalKey<FormState>();
  final _routerService = locator<RouterService>();
  String? value = "0.0";

  @override
  void dispose() {
    _controller.dispose();
    _sub.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isProcessing = false;
    return SafeArea(
      child: Scaffold(
        key: const Key("openDrawerPage"),
        appBar: CustomAppBar(
          closeButton: CLOSEBUTTON.WIDGET,
          isDividerVisible: false,
          customLeadingWidget: back.CustomBackButton(),
          onPop: () async {},
        ),
        body: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: isDesktopOrWeb ? 380 : double.infinity,
            child: buildForm(isProcessing),
          ),
        ),
      ),
    );
  }

  Widget buildForm(bool isProcessing) {
    return Form(
      key: _sub,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: constraints.maxWidth < 600 ? 16 : 200,
            ),
            child: Column(
              children: [
                const Spacer(),
                buildHeader(),
                buildTextFormField(),
                buildSubmitButton(isProcessing),
                const Spacer(),
                buildLogoutButton(),
                const Spacer(),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatClosingBalance(double balance) {
    return "${NumberFormat.currency(locale: 'en', symbol: '${ProxyService.box.defaultCurrency()} ').format(balance)}";
  }

  Widget buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.open == "close" ? "Close a Business" : "Open Business",
          style: GoogleFonts.poppins(
            fontSize: 36.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        if (widget.open == "close") ...[
          Padding(
            padding: const EdgeInsets.only(left: 50.0),
            child: Text(
              _formatClosingBalance(double.tryParse(value ?? "0.0") ?? 0.0),
              style: GoogleFonts.poppins(
                fontSize: 38.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 10)
        ],
        if (widget.open != "close") ...[
          Padding(
            padding: const EdgeInsets.only(left: 80.0),
            child: Text(
              _formatClosingBalance(double.tryParse(value ?? "0.0") ?? 0.0),
              style: GoogleFonts.poppins(
                fontSize: 38.0,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget buildTextFormField() {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.number,
      onChanged: (v) {
        setState(() {
          value = v.isEmpty ? "0.0" : v;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "You need to enter the amount";
        }
        final numericValue = num.tryParse(value);
        if (numericValue == null) {
          return "Only numeric values are allowed";
        }
        return null;
      },
      decoration: InputDecoration(
        enabled: true,
        border: const OutlineInputBorder(),
        suffixIcon: const Icon(Icons.money),
        hintText: widget.open == "open" ? "Opening balance" : "Closing balance",
      ),
    );
  }

  Widget buildSubmitButton(bool isProcessing) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 8, 1, 0),
      child: Container(
        color: Colors.white70,
        width: double.infinity,
        height: 60,
        child: BoxButton(
          key: const Key('closeDrawerButton'),
          title: widget.open == "open" ? "Open Drawer" : "Close Drawer",
          onTap: () async {
            if (_sub.currentState!.validate()) {
              setState(() {
                isProcessing = true;
              });
              if (widget.open == "open") {
                handleOpenDrawer();
              } else {
                handleCloseDrawer();
              }
            }
          },
          busy: isProcessing,
        ),
      ),
    );
  }

  Future<void> handleOpenDrawer() async {
    Drawers drawer = widget.drawer;
    drawer.cashierId = ProxyService.box.getUserId();
    drawer.openingBalance = double.tryParse(_controller.text) ?? 0;
    drawer.open = true;
    ProxyService.strategy.openDrawer(
      drawer: drawer,
    );

    LoginInfo().isLoggedIn = true;
    _routerService.navigateTo(FlipperAppRoute());
  }

  void handleCloseDrawer() async {
    try {
      Drawers? drawers = await ProxyService.strategy
          .getDrawer(cashierId: ProxyService.box.getUserId()!);
      if (drawers != null) {
        ProxyService.strategy
            .closeDrawer(drawer: drawers, eod: double.parse(_controller.text));
      }
      await logOut();

      _routerService.navigateTo(LoginRoute());
    } catch (e, s) {
      talker.error(e);
      talker.error(s);
    }
  }

  Widget buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(1, 8, 1, 0),
      child: TextButton(
        key: const Key('logoutButton'),
        onPressed: () async {
          await logOut();
          _routerService.navigateTo(LoginRoute());
        },
        child: Text(
          "Logout without closing drawer ",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
