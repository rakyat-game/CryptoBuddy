import 'package:crypto_buddy/controllers/coin_listing_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mock_api_service.dart';

void main() {
  late CoinListingController controller;
  late MockApi mockApiService;

  setUp(() {
    mockApiService = MockApi();
    controller = CoinListingController(apiService: mockApiService);
  });

  // Data provided by the API only updates every 60 seconds, hence useless
  // API calls are prohibited
  group('Tests for reloadData():', () {
    test('Reload data if > 60 seconds have passed', () async {
      controller.lastRefreshTime =
          DateTime.now().subtract(const Duration(seconds: 61));

      expect(await controller.reloadData(), isTrue);
    });

    test('Do not reload data if < 60 seconds have passed', () async {
      controller.lastRefreshTime =
          DateTime.now().subtract(const Duration(seconds: 1));

      expect(await controller.reloadData(), isFalse);
    });
    test('Only reload once in case of multiple function calls ', () async {
      controller.lastRefreshTime =
          DateTime.now().subtract(const Duration(seconds: 61));
      expect(await controller.reloadData(), isTrue);
      expect(await controller.reloadData(), isFalse);
      expect(await controller.reloadData(), isFalse);
    });
  });
}
