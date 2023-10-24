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
  DateTime? lastRefreshTime;

  @override
  void initState() {
    super.initState();
    coinFuture = apiService.getCoinsByMarketCap();
    lastRefreshTime = DateTime.now();
  }

  void reloadData() {
    final timeOfRefresh = DateTime.now();
    if (lastRefreshTime == null ||
        timeOfRefresh.difference(lastRefreshTime!).inSeconds >= 60) {
      setState(() {
        coinFuture = apiService.getCoinsByMarketCap();
        lastRefreshTime = timeOfRefresh;
      });
    } else {
      print("Coin data can only be refreshed every 60 seconds");
    }
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
        body: FutureBuilder(
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
        ));
  }
}
