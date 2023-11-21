import 'package:coingecko_api/data/market.dart';

class CryptoAsset {
  Market coin;
  double quantity;

  double get totalValue => quantity * coin.currentPrice!;

  CryptoAsset({required this.coin, required this.quantity});
}
