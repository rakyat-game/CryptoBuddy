import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/pages/coin_info_page.dart';
import 'package:crypto_buddy/pages/coin_tracker_controller.dart';
import 'package:crypto_buddy/utils/sorting_metrics.dart';
import 'package:flutter/material.dart';

import '../services/openai_api.dart';

class CoinList extends StatelessWidget {
  final List<Market> coinData;
  final SortingMetric priceChangeInterval;
  final CoinTrackingController controller;
  final openAi = OpenAiApiService();

  CoinList(
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
          case SortingMetric.sixMonths:
            priceChange = coin.priceChangePercentage200dInCurrency;
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CoinInfoPage(
                            coin: coin,
                            controller: controller,
                          )),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(color: Colors.grey.shade400))),
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
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
                      width: 34,
                      height: 34,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.network(
                          coin.image ??
                              'default_image_url', // TODO find default pic url
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
