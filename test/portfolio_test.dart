import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/models/crypto_asset.dart';
import 'package:crypto_buddy/models/portfolio_model.dart';
import 'package:flutter_test/flutter_test.dart';

late PortfolioModel portfolio;
late CryptoAsset asset1;
late CryptoAsset asset2;

void main() {
  setUp(() {
    asset1 = CryptoAsset(
      coin: Market.fromJson({
        'id': 'stellar',
        'symbol': 'xlm',
        'name': 'Stellar',
        'current_price': 1500.0,
      }),
      quantity: 1,
    );

    asset2 = CryptoAsset(
      coin: Market.fromJson({
        'id': 'cardano',
        'symbol': 'ada',
        'name': 'Cardano',
        'current_price': 1000.0,
      }),
      quantity: 1,
    );

    portfolio = PortfolioModel(assets: [], investment: 0);
  });
  group('Tests for portfolio:', () {
    test('Buying a new asset adds it to portfolio', () {
      portfolio.buyAsset(asset1);
      expect(portfolio.assets.contains(asset1), isTrue);
      expect(portfolio.assets.length, equals(1));
    });

    test('Buying existing asset increases its quantity', () {
      portfolio.buyAsset(asset1);
      portfolio.buyAsset(asset1);
      expect(portfolio.assets.first.quantity, equals(2));
    });

    test('Selling asset removes it from portfolio', () {
      portfolio.buyAsset(asset1);
      portfolio.sellAsset(asset1); //sells all holdings of the coin as of now
      expect(portfolio.assets.contains(asset1), isFalse);
    });

    test('Current value is correctly calculated', () {
      portfolio.buyAsset(asset1);
      portfolio.buyAsset(asset2);
      expect(portfolio.currentValue, equals(2500));
    });

    test('Profit/Loss is correctly calculated', () {
      portfolio.buyAsset(asset1);
      portfolio.buyAsset(asset2);
      expect(portfolio.profitLoss,
          equals(0)); // sales + coin holdings - investment
    });
  });
}
