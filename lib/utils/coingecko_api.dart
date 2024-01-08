import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/coingecko_result.dart';
import 'package:coingecko_api/data/enumerations.dart';
import 'package:coingecko_api/data/market.dart';
import 'package:coingecko_api/data/market_chart_data.dart';

/* check https://pub.dev/packages/coingecko_api#usage for more info about the
 dart wrapper for the coingecko api
 All methods provided by the api wrapper are asynchronous and make use of Future
 */
class CoingeckoApiService {
  final CoinGeckoApi api = CoinGeckoApi();

  Future<List<Market>> getCoins(
      {String currency = "usd", int itemsPerPage = 250, int page = 1}) async {
    try {
      final CoinGeckoResult<List<Market>> coinList = await api.coins
          .listCoinMarkets(
              vsCurrency: currency,
              order: "gecko_desc",
              itemsPerPage: itemsPerPage,
              page: page,
              priceChangePercentageIntervals: [
            PriceChangeInterval.h1,
            PriceChangeInterval.h24,
            PriceChangeInterval.d7,
            PriceChangeInterval.d30,
            PriceChangeInterval.d200,
            PriceChangeInterval.y1
          ]);
      return coinList.data;
    } catch (_) {
      return [
        Market.fromJson({
          'id': 'bitcoin',
          'symbol': 'btc',
          'name': 'Bitcoin',
          'current_price': 40000.0,
        }),
        Market.fromJson({
          'id': 'ethereum',
          'symbol': 'eth',
          'name': 'Ethereum',
          'current_price': 2000.0,
        }),
      ];
    }
  }

  Future<Map<String, List<MarketChartData>>> getLastYearToLastMonthData(
      {required String coinId, String currency = 'eur'}) async {
    CoinGeckoResult sparkLine = await api.coins
        .getCoinMarketChart(id: coinId, vsCurrency: currency, days: 365);
    DateTime now = DateTime.now();
    List<MarketChartData> lastYearData = sparkLine.data;
    List<MarketChartData> lastSixMonthsData = lastYearData
        .where((data) =>
            data.date.isAfter(now.subtract(const Duration(days: 181))))
        .toList();
    List<MarketChartData> lastMonthData = lastYearData
        .where(
            (data) => data.date.isAfter(now.subtract(const Duration(days: 31))))
        .toList();

    return {
      'lastYear': lastYearData,
      'lastSixMonths': lastSixMonthsData,
      'lastMonth': lastMonthData,
    };
  }

  Future<Map<String, List<MarketChartData>>> getLastWeekToLastDayData(
      {required String coinId, String currency = 'eur'}) async {
    try {
      CoinGeckoResult sparkLine = await api.coins
          .getCoinMarketChart(id: coinId, vsCurrency: currency, days: 7);
      DateTime now = DateTime.now();
      List<MarketChartData> lastWeekData = sparkLine.data;
      List<MarketChartData> lastDayData = lastWeekData
          .where((data) =>
              data.date.isAfter(now.subtract(const Duration(days: 1))))
          .toList();

      return {
        'lastWeek': lastWeekData,
        'lastDay': lastDayData,
      };
    } catch (_) {
      return {
        'lastWeek': [],
        'lastDay': [],
      };
    }
  }

  Future<Map<String, List<MarketChartData>>> getLastHourData(
      {required String coinId, String currency = 'eur'}) async {
    CoinGeckoResult sparkLine = await api.coins
        .getCoinMarketChart(id: coinId, vsCurrency: currency, days: 1);
    DateTime now = DateTime.now();
    List<MarketChartData> lastHourData = sparkLine.data;
    lastHourData
        .where(
            (data) => data.date.isAfter(now.subtract(const Duration(hours: 1))))
        .toList();

    return {
      'lastHour': lastHourData,
    };
  }
}
