import 'package:coingecko_api/coingecko_api.dart';
import 'package:coingecko_api/coingecko_result.dart';
import 'package:coingecko_api/data/enumerations.dart';
import 'package:coingecko_api/data/market.dart';

/* check https://pub.dev/packages/coingecko_api#usage for more info about the
 dart wrapper for the coingecko api
 All methods provided by the api wrapper are asynchronous and make use of Future
 */
class CoingeckoApiService {
  final CoinGeckoApi _api = CoinGeckoApi();

  Future getCoins({currency = "eur", itemsPerPage = 250, page = 1}) async {
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
          PriceChangeInterval.y1
        ]);
    return coinList.data;
  }
}
