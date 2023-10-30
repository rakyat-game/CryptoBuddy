import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/pages/coin_tracking_controller.dart';
import 'package:crypto_buddy/utils/sorting_metrics.dart';
import 'package:flutter/material.dart';

class CoinList extends StatelessWidget {
  final List<Market> coinData;
  final SortingMetric priceChangeInterval;
  final CoinTrackingController controller;

  const CoinList(
      {super.key,
      required this.coinData,
      required this.priceChangeInterval,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    var filteredCoins = controller.filterCoins(coinData);
    return ListView.builder(
      itemCount: filteredCoins.length,
      itemBuilder: (BuildContext context, int index) {
        var coin = filteredCoins[index];
        double? priceChange;
        switch (priceChangeInterval) {
          case SortingMetric.hour:
            priceChange = coin.priceChangePercentage1hInCurrency;
            break;
          case SortingMetric.day:
            priceChange = coin.priceChangePercentage24hInCurrency;
            break;
          case SortingMetric.week:
            priceChange = coin.priceChangePercentage7dInCurrency;
            break;
          case SortingMetric.month:
            priceChange = coin.priceChangePercentage30dInCurrency;
            break;
          case SortingMetric.year:
            priceChange = coin.priceChangePercentage1yInCurrency;
            break;
          default:
            print("Metric $priceChangeInterval is not a valid interval!");
        }

        return Stack(
          children: [
            InkWell(
              hoverColor: Colors.blueGrey.shade100,
              onTap: () {
                // Navigate to detail page
              },
              child: Container(
                decoration: BoxDecoration(
                    // color: index.isEven
                    //     ? const Color(0xFFF5F5F5)
                    //     : Colors.grey.shade200,
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                padding: const EdgeInsets.only(
                  left: 32,
                  right: 32,
                  top: 9,
                  bottom: 9,
                ),
                child: Row(
                  children: [
                    // Left Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            coin.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(coin.symbol),
                        ],
                      ),
                    ),
                    // Center Section
                    SizedBox(
                      width: 38,
                      height: 38,
                      child: Image.network(
                        coin.image ?? 'default_image_url',
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    // Right Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${coin.currentPrice} €',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${priceChange != null && priceChange > 0 ? "+" : ""}'
                            '${priceChange?.toStringAsFixed(2) ?? "0"} %',
                            style: TextStyle(
                              color: priceChange != null && priceChange > 0
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
            ),
          ],
        );
      },
    );
  }
}
