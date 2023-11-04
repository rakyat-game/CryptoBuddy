import 'package:coingecko_api/data/market.dart';

class CryptoAsset {
  Market coin;
  double quantity;

  double get totalValue => quantity * (coin.currentPrice ?? 0.0);

  CryptoAsset({required this.coin, required this.quantity});
}
