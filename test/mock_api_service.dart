import 'package:coingecko_api/data/market.dart';
import 'package:coingecko_api/data/market_chart_data.dart';
import 'package:crypto_buddy/services/coingecko_api.dart';
import 'package:mockito/mockito.dart';

class MockApi extends Mock implements CoingeckoApiService {
  static List<Market> mockData = [
    Market.fromJson({
      'id': 'stellar',
      'symbol': 'xlm',
      'name': 'Stellar',
      'current_price': 1500.0,
      'market_cap': 7.0
    }),
    Market.fromJson({
      'id': 'cardano',
      'symbol': 'ada',
      'name': 'Cardano',
      'current_price': 1000.0,
      'market_cap': 6.0
    }),
    Market.fromJson({
      'id': 'bitcoin',
      'symbol': 'btc',
      'name': 'Bitcoin',
      'current_price': 30000.0,
      'market_cap': 5.0
    }),
    Market.fromJson({
      'id': 'ethereum',
      'symbol': 'eth',
      'name': 'Ethereum',
      'current_price': 2000.0,
      'market_cap': 4.0
    }),
    Market.fromJson({
      'id': 'dogecoin',
      'symbol': 'doge',
      'name': 'Dogecoin',
      'current_price': 100.2,
      'market_cap': 1.1
    }),
    Market.fromJson({
      'id': 'litecoin',
      'symbol': 'ltc',
      'name': 'Litecoin',
      'market_cap': 3.0,
      'current_price': 500.0,
    }),
    Market.fromJson({
      'id': 'ripple',
      'symbol': 'xrp',
      'name': 'Ripple',
      'market_cap': 1.0,
      'current_price': 13.0
    }),
  ];

  @override
  Future<List<Market>> getCoins(
      {currency = "eur", itemsPerPage = 250, page = 1}) async {
    return mockData;
  }

  @override
  // uses mock data instead of making the  api call
  Future<Map<String, List<MarketChartData>>> getSparkLineData(
      {required String coinId, String currency = 'eur'}) async {
    var sparkLine = createMockMarketChartData();
    List<MarketChartData> allData = sparkLine;
    DateTime now = DateTime.now();
    List<MarketChartData> lastMonthData = allData
        .where((data) =>
            data.date.isAfter(now
                .subtract(const Duration(days: 30))
                .subtract(const Duration(seconds: 1))) ||
            data.date.isAtSameMomentAs(now.subtract(const Duration(days: 30))))
        .toList();
    List<MarketChartData> lastSixMonthsData = allData
        .where((data) =>
            data.date.isAfter(now
                .subtract(const Duration(days: 180))
                .subtract(const Duration(seconds: 1))) ||
            data.date.isAtSameMomentAs(now.subtract(const Duration(days: 180))))
        .toList();

    return {
      'lastMonth': lastMonthData,
      'lastSixMonths': lastSixMonthsData,
      'lastYear': allData,
    };
  }
}

List<MarketChartData> createMockMarketChartData() {
  List<MarketChartData> mockChartData = [];
  DateTime now = DateTime.now();
  DateTime startDate = now.subtract(const Duration(days: 365));

  for (int i = 0; i < 365; i++) {
    DateTime date = startDate.add(Duration(days: i));
    double mockPrice = i + 10;
    double mockMarketCap = i + 100;
    double mockTotalVolume = i + 1000;

    mockChartData.add(MarketChartData(date,
        price: mockPrice,
        marketCap: mockMarketCap,
        totalVolume: mockTotalVolume));
  }

  mockChartData.last =
      MarketChartData(now, price: 10, marketCap: 10, totalVolume: 10);

  return mockChartData;
}
