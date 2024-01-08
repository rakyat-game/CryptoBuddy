import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/models/crypto_asset.dart';
import 'package:crypto_buddy/models/portfolio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  late Portfolio portfolio;
  late CryptoAsset asset1;
  late CryptoAsset asset2;

  setUp(() {
    asset1 = CryptoAsset(
      coin: Market.fromJson({
        'id': 'bitcoin',
        'symbol': 'btc',
        'name': 'Bitcoin',
        'current_price': 50000.0,
      }),
      quantity: 1,
    );

    asset2 = CryptoAsset(
      coin: Market.fromJson({
        'id': 'ethereum',
        'symbol': 'eth',
        'name': 'Ethereum',
        'current_price': 4000.0,
      }),
      quantity: 1,
    );

    portfolio = Portfolio(assets: [], investment: 0, sales: 0);
  });

  group('Tests for portfolio:', () {
    test('Buying a new asset adds it to portfolio', () {
      portfolio.buyAsset(asset1);
      expect(portfolio.assets.contains(asset1), isTrue);
      expect(portfolio.assets.length, equals(1));
      expect(portfolio.investment, equals(asset1.totalValue));
    });

    test('Buying existing asset increases its quantity', () {
      portfolio.buyAsset(asset1);
      portfolio.buyAsset(asset1);
      CryptoAsset? existingAsset = portfolio.getAsset(asset1.coin);
      expect(existingAsset?.quantity, equals(2));
      expect(portfolio.investment, equals(asset1.totalValue));
    });

    test('Current value is correctly calculated', () {
      portfolio.buyAsset(asset1);
      portfolio.buyAsset(asset2);
      double expectedCurrentValue = asset1.totalValue + asset2.totalValue;
      expect(portfolio.currentValue, equals(expectedCurrentValue));
    });

    test('Profit/Loss is correctly calculated', () {
      portfolio.buyAsset(asset1);
      portfolio.buyAsset(asset2);

      // Simulate the growth in value of both assets by creating new market objects with updated prices
      var updatedAsset1 = CryptoAsset(
        coin: Market.fromJson({
          'id': 'bitcoin',
          'symbol': 'btc',
          'name': 'Bitcoin',
          'current_price': 60000.0, // New price for Bitcoin
        }),
        quantity: asset1.quantity,
      );

      var updatedAsset2 = CryptoAsset(
        coin: Market.fromJson({
          'id': 'ethereum',
          'symbol': 'eth',
          'name': 'Ethereum',
          'current_price': 5000.0, // New price for Ethereum
        }),
        quantity: asset2.quantity,
      );

      // Update the portfolio with the new assets to reflect the price change
      portfolio.setAssets = [updatedAsset1, updatedAsset2];

      double expectedProfitLoss =
          (updatedAsset1.totalValue + updatedAsset2.totalValue) -
              portfolio.investment;
      expect(portfolio.profitLoss, equals(expectedProfitLoss));
    });

    test('Selling an asset updates sales and reduces quantity', () {
      portfolio.buyAsset(asset1);
      portfolio.sellAsset(asset1, 0.5, asset1.totalValue / 2);
      CryptoAsset? existingAsset = portfolio.getAsset(asset1.coin);
      expect(existingAsset?.quantity, equals(0.5));
      expect(portfolio.sales, equals(asset1.totalValue));
    });
  });
}
