import 'dart:async';

import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/utils/sorting_metrics.dart';
import 'package:flutter/material.dart';

import '../utils/coingecko_api.dart';
import '../utils/favorites.dart';

class CoinListingController {
  final CoingeckoApiService apiService;
  late Future<List<Market>> coinData;
  late DateTime lastRefreshTime;
  late int refreshWaitTime; // in seconds
  SortingMetric priceChangeInterval = SortingMetric.day;
  String? lastClickedSortingButton;
  String searchQuery = '';
  bool isMarketCapAscending = false;
  bool isPriceChangeAscending = false;
  bool lastPriceChangeSortOrder = false;
  bool isPriceAscending = false;
  bool isSortingBarVisible = false;
  Color refreshButtonColor = Colors.grey.shade800;
  bool isLoaded = false;
  bool showFavoredCoins = false;

  CoinListingController({required this.apiService}) {
    coinData = apiService.getCoins(currency: 'usd');
    lastRefreshTime = DateTime.now();
    refreshWaitTime = 60;
  }

  Future<bool> reloadData() async {
    final timeOfRefresh = DateTime.now();
    final int timeDifference =
        timeOfRefresh.difference(lastRefreshTime).inSeconds;

    if (timeDifference > 60) {
      coinData = apiService.getCoins(currency: 'usd');
      lastRefreshTime = timeOfRefresh;
      return true;
    } else {
      refreshWaitTime = 60 - timeDifference;
      return false;
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

  Future<List<Market>> getFavoredCoins() async {
    List<String> favoredIds = await FavoritesService.getFavorites();
    return coinData.then((value) =>
        value.where((coin) => favoredIds.contains(coin.id)).toList());
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
        case SortingMetric.price:
          compareA = a.currentPrice;
          compareB = b.currentPrice;
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
        case SortingMetric.sixMonths:
          compareA = a.priceChangePercentage200dInCurrency;
          compareB = b.priceChangePercentage200dInCurrency;
          break;
        case SortingMetric.year:
          compareA = a.priceChangePercentage1yInCurrency;
          compareB = b.priceChangePercentage1yInCurrency;
          break;
        default:
          throw Exception('Invalid metric: $metric');
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

  Future<void> sortAndChangeOrder(SortingMetric metric) async {
    await coinData.then((dynamic data) {
      List<Market> coinData = data as List<Market>;
      if (metric == SortingMetric.marketCap) {
        sortCoins(coinData, metric, isMarketCapAscending);
        isMarketCapAscending = !isMarketCapAscending;
      } else if (metric == SortingMetric.price) {
        sortCoins(coinData, metric, isPriceAscending);
        isPriceAscending = !isPriceAscending;
      } else {
        sortCoins(coinData, metric, isPriceChangeAscending);
        isPriceChangeAscending = !isPriceChangeAscending;
      }
    });
  }

  Future<void> sortWithCurrentOrder(SortingMetric metric) async {
    coinData.then((dynamic data) {
      List<Market> coinData = data as List<Market>;
      sortCoins(coinData, metric, lastPriceChangeSortOrder);
    });
  }
}
