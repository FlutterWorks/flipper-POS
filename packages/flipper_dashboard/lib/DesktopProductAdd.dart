// ignore_for_file: unused_result

import 'dart:async';
import 'dart:io';

import 'package:flipper_dashboard/CountryOfOriginSelector.dart';
import 'package:flipper_dashboard/DropdownButtonWithLabel.dart';
import 'package:flipper_dashboard/FieldCompositeActivated.dart';
import 'package:flipper_dashboard/ProductTypeDropdown.dart';
import 'package:flipper_dashboard/SearchProduct.dart';
import 'package:flipper_dashboard/CompositeVariation.dart';
import 'package:flipper_dashboard/TableVariants.dart';
import 'package:flipper_dashboard/ToggleButtonWidget.dart';
import 'package:flipper_dashboard/create/browsePhotos.dart';
import 'package:flipper_models/helperModels/hexColor.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/all_providers.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_dashboard/features/product/widgets/invoice_number_modal.dart';
import 'package:flipper_dashboard/features/product/widgets/add_category_modal.dart';

class ProductEntryScreen extends StatefulHookConsumerWidget {
  const ProductEntryScreen({super.key, this.productId});

  final String? productId;

  @override
  ProductEntryScreenState createState() => ProductEntryScreenState();
}

class ProductEntryScreenState extends ConsumerState<ProductEntryScreen>
    with TransactionMixinOld {
  Color pickerColor = Colors.amber;
  bool isColorPicked = false;

  Map<String, TextEditingController> _rates = {};
  Map<String, TextEditingController> _dates = {};

  String selectedPackageUnitValue = "BJ: Bucket Bucket";
  String? selectedCategoryId;

  TextEditingController productNameController = TextEditingController();
  TextEditingController retailPriceController = TextEditingController();
  TextEditingController supplyPriceController = TextEditingController();
  TextEditingController countryOfOriginController = TextEditingController();
  TextEditingController scannedInputController = TextEditingController();
  TextEditingController barCodeController = TextEditingController();
  TextEditingController skuController = TextEditingController();
  FocusNode scannedInputFocusNode = FocusNode();
  Timer? _inputTimer;
  final _formKey = GlobalKey<FormState>();
  final _fieldComposite = GlobalKey<FormState>();

  // Helper function to get a valid color or a default color
  Color getColorOrDefault(String? hexColor) {
    if (hexColor == null || hexColor.isEmpty) {
      return Colors.amber;
    }
    try {
      return HexColor(hexColor);
    } catch (e) {
      return Colors.amber;
    }
  }

  // Helper function to check if a string is a valid hexadecimal color code
  void _showNoProductNameToast() {
    toast('No product name!');
  }

  void _showNoProductSavedToast() {
    toast('No Product saved!');
  }

  void _showNoCategorySelectedToast() {
    toast('Please select a category!');
  }

  Future<void> _saveProductAndVariants(
      ScannViewModel model, BuildContext context, Product productRef,
      {required String selectedProductType}) async {
    try {
      ref.read(loadingProvider.notifier).startLoading();

      if (model.kProductName == null) {
        _showNoProductNameToast();
        ref.read(loadingProvider.notifier).stopLoading();
        return;
      }

      if (selectedCategoryId == null) {
        ref.read(loadingProvider.notifier).stopLoading();
        _showNoCategorySelectedToast();
        return;
      }

      if (_formKey.currentState!.validate() &&
          !ref.watch(isCompositeProvider)) {
        if (widget.productId != null) {
          await model.bulkUpdateVariants(true,
              color: pickerColor.toHex(),
              categoryId: selectedCategoryId,
              productName: productNameController.text,
              selectedProductType: selectedProductType,
              newRetailPrice: double.tryParse(retailPriceController.text) ?? 0,
              rates: _rates,
              dates: _dates,
              onCompleteCallback: (List<Variant> variants) async {
            final invoiceNumber = await showInvoiceNumberModal(context);
            if (invoiceNumber == null) return;

            final pendingTransaction =
                await ProxyService.strategy.manageTransaction(
              transactionType: TransactionType.adjustment,
              isExpense: true,
              branchId: ProxyService.box.getBranchId()!,
            );
            Business? business = await ProxyService.strategy
                .getBusiness(businessId: ProxyService.box.getBusinessId()!);

            for (Variant variant in variants) {
              // Handle the transaction for stock adjustment
              await ProxyService.strategy.assignTransaction(
                variant: variant,
                doneWithTransaction: true,
                invoiceNumber: invoiceNumber,
                pendingTransaction: pendingTransaction!,
                business: business!,
                randomNumber: randomNumber(),
                // 06 is incoming adjustment.
                sarTyCd: "06",
              );
            }

            if (pendingTransaction != null) {
              await completeTransaction(pendingTransaction: pendingTransaction);
            }
          });
        } else {
          await model.addVariant(
            model: model,
            productName: model.kProductName!,
            countryofOrigin: countryOfOriginController.text.isEmpty
                ? "RW"
                : countryOfOriginController.text,
            rates: _rates,
            color: pickerColor.toHex(),
            dates: _dates,
            retailPrice: double.tryParse(retailPriceController.text) ?? 0,
            supplyPrice: double.tryParse(supplyPriceController.text) ?? 0,
            variations: model.scannedVariants,
            product: productRef,
            selectedProductType: selectedProductType,
            packagingUnit: selectedPackageUnitValue.split(":")[0],
            categoryId: selectedCategoryId,
            onCompleteCallback: (List<Variant> variants) async {
              final invoiceNumber = await showInvoiceNumberModal(context);
              if (invoiceNumber == null) return;

              final pendingTransaction =
                  await ProxyService.strategy.manageTransaction(
                transactionType: TransactionType.adjustment,
                isExpense: true,
                branchId: ProxyService.box.getBranchId()!,
              );
              Business? business = await ProxyService.strategy
                  .getBusiness(businessId: ProxyService.box.getBusinessId()!);

              for (Variant variant in variants) {
                // Handle the transaction for stock adjustment
                await ProxyService.strategy.assignTransaction(
                  variant: variant,
                  doneWithTransaction: true,
                  invoiceNumber: invoiceNumber,
                  pendingTransaction: pendingTransaction!,
                  business: business!,
                  randomNumber: randomNumber(),
                  // 06 is incoming adjustment.
                  sarTyCd: "06",
                );
              }

              if (pendingTransaction != null) {
                await completeTransaction(
                    pendingTransaction: pendingTransaction);
              }
            },
          );
        }

        model.currentColor = pickerColor.toHex();

        await model.saveProduct(
            mproduct: productRef,
            color: model.currentColor,
            inUpdateProcess: widget.productId != null,
            productName: model.kProductName!);

        // Refresh the product list

        final combinedNotifier = ref.read(refreshProvider);
        combinedNotifier.performActions(productName: "", scanMode: true);
        ref.read(loadingProvider.notifier).stopLoading();
      } else if (_fieldComposite.currentState?.validate() ?? false) {
        await _handleCompositeProductSave(model);
      }
    } catch (e) {
      ref.read(loadingProvider.notifier).stopLoading();
      toast("We did not close normally, check if your product is saved");
      rethrow;
    }
  }

  Future<void> _handleCompositeProductSave(ScannViewModel model) async {
    try {
      ref.read(loadingProvider.notifier).startLoading();

      List<VariantState> partOfComposite =
          ref.watch(selectedVariantsLocalProvider);

      // Save each composite component
      for (var component in partOfComposite) {
        ProxyService.strategy.saveComposite(
          composite: Composite(
            businessId: ProxyService.box.getBusinessId(),
            productId: ref.read(unsavedProductProvider)!.id,
            qty: component.quantity,
            actualPrice: double.tryParse(retailPriceController.text) ?? 0.0,
            branchId: ProxyService.box.getBranchId(),
            variantId: component.variant.id,
          ),
        );
      }

      // Update the product
      await ProxyService.strategy.updateProduct(
        productId: ref.read(unsavedProductProvider)!.id,
        branchId: ProxyService.box.getBranchId()!,
        businessId: ProxyService.box.getBusinessId()!,
        name: productNameController.text,
        isComposite: true,
      );

      // Create default variant
      await ProxyService.strategy.createVariant(
        tinNumber: ProxyService.box.tin(),
        branchId: ProxyService.box.getBranchId()!,
        itemSeq: 1,
        qty: 1,
        barCode: barCodeController.text,
        sku: int.tryParse(skuController.text) ?? 1,
        retailPrice: double.tryParse(retailPriceController.text) ?? 0,
        supplierPrice: double.tryParse(supplyPriceController.text) ?? 0,
        productId: ref.read(unsavedProductProvider)!.id,
        color: ref.read(unsavedProductProvider)!.color,
        name: productNameController.text,
      );

      // Refresh the list
      final combinedNotifier = ref.read(refreshProvider);
      combinedNotifier.performActions(productName: "", scanMode: true);
      ref.read(selectedVariantsLocalProvider.notifier).clearState();
      ref.read(loadingProvider.notifier).stopLoading();
    } catch (e) {
      ref.read(loadingProvider.notifier).stopLoading();
      toast("Failed to save composite product: ${e.toString()}");
      talker.error("Error saving composite product: $e");
      // Don't close the dialog automatically on error
    }
  }

  void _onSaveButtonPressed(
      ScannViewModel model, BuildContext context, Product product,
      {required String selectedProductType}) async {
    try {
      if (model.scannedVariants.isEmpty && widget.productId == null) {
        _showNoProductSavedToast();
        return;
      }
      //
      await _saveProductAndVariants(model, context, product,
          selectedProductType: selectedProductType);
    } catch (e) {
      toast("Error saving product: ${e.toString()}");
      talker.error("Error in _onSaveButtonPressed: $e");
    }
  }

// Define your default color
  Color DEFAULT_COLOR = Colors.grey;

  // Add this new method to create the product type dropdown

  // Add a state variable to hold the selected product type
  String selectedProductType = "2";

  @override
  void dispose() {
    _inputTimer?.cancel();
    productNameController.dispose();
    retailPriceController.dispose();
    scannedInputController.dispose();
    supplyPriceController.dispose();
    scannedInputFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productRef = ref.watch(unsavedProductProvider);

    return ViewModelBuilder<ScannViewModel>.reactive(
      viewModelBuilder: () => ScannViewModel(),
      onViewModelReady: (model) async {
        if (widget.productId != null) {
          // Load existing product if productId is given

          Product product =
              await model.getProduct(productId: widget.productId!);
          ref.read(unsavedProductProvider.notifier).emitProduct(value: product);

          // Populate product name with the name of the product being edited
          productNameController.text = product.name;
          model.setProductName(name: product.name);

          // Populate variants related to the product
          List<Variant> variants = await ProxyService.strategy.variants(
              productId: widget.productId!,
              branchId: ProxyService.box.getBranchId()!);

          /// populate the supplyPrice and retailPrice of the first item
          /// this in assumption that all variants added has same supply and retail price
          /// but this will change in future when we support for variant to have different
          /// prices
          supplyPriceController.text = variants.first.supplyPrice.toString();
          retailPriceController.text = variants.first.retailPrice.toString();

          // Set the selectedCategoryId from the first variant's categoryId
          if (variants.isNotEmpty && variants.first.categoryId != null) {
            setState(() {
              selectedCategoryId = variants.first.categoryId;
            });
          }

          model.setScannedVariants(variants);

          // If there are variants, set the color to the color of the first variant
          if (variants.isNotEmpty) {
            pickerColor = getColorOrDefault(variants.first.color!);
          }
        } else {
          // If productId is not given, create a new product
          Product? product = await model.createProduct(
            name: TEMP_PRODUCT,
            createItemCode: false,
          );
          ref
              .read(unsavedProductProvider.notifier)
              .emitProduct(value: product!);
        }

        model.initialize();
      },
      builder: (context, model, child) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 18, right: 18),
              child: SizedBox(
                width: double.infinity,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      topButtons(context, model, productRef),

                      /// toggle between is composite vs non-composite product
                      ToggleButtonWidget(),

                      /// End of toggle
                      productNameField(model),
                      retailPrice(model),
                      supplyPrice(model),
                      // Add the product type dropdown here

                      !ref.watch(isCompositeProvider)
                          ? scanField(model, productRef: productRef)
                          : SizedBox.shrink(),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: DropdownButtonWithLabel(
                                label: "Packaging Unit",
                                selectedValue: selectedPackageUnitValue,
                                options: model.pkgUnits,
                                onChanged: (String? newValue) {
                                  if (newValue != null) {
                                    setState(() {
                                      selectedPackageUnitValue = newValue;
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Consumer(
                                // Keep consumer here
                                builder: (context, ref, child) {
                                  // Watch provider inside the builder
                                  final categoryAsyncValue =
                                      ref.watch(categoryProvider);
                                  // Use .when to handle states
                                  return categoryAsyncValue.when(
                                    data: (categories) {
                                      // Map Category objects to a Map of id:name pairs for internal use
                                      final categoryOptions = categories
                                          .map((cat) => "${cat.id}:${cat.name}")
                                          .toList();

                                      // Create a display map for showing only names in the dropdown
                                      final displayNames = Map.fromEntries(
                                          categories.map((cat) => MapEntry(
                                              "${cat.id}:${cat.name}",
                                              cat.name)));

                                      return DropdownButtonWithLabel(
                                        onAdd: () {
                                          showAddCategoryModal(context);
                                        },
                                        label: "Category",
                                        selectedValue: selectedCategoryId,
                                        // Pass both the options and display names
                                        options: categoryOptions,
                                        displayNames: displayNames,
                                        onChanged: (String? newValue) {
                                          if (newValue != null) {
                                            final value = newValue.split(":");

                                            setState(() {
                                              selectedCategoryId = value[0];
                                            });
                                          }
                                        },
                                      );
                                    },
                                    loading: () => DropdownButtonWithLabel(
                                      label: "Category",
                                      selectedValue: null,
                                      options: const [],
                                      onChanged: (String? _) {},
                                    ),
                                    error: (err, stack) =>
                                        DropdownButtonWithLabel(
                                      label: "Category",
                                      selectedValue: null,
                                      options: const [], // No options on error
                                      onChanged:
                                          (String? _) {}, // Disable dropdown
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      // _productTypeDropDown(context),
                      ProductTypeDropdown(
                        selectedValue: selectedProductType,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedProductType = newValue!;
                          });
                        },
                      ),
                      CountryOfOriginSelector(
                        onCountrySelected: (Country country) {
                          print("Selected country: ${country.name}");
                          countryOfOriginController.text = country.code;
                        },
                      ),

                      !ref.watch(isCompositeProvider)
                          ? TableVariants(
                              onDateChanged: (String variantId, DateTime date) {
                                _dates[variantId] = TextEditingController(
                                    text: date.toIso8601String());
                              },
                              unversalProducts:
                                  ref.watch(universalProductsNames).value,
                              units:
                                  ref.watch(unitsProvider).value?.value ?? [],
                              scannedInputFocusNode: scannedInputFocusNode,
                              unitOfMeasures: [],
                              model: model,
                              onUnitOfMeasureChanged: (newValue) {
                                if (newValue != null) {
                                  // Loop through model.scannedVariants
                                  for (var scannedVariant
                                      in model.scannedVariants) {
                                    // Update the variant.unit with the value of newValue
                                    scannedVariant.unit = newValue;
                                    break; // Exit the loop since the variant is found and updated
                                  }
                                }
                              },
                            )
                          : SizedBox.shrink(),
                      ref.watch(isCompositeProvider)
                          ? Fieldcompositeactivated(
                              formKey: _fieldComposite,
                              skuController: skuController,
                              barCodeController: barCodeController,
                            )
                          : SizedBox.shrink(),
                      ref.watch(isCompositeProvider)
                          ? SearchProduct()
                          : SizedBox.shrink(),
                      ref.watch(isCompositeProvider)
                          ? Padding(
                              padding: EdgeInsets.all(16),
                              child: Text("Components"),
                            )
                          : SizedBox.shrink(),
                      ref.watch(isCompositeProvider)
                          ? CompositeVariation(
                              supplyPriceController: supplyPriceController)
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
              ),
            ),
            Consumer(
              builder: (context, ref, child) {
                final loadingState = ref.watch(loadingProvider);
                return loadingState.isLoading
                    ? Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String?> getImageFilePath({required String imageFileName}) async {
    Directory appSupportDir = await getApplicationSupportDirectory();

    final imageFilePath = '${appSupportDir.path}/$imageFileName';
    final file = File(imageFilePath);

    if (await file.exists()) {
      return imageFilePath;
    } else {
      return null;
    }
  }

  Widget topButtons(
      BuildContext context, ScannViewModel productModel, Product? productRef) {
    return ViewModelBuilder.nonReactive(
        viewModelBuilder: () => UploadViewModel(),
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          if (_formKey.currentState!.validate() &&
                              !ref.watch(isCompositeProvider)) {
                            if (productRef == null) {
                              toast("Invalid product reference");
                              return;
                            }

                            _onSaveButtonPressed(
                              selectedProductType: selectedProductType,
                              productModel,
                              context,
                              productRef,
                            );
                          } else if (_fieldComposite.currentState?.validate() ??
                              false) {
                            await _handleCompositeProductSave(productModel);
                          }
                        } catch (e) {
                          toast("An unexpected error occurred");
                          talker.error("Error in save button: $e");
                        }
                      },
                      child: const Text('Save'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        /// close the dialog
                        Navigator.maybePop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Background color
                        foregroundColor: Colors.white, // Text color
                      ),
                      child: const Text('Close'),
                    )
                  ],
                ),
              ),
              if (ref.watch(unsavedProductProvider)?.imageUrl != null)
                FutureBuilder<String?>(
                  future: getImageFilePath(
                      imageFileName:
                          ref.watch(unsavedProductProvider)!.imageUrl!),
                  builder: (context, snapshot) {
                    return Browsephotos(
                      imageUrl: ref.watch(unsavedProductProvider)?.imageUrl,
                      currentColor: pickerColor,
                      onColorSelected: (Color color) {
                        setState(() {
                          pickerColor = color;
                          isColorPicked = true;
                        });
                      },
                    );
                  },
                )
              else
                Browsephotos(
                  imageUrl: null,
                  currentColor: pickerColor,
                  onColorSelected: (Color color) {
                    setState(() {
                      pickerColor = color;
                      isColorPicked = true;
                    });
                  },
                ),
            ],
          );
        });
  }

  Padding productNameField(ScannViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: productNameController,
        textInputAction: TextInputAction.next,
        onChanged: (value) {
          model.setProductName(name: value);
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Product name is required';
          } else if (value.length < 3) {
            return 'Product name must be at least 3 characters long';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: 'Product Name',
          labelStyle: const TextStyle(
            // Add labelStyle
            color: Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          // When in error state
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
          // When in error state and focused
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          ),
        ),
      ),
    );
  }

  Container previewName(ScannViewModel model) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      alignment: Alignment.center,
      child: Text(
        'Product Name: ${model.kProductName}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Padding scanField(ScannViewModel model, {Product? productRef}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        controller: scannedInputController,
        decoration: InputDecoration(
          labelText: 'Scan or Type',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        textInputAction: TextInputAction.done,
        validator: (value) {
          final retailPrice = double.tryParse(retailPriceController.text);
          final supplyPrice = double.tryParse(supplyPriceController.text);

          if (retailPrice == null) {
            return 'Retail Price cannot be null or invalid';
          }
          if (supplyPrice == null) {
            return 'Supply Price cannot be null or invalid';
          }

          return null;
        },
        onFieldSubmitted: (barCodeInput) {
          if (Form.of(scannedInputFocusNode.context!).validate()) {
            _inputTimer?.cancel();
            talker
                .warning("Starting timer for barcode: ${barCodeInput.trim()}");

            _inputTimer = Timer(const Duration(seconds: 1), () {
              talker.warning(
                  "Timer completed for barcode: ${barCodeInput.trim()}");

              if (barCodeInput.trim().isNotEmpty) {
                try {
                  model.onScanItem(
                    countryCode: countryOfOriginController.text.isEmpty == true
                        ? "RW"
                        : countryOfOriginController.text,
                    editmode: widget.productId != null,
                    barCode: barCodeInput,
                    retailPrice:
                        double.tryParse(retailPriceController.text) ?? 0,
                    supplyPrice:
                        double.tryParse(supplyPriceController.text) ?? 0,
                    isTaxExempted: false,
                    product: productRef!,
                  );
                  talker.warning("onAddVariant called successfully");
                } catch (e, s) {
                  talker.error("Error in onAddVariant: $e", s);
                  toast("We faced unexpted, close this window and open again");
                }

                scannedInputController.clear();
                scannedInputFocusNode.requestFocus();
              }
            });
          }
        },
        focusNode: scannedInputFocusNode,
      ),
    );
  }

  Padding supplyPrice(ScannViewModel model) {
    bool isComposite = ref.watch(isCompositeProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: supplyPriceController,
        readOnly: isComposite,
        onChanged: (value) => model.setSupplyPrice(price: value),
        decoration: InputDecoration(
          labelText: 'Cost',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          filled: isComposite, // Fill the background color when read-only
          fillColor: isComposite
              ? Colors.grey[200]
              : null, // Light grey background when read-only
          suffixIcon: isComposite
              ? Icon(Icons.lock,
                  color: Colors.grey) // Lock icon to indicate read-only
              : null,
        ),
        keyboardType: TextInputType.number,
        style: TextStyle(
          color: isComposite
              ? Colors.grey
              : Colors.black, // Lighter text color when read-only
        ),
      ),
    );
  }

  Padding retailPrice(ScannViewModel model) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        controller: retailPriceController,
        onChanged: (value) => model.setRetailPrice(price: value),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Price is required';
          }

          // Use tryParse to check if the value can be converted to a double
          if (double.tryParse(value) == null) {
            return 'Wrong value given';
          }

          return null; // Validation passed
        },
        decoration: InputDecoration(
          labelText: 'Price',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
