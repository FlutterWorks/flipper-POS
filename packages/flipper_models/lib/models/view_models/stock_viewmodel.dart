library flipper_models;

// import 'package:flipper_models/models/models.dart';
import 'package:flipper_models/isar/stock_sync.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';

class StockViewModel extends BaseViewModel {
  List<StockSync?> _stocks = [];
  get stocks => _stocks;

  loadStockByProductId({required int productId}) async {
    _stocks = ProxyService.isarApi.stocks(productId: productId);
    notifyListeners();
  }
}
