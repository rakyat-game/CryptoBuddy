import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/controllers/coin_listing_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_api_service.dart';

void main() {
  late CoinListingController controller;
  late MockApi mockApiService;
  late List<Market> mockData;

  setUp(() {
    mockApiService = MockApi();
    controller = CoinListingController(apiService: mockApiService);
    mockData = MockApi.mockData;
  });

  group('Tests for filterCoins():', () {
    test('Returns all coins when nothing is entered', () {
      controller.searchQuery = '';
      expect(controller.filterCoins(mockData), equals(mockData));
    });

    test('Only returns coins that start with entered text', () {
      controller.searchQuery = 'Bit';
      List<Market> filteredList = controller.filterCoins(mockData);
      expect(filteredList.length, 1);
      expect(filteredList.first.name, 'Bitcoin');
    });

    test('Search is case-insensitive', () {
      controller.searchQuery = 'eThErEuM';
      List<Market> filteredList = controller.filterCoins(mockData);
      expect(filteredList.length, 1);
      expect(filteredList.first.name, 'Ethereum');
    });

    test('Returns empty list when query matches no coin', () {
      controller.searchQuery = 'NotACoin:(';
      expect(controller.filterCoins(mockData).isEmpty, isTrue);
    });

    test('Trims search query before filtering', () {
      controller.searchQuery = '  Ethereum        ';
      var filteredList = controller.filterCoins(mockData);
      expect(filteredList.length, 1);
      expect(filteredList.first.name, 'Ethereum');
    });
  });
}
