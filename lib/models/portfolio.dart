import 'dart:convert';

import 'package:coingecko_api/data/market.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/format_number.dart';
import 'crypto_asset.dart';

class Portfolio extends ChangeNotifier {
  List<CryptoAsset> _assets;
  double _investment;
  double _sales;

  Portfolio(
      {required List<CryptoAsset> assets,
      double investment = 0,
      double sales = 0})
      : _assets = assets,
        _investment = investment,
        _sales = sales;

  List<CryptoAsset> get assets => _assets;
  set setAssets(List<CryptoAsset> newAssets) => _assets = newAssets;
  double get investment => _investment;
  double get sales => _sales;

  double get currentValue {
    return assets.fold(0.0, (sum, asset) => sum + asset.totalValue);
  }

  double get profitLoss {
    return currentValue + sales - investment;
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
    updatePortfolioPreferences(asset: asset);
  }

  void sellAsset(CryptoAsset asset, double quantity, double sellPrice) {
    _sales += sellPrice;
    if (Formatter.formatNumber(asset.totalValue) ==
        Formatter.formatNumber(sellPrice)) {
      if (_assets.remove(asset)) {
        updatePortfolioPreferences(asset: asset, removeAsset: true);
      }
    } else {
      try {
        CryptoAsset assetToAdjust = _assets.firstWhere(
            (assetInPortfolio) => assetInPortfolio.coin.id == asset.coin.id);
        assetToAdjust.quantity -= quantity;
        updatePortfolioPreferences(
            asset: asset, removeAsset: true, removeQuantity: quantity);
      } catch (_) {}
    }
    notifyListeners();
  }

  CryptoAsset? getAsset(Market coin) {
    try {
      return assets.firstWhere(
        (element) => element.coin.id == coin.id,
      );
    } catch (exception) {
      return null;
    }
  }

  Future<(double, double, Map<String, double>)>
      getPortfolioInfoFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> assetsInPortfolioDynamic =
        json.decode(prefs.getString('assets') ?? '{}');
    Map<String, double> assetsInPortfolio = {};
    assetsInPortfolioDynamic.forEach((key, value) {
      assetsInPortfolio[key] =
          (value is double) ? value : double.tryParse(value.toString()) ?? 0.0;
    });
    double investment = prefs.getDouble('investment') ?? 0;
    double sales = prefs.getDouble('sales') ?? 0;
    return (investment, sales, assetsInPortfolio);
  }

  Future<void> buildPortfolio(List<Market> coins) async {
    var (investment, sales, assets) = await getPortfolioInfoFromPreferences();
    _investment = investment;
    _sales = sales;
    _assets.clear();
    assets.forEach((symbol, quantity) {
      try {
        Market coin = coins.firstWhere((coin) => coin.symbol == symbol);
        _assets.add(CryptoAsset(coin: coin, quantity: quantity));
      } catch (_) {}
    });
    notifyListeners();
  }

  Future<void> updatePortfolioPreferences(
      {required CryptoAsset asset,
      bool removeAsset = false,
      double removeQuantity = 0.0}) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> assetsInPortfolioDynamic =
        json.decode(prefs.getString('assets') ?? '{}');
    Map<String, double> assetsInPortfolio = {};
    assetsInPortfolioDynamic.forEach((key, value) {
      assetsInPortfolio[key] =
          (value is double) ? value : double.tryParse(value.toString()) ?? 0.0;
    });

    String symbol = asset.coin.symbol;
    if (removeAsset && removeQuantity == 0.0) {
      assetsInPortfolio.removeWhere((key, value) => key == symbol);
      prefs.setDouble('sales', _sales);
    } else if (removeAsset) {
      assetsInPortfolio[symbol] =
          (assetsInPortfolio[symbol] ?? 0.0) - removeQuantity;
      prefs.setDouble('sales', _sales);
    } else {
      double currentQuantity = assetsInPortfolio[symbol] ?? 0.0;
      assetsInPortfolio[symbol] = currentQuantity + asset.quantity;
      prefs.setDouble('investment', investment);
    }
    prefs.setString('assets', json.encode(assetsInPortfolio));
    notifyListeners();
  }

  Future<void> clearPortfolioPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble('investment', 0);
    prefs.setDouble('sales', 0);
    prefs.setString('assets', '{}');
  }

  void resetPortfolio() {
    _sales = 0;
    _investment = 0;
    _assets = [];
    clearPortfolioPreferences().then((value) => notifyListeners());
  }
}
