import 'package:flutter/foundation.dart';

import 'crypto_asset.dart';

class PortfolioModel extends ChangeNotifier {
  final List<CryptoAsset> _assets;
  double _investment;
  double _selling;

  PortfolioModel(
      {required List<CryptoAsset> assets,
      required double investment,
      double selling = 0})
      : _assets = assets,
        _investment = investment,
        _selling = selling;

  List<CryptoAsset> get assets => _assets;
  double get investment => _investment;
  double get selling => _selling;

  double get currentValue {
    return assets.fold(0.0, (sum, asset) => sum + asset.totalValue);
  }

  double get profitLoss {
    return currentValue + selling - investment;
  }

  void buyAsset(CryptoAsset asset) {
    _investment += asset.totalValue;
    try {
      CryptoAsset existingAsset = _assets.firstWhere(
        (element) => element.coin.id == asset.coin.id,
      );
      existingAsset.quantity += asset.quantity;
    } catch (exception) {
      _assets.add(asset);
    }
    notifyListeners();
  }

  void sellAsset(CryptoAsset asset) {
    if (_assets.remove(asset)) {
      _selling += asset.totalValue;
      notifyListeners();
    }
  }
}
