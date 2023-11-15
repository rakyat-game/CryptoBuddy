import 'package:flutter/foundation.dart';

import 'crypto_asset.dart';

class PortfolioModel extends ChangeNotifier {
  final List<CryptoAsset> _assets;
  double _investment;

  PortfolioModel(
      {required List<CryptoAsset> assets, required double investment})
      : _assets = assets,
        _investment = investment;

  List<CryptoAsset> get assets => _assets;
  double get investment => _investment;

  double get currentValue {
    return _assets.fold(0.0, (sum, asset) => sum + asset.totalValue);
  }

  double get profitLoss {
    return currentValue - _investment;
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
    _assets.remove(asset);
    notifyListeners();
  }
}
