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
      {currency = "eur", itemsPerPage = 250, page = 1}) async {
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
    print("Api call was made");
    return coinList.data;
  }

  // listCoinMarkets() only provides a spark line for 7 day interval
  Future<Map<String, List<MarketChartData>>> getSparkLineData(
      {required String coinId, String currency = 'eur'}) async {
    final CoinGeckoResult sparkLine = await _api.coins
        .getCoinMarketChart(id: coinId, vsCurrency: currency, days: 365);
    List<MarketChartData> allData = sparkLine.data;
    DateTime now = DateTime.now();
    List<MarketChartData> lastMonthData = allData
        .where(
            (data) => data.date.isAfter(now.subtract(const Duration(days: 30))))
        .toList();
    List<MarketChartData> lastSixMonthsData = allData
        .where((data) =>
            data.date.isAfter(now.subtract(const Duration(days: 180))))
        .toList();
    Map<String, List<MarketChartData>> result = {
      'lastMonth': lastMonthData,
      'lastSixMonths': lastSixMonthsData,
      'lastYear': allData,
    };
    print("Api spark line");
    return result;
  }
}
