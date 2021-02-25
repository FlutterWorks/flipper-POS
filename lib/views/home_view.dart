import 'package:flipper/views/flipper_drawer.dart';
import 'package:flipper/views/home_app_bar.dart';
import 'package:flipper/views/product/add/add_product_modal.dart';
import 'package:pos/pos.dart';
import 'package:flipper/views/product/product_view.dart';
import 'package:pos/payable/payable_view.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flipper/widget/bottom_menu_bar.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:pos/pos_viewmodel.dart';
import 'home_viewmodel.dart';

// ignore: must_be_immutable
class HomeView extends StatelessWidget {
  final ValueNotifier<bool> sideOpenController;
  final CommonViewModel vm;
  final bool showAppBar;

  // ignore: sort_constructors_first
  HomeView({
    Key key,
    @required this.sideOpenController,
    this.showAppBar = false,
    this.vm,
  }) : super(key: key);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // ignore!
  // ignore: missing_return
  Widget _getPage(
      {@required int index,
      @required CommonViewModel vm,
      @required PosViewModel model}) {
    switch (index) {
      case 0:
        return KeyPad(model: model);
        break;
      // case 2:
      //   return ChatRoom();
      //   break;
      case 1:
        return ProductView(userId: vm.user.id, items: true);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        builder: (BuildContext context, HomeViewModel model, Widget child) {
          return Scaffold(
            extendBody: true,
            backgroundColor: Theme.of(context)
                .copyWith(canvasColor: Colors.white)
                .canvasColor,
            key: _scaffoldKey,
            appBar: HomeAppBar(
              scaffoldKey: _scaffoldKey,
              sideOpenController: sideOpenController,
              model: model,
            ),
            floatingActionButton: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddProductModal(
                        userId: vm.user.id,
                      );
                    },
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    const Icon(Icons.add,
                        size: 20,
                        // These colors are not defined in the Material Design spec.
                        color: Colors.white),
                    const Text(
                      ' Add Product',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.miniCenterDocked,
            bottomNavigationBar: BottomMenubar(
              model: model,
            ),
            body: ViewModelBuilder<PosViewModel>.reactive(
              builder: (BuildContext context, PosViewModel pos, Widget child) {
                return Column(
                  children: <Widget>[
                    model.tab == 1
                        ? PayableView(model: pos)
                        : const SizedBox.shrink(),
                    Expanded(
                      child: Container(
                        child: SafeArea(
                          child: Container(
                            child:
                                _getPage(index: model.tab, vm: vm, model: pos),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
              viewModelBuilder: () => PosViewModel(),
            ),
            drawer: FlipperDrawer(),
          );
        },
        onModelReady: (HomeViewModel model) {
          //TODO: init a listner to keypad + button for us to creat new order
          // do other logic in the backend.
          model.initTab();
          // model.listenKeyPad();
          // model.countItemOnCurrentOrder();
        },
        viewModelBuilder: () => HomeViewModel());
  }
}
