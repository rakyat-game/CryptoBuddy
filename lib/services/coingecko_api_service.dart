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

  Future getCoinsByMarketCap(
      {numberOfCoins = 50, currency = "eur", String? category}) async {
    final coinList = await (category == null
        ? _api.coins.listCoinMarkets(
            vsCurrency: currency,
            order: "market_cap_desc",
            itemsPerPage: numberOfCoins,
            page: 1)
        : _api.coins.listCoinMarkets(
            vsCurrency: currency,
            category: category,
            order: "market_cap_desc",
            itemsPerPage: numberOfCoins,
            page: 1));
    return coinList.data;
  }
}
