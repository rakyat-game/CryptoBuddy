import 'package:coingecko_api/data/market.dart';
import 'package:flutter/material.dart';

class CoinList extends StatelessWidget {
  final List<Market> coinData;

  const CoinList({super.key, required this.coinData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: coinData.length,
      itemBuilder: (BuildContext context, int index) {
        var coin = coinData[index];
        return Stack(
          children: [
            InkWell(
              onTap: () {
                // Navigate to detail page
              },
              child: Container(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 14,
                  bottom: 0, // Increase or decrease as needed
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
                      width: 32,
                      height: 32,
                      child: Image.network(
                        coin.image ?? 'default_image_url',
                      ),
                    ),
                    // Right Section
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${coin.currentPrice} €',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '${coin.priceChangePercentage24h != null && coin.priceChangePercentage24h! > 0 ? "+" : ""}${coin.priceChangePercentage24h?.toStringAsFixed(2) ?? "0"}%',
                            style: TextStyle(
                              color: coin.priceChangePercentage24h != null &&
                                      coin.priceChangePercentage24h! > 0
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
              padding: EdgeInsets.symmetric(horizontal: 24), // Set padding here
              child: Divider(
                color: Colors.grey,
                thickness: 0.5,
              ),
            ),
            // Positioned(
            //   //bottom: 4,
            //   left: 20,
            //   right: 20,
            //   child: Container(
            //     height: 1,
            //     color: Colors.grey.shade500,
            //     child: Container(
            //       decoration: BoxDecoration(
            //         boxShadow: [
            //           BoxShadow(
            //             color: Colors.grey.withOpacity(.4),
            //             spreadRadius: 1,
            //             blurRadius: .5,
            //             offset: const Offset(3, 1),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
          ],
        );
      },
    );
  }
}
