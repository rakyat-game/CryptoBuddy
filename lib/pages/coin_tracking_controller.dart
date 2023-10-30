import 'dart:async';

import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/utils/sorting_metrics.dart';

import '/services/coingecko_api_service.dart';

class CoinTrackingController {
  final CoingeckoApiService apiService = CoingeckoApiService();
  late Future<dynamic> coinFuture;
  late DateTime lastRefreshTime;
  SortingMetric priceChangeInterval = SortingMetric.day;
  String? lastClickedSortingButton;
  String searchQuery = '';
  bool isMarketCapAscending = false;
  bool isPriceChangeAscending = false;
  bool lastPriceChangeSortOrder = false;

  CoinTrackingController() {
    coinFuture = apiService.getCoins();
    lastRefreshTime = DateTime.now();
  }

  Future<void> reloadData() async {
    final timeOfRefresh = DateTime.now();
    if (timeOfRefresh.difference(lastRefreshTime).inSeconds >= 60) {
      coinFuture = apiService.getCoins();
      lastRefreshTime = timeOfRefresh;
    } else {
      print("Coin data can only be refreshed every 60 seconds");
    }
  }

  List<Market> filterCoins(List<Market> coins) {
    return searchQuery == ''
        ? coins
        : coins
            .where((element) => element.name
                .toLowerCase()
                .startsWith(searchQuery.toLowerCase().trim()))
            .toList();
  }

  void setSearchQuery(String query) {
    searchQuery = query;
  }

  void sortCoins(List<Market> coinData, SortingMetric metric, bool ascending) {
    coinData.sort((a, b) {
      num? compareA;
      num? compareB;
      switch (metric) {
        case SortingMetric.marketCap:
          compareA = a.marketCap;
          compareB = b.marketCap;
          break;
        case SortingMetric.hour:
          compareA = a.priceChangePercentage1hInCurrency;
          compareB = b.priceChangePercentage1hInCurrency;
          break;
        case SortingMetric.day:
          compareA = a.priceChangePercentage24hInCurrency;
          compareB = b.priceChangePercentage24hInCurrency;
          break;
        case SortingMetric.week:
          compareA = a.priceChangePercentage7dInCurrency;
          compareB = b.priceChangePercentage7dInCurrency;
          break;
        case SortingMetric.month:
          compareA = a.priceChangePercentage30dInCurrency;
          compareB = b.priceChangePercentage30dInCurrency;
          break;
        case SortingMetric.year:
          compareA = a.priceChangePercentage1yInCurrency;
          compareB = b.priceChangePercentage1yInCurrency;
          break;
        default:
          throw ArgumentError('Invalid metric: $metric');
      }

      if (compareA == null || compareB == null) {
        compareA ??= 0; // Set to zero if null
        compareB ??= 0;
      }
      return ascending
          ? compareA.compareTo(compareB)
          : compareB.compareTo(compareA);
    });
  }

  void sortAndChangeOrder(SortingMetric metric) {
    coinFuture.then((dynamic data) {
      List<Market> coinData = data as List<Market>;
      if (metric == SortingMetric.marketCap) {
        sortCoins(coinData, metric, isMarketCapAscending);
        isMarketCapAscending = !isMarketCapAscending;
      } else {
        sortCoins(coinData, metric, isPriceChangeAscending);
        isPriceChangeAscending = !isPriceChangeAscending;
      }
    });
  }

  void sortWithCurrentOrder(SortingMetric metric) {
    coinFuture.then((dynamic data) {
      List<Market> coinData = data as List<Market>;
      sortCoins(coinData, metric, lastPriceChangeSortOrder);
    });
  }
}
