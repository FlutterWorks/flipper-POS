import 'package:flipper_models/isar_models.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flipper_dashboard/customappbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked/stacked.dart';
import 'package:number_display/number_display.dart';

class Payments extends StatelessWidget {
  Payments({Key? key, required this.order}) : super(key: key);
  final display = createDisplay(
    length: 8,
    decimal: 0,
  );
  final Order order;
  final _routerService = locator<RouterService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
        builder: (context, model, child) {
          return SafeArea(
            child: Scaffold(
              appBar: CustomAppBar(
                onPop: () {
                  _routerService.pop();
                },
                onPressedCallback: () {
                  _routerService.pop();
                },
                title: '',
                rightActionButtonName: 'Split payment',
                icon: Icons.close,
                multi: 3,
                bottomSpacer: 52,
              ),
              body: SizedBox(
                width: double.infinity,
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          model.kOrder != null
                              ? Text(
                                  'FRw ' +
                                      display(model.totalPayable).toString(),
                                  style: const TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                )
                              : const Text('0.00'),
                          const SizedBox(height: 40),
                          const Text(
                            'Select Payment type Bellow',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _routerService.replaceWith(CollectCashViewRoute(
                                  order: order, paymentType: "cash"));
                            },
                            child: const ListTile(
                              leading: Text(
                                'Cash',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.pink,
                                size: 24.0,
                                semanticLabel: 'Cash',
                              ),
                            ),
                          ),
                          ProxyService.remoteConfig.isSpennPaymentAvailable() ||
                                  kDebugMode
                              ? GestureDetector(
                                  onTap: () {
                                    _routerService.replaceWith(
                                        CollectCashViewRoute(
                                            order: order,
                                            paymentType: "spenn"));
                                  },
                                  child: const ListTile(
                                    leading: Text(
                                      'SPENN',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: Colors.pink,
                                      size: 24.0,
                                      semanticLabel: 'SPENN',
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        onViewModelReady: (model) {
          model.updatePayable();
        },
        viewModelBuilder: () => BusinessHomeViewModel());
  }
}
