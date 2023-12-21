import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/controllers/coin_listing_controller.dart';
import 'package:crypto_buddy/utils/format_number.dart';
import 'package:crypto_buddy/utils/sorting_metrics.dart';
import 'package:flutter/material.dart';

class CoinList extends StatelessWidget {
  final List<Market> coinData;
  final SortingMetric priceChangeInterval;
  final CoinListingController controller;
  final void Function(Market) onCoinTap;

  const CoinList(
      {super.key,
      required this.coinData,
      required this.priceChangeInterval,
      required this.onCoinTap,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    List<Market> filteredCoins = controller.filterCoins(coinData);
    ThemeData theme = Theme.of(context);
    Color primary = theme.primaryColor;
    Color highlight = theme.highlightColor;

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
            throw Exception("Yikes, $priceChangeInterval is not a valid price"
                "change interval!");
        }

        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: InkWell(
                hoverColor: highlight.withOpacity(.2),
                focusColor: highlight.withOpacity(.3),
                highlightColor: highlight.withOpacity(.5),
                borderRadius: BorderRadius.circular(20),
                enableFeedback: true,
                onTap: () {
                  onCoinTap(coinData[index]);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(.6),
                    border: Border.all(color: highlight.withOpacity(.42)),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left Section with Image, Name and Symbol
                      Row(
                        children: [
                          SizedBox(
                            width: 34,
                            height: 34,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(18.0),
                              child: Image.network(
                                coin.image ??
                                    'https://purepng.com/public/uploads/large/purepng.com-gold-coingoldatomic-number-79chemical-elementgroup-11-elementaurumgold-dustprecious-metalgold-coins-1701528977728s2dcq.png',
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: highlight,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 13),
                          // Coin Name and Symbol
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coin.name,
                                style: TextStyle(
                                    color: primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                coin.symbol.toUpperCase(),
                                style: TextStyle(color: primary),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Right Section with Price and Price Change
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${Formatter.formatNumber(coin.currentPrice)} \$',
                            style: TextStyle(
                                color: primary, fontWeight: FontWeight.bold),
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
