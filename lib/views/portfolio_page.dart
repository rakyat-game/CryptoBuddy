import 'package:crypto_buddy/models/portfolio_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portfolio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<PortfolioModel>(
          builder: (context, portfolio, child) {
            return Column(
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
                const Text(
                  'Coins in portfolio:',
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
            );
          },
        ),
      ),
    );
  }
}
