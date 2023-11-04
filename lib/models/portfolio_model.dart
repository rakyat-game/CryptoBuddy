import 'crypto_asset.dart';

class PortfolioModel {
  List<CryptoAsset> assets;
  double investment;

  PortfolioModel({required this.assets, required this.investment});

  double get currentValue {
    return assets.fold(0.0, (sum, asset) => sum + asset.totalValue);
  }

  double get profitLoss {
    return currentValue - investment;
  }

  void buyAsset(CryptoAsset asset) {
    investment += asset.totalValue;
    try {
      CryptoAsset existingAsset = assets.firstWhere(
        (element) =>
            element.coin.id == asset.coin.id, // throws e if nothing is found
      );
      existingAsset.quantity += asset.quantity;
    } catch (exception) {
      assets.add(asset);
    }
  }

  void sellAsset(CryptoAsset asset) {
    assets.remove(asset);
  }
}
