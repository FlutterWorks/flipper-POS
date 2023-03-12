import 'package:flipper_dashboard/discount_row.dart';
import 'package:flipper_dashboard/popup_modal.dart';
import 'package:flipper_dashboard/product_row.dart';
import 'package:flipper_dashboard/tenants_list.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:stacked/stacked.dart';
import 'add_product_buttons.dart';
import 'package:flipper_services/proxy.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_routing/routes.logger.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;

class ProductView extends StatefulWidget {
  const ProductView({
    Key? key,
  }) : super(key: key);

  @override
  State<ProductView> createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  final log = getLogger('_onCreate');
  final searchController = TextEditingController();
  bool _isFocused = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(_onSearchFocusChanged);
  }

  @override
  void dispose() {
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    setState(() {
      _isFocused = _searchFocusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductViewModel>.reactive(
      onViewModelReady: (model) async {
        model.loadTenants();
        model.productService.products = await ProxyService.isarApi
            .products(branchId: ProxyService.box.getBranchId()!);
      },
      viewModelBuilder: () => ProductViewModel(),
      builder: (context, model, child) {
        return KeyboardVisibility(
            onChanged: (bool keyboardVisible) {
              if (!keyboardVisible) {
                _searchFocusNode.unfocus();
              }
            },
            child: GestureDetector(
              onTap: () {
                final currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  // The user has tapped outside of the TextFormField
                  _searchFocusNode.unfocus();
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: ListView(
                  padding: EdgeInsets.only(top: 2),
                  children: [
                    StreamBuilder<List<Product>>(
                      initialData: model.productService.products,
                      stream: model.productService
                          .productStream(
                              branchId: ProxyService.box.getBranchId()!)
                          .transform(model.productService
                              .searchTransformer(searchController.text)),
                      builder: (context, snapshot) {
                        final products = (snapshot.data ?? [])
                            .where((p) =>
                                p.name != 'Custom Amount' && p.name != 'temp')
                            .toList();

                        return Wrap(
                          spacing: 10.0, // set spacing between items
                          runSpacing: 10.0, // set spacing between lines
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black.withOpacity(0.25),
                                ),
                              ),
                              child: ListTile(
                                dense: true,
                                trailing: _isFocused
                                    ? IconButton(
                                        onPressed: () {
                                          // Perform some action when the user taps the focused icon
                                        },
                                        // ignore: todo
                                        /// TODO: okay for mvp but need to use cancel button
                                        /// decided to wait for flutter team to support animated custom svg
                                        /// or support more animated icons
                                        /// See: https://github.com/flutter/flutter/issues/1831 for details regarding
                                        /// generic vector graphics support in Flutter.

                                        /// Shows an animated icon at a given animation [progress].
                                        ///
                                        /// The available icons are specified in [AnimatedIcons].
                                        ///
                                        /// {@youtube 560 315 https://www.youtube.com/watch?v=pJcbh8pbvJs}
                                        icon: AnimatedIcon(
                                          icon: AnimatedIcons.close_menu,
                                          progress: _searchFocusNode.hasFocus
                                              ? AlwaysStoppedAnimation(0)
                                              : AlwaysStoppedAnimation(1),
                                        ),
                                      )
                                    : IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) =>
                                                const OptionModal(
                                              child: AddProductButtons(),
                                            ),
                                          );
                                        },
                                        icon: SvgPicture.asset(
                                            "assets/plus.svg",
                                            semanticsLabel: 'plus'),
                                      ),
                                leading: IconButton(
                                  onPressed: null,
                                  icon: SvgPicture.asset("assets/search.svg",
                                      semanticsLabel: 'search'),
                                ),
                                title: TextFormField(
                                  controller: searchController,
                                  onEditingComplete: () {
                                    _searchFocusNode.unfocus();
                                  },
                                  focusNode: _searchFocusNode,
                                  onChanged: (value) {
                                    setState(() {
                                      _isFocused = true;
                                    });
                                  },
                                  decoration: InputDecoration.collapsed(
                                      hintText: 'Search items here'),
                                  keyboardType: TextInputType.text,
                                ),
                              ),
                            ),
                            products.isEmpty
                                ? Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          FluentIcons.calendar_cancel_20_filled,
                                          size: 48,
                                        ),
                                        Text('No items found'),
                                      ],
                                    ),
                                  )
                                : SizedBox.shrink(),
                            ...products.map(
                              (product) {
                                return FutureBuilder<List<Stock?>>(
                                    future: model.productService
                                        .loadStockByProductId(
                                            productId: product.id!),
                                    builder: (BuildContext context, stocks) {
                                      if (stocks.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox.shrink();
                                      }
                                      return ProductRow(
                                        color: product.color,
                                        stocks: stocks.data ?? [],
                                        model: model,
                                        product: product,
                                        name: product.name,
                                        imageUrl: product.imageUrl,
                                        edit: (productId) {
                                          GoRouter.of(context)
                                              .push("/edit/product/$productId");
                                        },
                                        addToMenu: (productId) {
                                          // ignore: todo
                                          //TODO: work on this add to menu
                                          // model.addToMenu(productId: productId);
                                        },
                                        delete: (productId) {
                                          model.deleteProduct(
                                              productId: productId);
                                        },
                                        enableNfc: (product) {
                                          // show a model with tenants to bind product to.
                                          showMaterialModalBottomSheet(
                                            expand: false,
                                            context: context,
                                            backgroundColor: Colors.white,
                                            builder: (context) => LayoutBuilder(
                                              builder: (context, constraints) =>
                                                  SizedBox(
                                                height:
                                                    constraints.maxHeight * 0.4,
                                                child: ListTenants(
                                                    tenants: model.tenants,
                                                    model: model,
                                                    product:
                                                        product as Product),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    });
                              },
                            ).toList(),
                          ],
                        );
                      },
                    ),
                    StreamBuilder<List<Discount>>(
                      stream: model.productService.discountStream(
                          branchId: ProxyService.box.getBranchId()!),
                      builder: (context, snapshot) {
                        final discounts = snapshot.data ?? [];
                        if (!ProxyService.remoteConfig.isDiscountAvailable() ||
                            discounts.isEmpty) {
                          return SizedBox.shrink();
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: discounts.map((discount) {
                            return DiscountRow(
                              discount: discount,
                              name: discount.name,
                              model: model,
                              hasImage: false,
                              delete: (id) {
                                model.deleteDiscount(id: id);
                              },
                              edit: (discount) {
                                GoRouter.of(context).push(Routes.discount);
                              },
                              applyDiscount: (discount) async {
                                await model.applyDiscount(discount: discount);
                                showSimpleNotification(
                                  const Text('Apply discount'),
                                  background: Colors.green,
                                  position: NotificationPosition.bottom,
                                );
                              },
                            );
                          }).toList(),
                        );
                      },
                    )
                  ],
                ),
              ),
            ));
      },
    );
  }
}
