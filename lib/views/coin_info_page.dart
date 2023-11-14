import 'package:coingecko_api/data/market.dart';
import 'package:coingecko_api/data/market_chart_data.dart';
import 'package:crypto_buddy/models/crypto_asset.dart';
import 'package:crypto_buddy/models/portfolio_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/coin_tracker_controller.dart';

class CoinInfoPage extends StatefulWidget {
  final Market coin;
  final CoinTrackingController controller;

  const CoinInfoPage({super.key, required this.coin, required this.controller});

  @override
  State<CoinInfoPage> createState() => _CoinInfoPageState();
}

class _CoinInfoPageState extends State<CoinInfoPage> {
  late Future<Map<String, List<MarketChartData>>> _sparkLineData;

  @override
  void initState() {
    super.initState();
    _sparkLineData =
        widget.controller.apiService.getSparkLineData(coinId: widget.coin.id);
  }

  void _buyAsset() {
    final portfolio = Provider.of<PortfolioModel>(context, listen: false);
    final assetToBuy = CryptoAsset(
      coin: widget.coin,
      quantity: 1,
    );
    portfolio.buyAsset(assetToBuy);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.coin.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('TODO add to favorites'),
            Text('Current price: ${widget.coin.currentPrice}'),
            Text('24h Price Change: '
                '${widget.coin.priceChangePercentage24hInCurrency?.toStringAsFixed(2)}'),
            ElevatedButton(
              onPressed: _buyAsset,
              child: const Text('Buy coin, quantity: 1'),
            ),
            const Text('Spark Line data for chart building:'),
            FutureBuilder<Map<String, List<MarketChartData>>>(
              future: _sparkLineData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData) {
                  return const Center(child: Text('No data available.'));
                } else {
                  Map<String, List<MarketChartData>>? data = snapshot.data;
                  List<MarketChartData>? lastMonthData = data?['lastMonth'];
                  return Expanded(
                    child: ListView.builder(
                      itemCount: lastMonthData?.length,
                      itemBuilder: (context, index) {
                        MarketChartData? chartData = lastMonthData?[index];
                        return ListTile(
                          title: Text('Date: ${chartData?.date}'),
                          subtitle: Text('Price: ${chartData?.price}'),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
