import 'dart:async';

import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/widgets/coin_list_widget.dart';
import 'package:flutter/material.dart';

import '/services/coingecko_api_service.dart';

class CoinTrackingPage extends StatefulWidget {
  const CoinTrackingPage({super.key});

  @override
  State<CoinTrackingPage> createState() => _CoinTrackingPageState();
}

class _CoinTrackingPageState extends State<CoinTrackingPage> {
  final apiService = CoingeckoApiService();
  late Future coinFuture;
  late DateTime lastRefreshTime;
  bool isMarketCapAscending = false;
  bool isPriceChangeAscending = false;

  @override
  void initState() {
    super.initState();
    coinFuture = apiService.getCoins();
    lastRefreshTime = DateTime.now();
  }

  void reloadData() {
    final timeOfRefresh = DateTime.now();
    if (timeOfRefresh.difference(lastRefreshTime).inSeconds >= 60) {
      setState(() {
        coinFuture = apiService.getCoins();
        lastRefreshTime = timeOfRefresh;
      });
    } else {
      print("Coin data can only be refreshed every 60 seconds");
    }
  }

  void sortCoins(List<Market> coinData, String metric, bool ascending) {
    coinData.sort((a, b) {
      num? compareA;
      num? compareB;
      switch (metric) {
        case 'marketCap':
          compareA = a.marketCap;
          compareB = b.marketCap;
          break;
        case 'pricePercentageChange24h':
          compareA = a.priceChangePercentage24h;
          compareB = b.priceChangePercentage24h;
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

  void sortAndSetState(String metric) {
    coinFuture.then((dynamic data) {
      List<Market> coinData = data as List<Market>;
      switch (metric) {
        case 'marketCap':
          sortCoins(coinData, metric, isMarketCapAscending);
          isMarketCapAscending = !isMarketCapAscending;
          break;
        case 'pricePercentageChange24h':
          sortCoins(coinData, metric, isPriceChangeAscending);
          isPriceChangeAscending = !isPriceChangeAscending;
          break;
        default:
          throw ArgumentError('Invalid metric: $metric');
      }
      setState(() {
        coinFuture = Future.value(coinData);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CryptoBuddy'),
        backgroundColor: Colors.white38,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: reloadData,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => sortAndSetState('marketCap'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Market Cap'),
                    Icon(
                      isMarketCapAscending
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => sortAndSetState('pricePercentageChange24h'),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('24h Price Change'),
                    Icon(
                      isPriceChangeAscending
                          ? Icons.arrow_drop_down
                          : Icons.arrow_drop_up,
                      size: 24.0,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: coinFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  var coinData = snapshot.data;
                  return CoinList(
                    coinData: coinData,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
