import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/models/crypto_asset.dart';
import 'package:crypto_buddy/models/portfolio_model.dart';
import 'package:flutter/material.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  // Uses random data for now to use business logic
  PortfolioModel portfolio = PortfolioModel(
    assets: [
      CryptoAsset(
        coin: Market.fromJson({
          'id': 'bitcoin',
          'symbol': 'BTC',
          'name': 'Bitcoin',
          'current_price': 1100.0,
        }),
        quantity: 1,
      ),
      CryptoAsset(
        coin: Market.fromJson({
          'id': 'ethereum',
          'symbol': 'ETH',
          'name': 'Ethereum',
          'current_price': 1000.0,
        }),
        quantity: 2,
      ),
    ],
    investment: 3000.0,
  );

  @override
  void initState() {
    super.initState();
    // Random data to use business logic
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio (using test values for now)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Initial Investment: ${portfolio.investment}',
            ),
            Text(
              'Current Value: ${portfolio.currentValue}',
            ),
            Text(
              'Profit/Loss: ${portfolio.profitLoss}',
            ),
            Expanded(
              child: ListView.builder(
                itemCount: portfolio.assets.length,
                itemBuilder: (context, index) {
                  final asset = portfolio.assets[index];
                  return ListTile(
                    title: Text('${asset.coin.name},'
                        ' Quantity: ${asset.quantity},'
                        ' Value: ${asset.totalValue}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
