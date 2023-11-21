import 'package:flutter_test/flutter_test.dart';

import 'mock_api_service.dart';

void main() {
  group('Tests for CoingeckoApiService', () {
    test('getSparkLineData() returns correct number of data', () async {
      final mockApi = MockApi();
      final data = await mockApi.getSparkLineData(coinId: 'bitcoin');
      expect(data['lastMonth']?.length, 30);
      expect(data['lastSixMonths']?.length, 180);
      expect(data['lastYear']?.length, 365);
    });

    test('getSparkLineData() returns correct date range for each interval',
        () async {
      final mockApi = MockApi();
      final data = await mockApi.getSparkLineData(coinId: 'bitcoin');

      DateTime now = DateTime.now();
      expect(data['lastMonth']?.first.date.day,
          equals(now.subtract(const Duration(days: 30)).day));
      expect(data['lastMonth']?.last.date.day, equals(now.day));

      expect(data['lastSixMonths']?.first.date.day,
          equals(now.subtract(const Duration(days: 180)).day));
      expect(data['lastSixMonths']?.last.date.day, equals(now.day));

      expect(data['lastYear']?.first.date.day,
          equals(now.subtract(const Duration(days: 365)).day));
      expect(data['lastYear']?.last.date.day, equals(now.day));
    });

    test('getSparkLineData() returns correct values', () async {
      final mockApi = MockApi();
      final data = await mockApi.getSparkLineData(coinId: 'bitcoin');

      double mockPrice = 10;
      for (var chartData in data['lastMonths'] ?? []) {
        expect(chartData.price, mockPrice);
        mockPrice += 10;
      }
    });
  });
}
