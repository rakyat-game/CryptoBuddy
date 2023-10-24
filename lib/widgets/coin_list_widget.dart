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
            ListTile(
              leading: Image.network(
                coin.image ?? 'default_image_url',
                width: 40,
                height: 40,
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(coin.name),
                  Text(
                    '${coin.currentPrice} €',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(coin.symbol),
                  Text(
                      '${coin.priceChangePercentage24h != null && coin.priceChangePercentage24h! > 0 ? "+" : ""}${coin.priceChangePercentage24h?.toStringAsFixed(2) ?? 0}%')
                ],
              ),
              onTap: () {
                // Navigate to detail page
              },
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                color: Colors.grey.shade500, // Line color
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(.4),
                        spreadRadius: 1,
                        blurRadius: .5,
                        offset:
                            const Offset(2, 1), // changes position of shadow
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
