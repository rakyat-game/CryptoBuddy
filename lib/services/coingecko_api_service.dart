import 'package:coingecko_api/coingecko_api.dart';

/* check https://pub.dev/packages/coingecko_api#usage for more info about the
 dart wrapper for the coingecko api
 All methods provided by the api are asynchronous and make use of future,
 results are of the type CoinGeckoResult
 */
class CoingeckoApiService {
  final CoinGeckoApi _api = CoinGeckoApi();

  Future getCoinIDs() async {
    final coinIDList = await _api.coins.listCoins();
    return coinIDList.data;
  }

  Future getCoins({currency = "eur", itemsPerPage = 1000, page = 1}) async {
    final coinList = await _api.coins.listCoinMarkets(
        vsCurrency: currency,
        order: "gecko_desc", // market_cap_desc
        itemsPerPage: itemsPerPage,
        page: page);
    return coinList.data;
  }
}
