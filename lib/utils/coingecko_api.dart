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
  final CoinGeckoApi _api = CoinGeckoApi();

  Future<List<Market>> getCoins(
      {currency = "usd", itemsPerPage = 250, page = 1}) async {
    final CoinGeckoResult<List<Market>> coinList =
        await _api.coins.listCoinMarkets(
            vsCurrency: currency,
            order: "gecko_desc", // coin gecko's internal coin popularity rating
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
  }

  Future<Map<String, List<MarketChartData>>> getLastYearToLastMonthData(
      {required String coinId, String currency = 'eur'}) async {
    CoinGeckoResult sparkLine = await _api.coins
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
    CoinGeckoResult sparkLine = await _api.coins
        .getCoinMarketChart(id: coinId, vsCurrency: currency, days: 7);
    DateTime now = DateTime.now();
    List<MarketChartData> lastWeekData = sparkLine.data;
    List<MarketChartData> lastDayData = lastWeekData
        .where(
            (data) => data.date.isAfter(now.subtract(const Duration(days: 1))))
        .toList();

    return {
      'lastWeek': lastWeekData,
      'lastDay': lastDayData,
    };
  }

  Future<Map<String, List<MarketChartData>>> getLastHourData(
      {required String coinId, String currency = 'eur'}) async {
    CoinGeckoResult sparkLine = await _api.coins
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
