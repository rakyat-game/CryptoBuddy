import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/controllers/coin_listing_controller.dart';
import 'package:crypto_buddy/utils/sorting_metrics.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_api_service.dart';

void main() {
  late CoinListingController controller;
  late MockApi mockApiService;
  List<Market> mockData = MockApi.mockData;

  setUp(() async {
    mockApiService = MockApi();
    controller = CoinListingController(apiService: mockApiService);
    await controller.apiService.getCoins();
  });

  group('Tests for sortCoins():', () {
    test('Sort by price ascending', () {
      controller.sortCoins(mockData, SortingMetric.price, true);
      expect(mockData[0].currentPrice!,
          lessThanOrEqualTo(mockData[1].currentPrice!));
      expect(mockData[1].currentPrice!,
          lessThanOrEqualTo(mockData[2].currentPrice!));
    });

    test('Sort by price descending', () {
      controller.sortCoins(mockData, SortingMetric.price, false);
      expect(mockData[0].currentPrice!,
          greaterThanOrEqualTo(mockData[1].currentPrice!));
      expect(mockData[1].currentPrice!,
          greaterThanOrEqualTo(mockData[2].currentPrice!));
    });

    test('Sort by price with incomplete data (ascending)', () {
      mockData.add(
          Market.fromJson({'id': 'incompleteCoin', 'current_price': null}));
      controller.sortCoins(mockData, SortingMetric.price, true);
      expect(mockData.first.currentPrice, isNull);
      // null value is treated as 0.0
      expect(mockData.first.id, equals('incompleteCoin'));
    });
  });

  group('Tests for sortAndChangeOrder():', () {
    test('Changes sorting order for market cap', () async {
      await controller.apiService.getCoins();
      controller.isMarketCapAscending = true;
      await controller.sortAndChangeOrder(SortingMetric.marketCap);
      expect(controller.isMarketCapAscending, isFalse);
    });
  });

  group('Tests for sortWithCurrentOrder():', () {
    test('Keeps sorting order for market cap', () async {
      await controller.apiService.getCoins();
      controller.isMarketCapAscending = true;
      await controller.sortWithCurrentOrder(SortingMetric.marketCap);
      expect(controller.isMarketCapAscending, isTrue);
    });
  });
}
