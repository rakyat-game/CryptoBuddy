import 'package:crypto_buddy/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/portfolio.dart';
import '../utils/format_number.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/portfolio_coin_info.dart';
import 'coin_info_page.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final portfolio = Provider.of<Portfolio>(context);
    final coins = Provider.of<CoinDataProvider>(context).coinData;
    portfolio.buildPortfolio(coins);
    double availableHeight = MediaQuery.of(context).size.height * 0.35;
    double buttonHeight = (availableHeight - (8 * 2)) / 4;
    double buttonWidth = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GradientAppBar(
          header: 'Portfolio',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.3,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 24, bottom: 12),
                child: GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  childAspectRatio: buttonWidth / buttonHeight,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: <Widget>[
                    _buildInfoBox(
                        'Balance',
                        '\$${Formatter.formatNumber(portfolio.currentValue)}',
                        Alignment.topLeft,
                        Alignment.bottomRight),
                    _buildInfoBox(
                        'Investment',
                        '\$${Formatter.formatNumber(portfolio.investment)}',
                        Alignment.topRight,
                        Alignment.bottomLeft),
                    _buildInfoBox(
                        'Profit/Loss',
                        '\$${Formatter.formatNumber(portfolio.profitLoss)}',
                        Alignment.bottomLeft,
                        Alignment.topRight),
                    _buildInfoBox(
                        'Sales',
                        '\$${Formatter.formatNumber(portfolio.sales)}',
                        Alignment.bottomRight,
                        Alignment.topLeft),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 29.0, bottom: 6),
              child: Text(
                'Your Assets',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.primaryColor),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: portfolio.assets.length,
              itemBuilder: (context, index) {
                final asset = portfolio.assets[index];
                return PortfolioCoinInfo(
                  asset: asset,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CoinInfoPage(
                          coin: asset.coin,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value, Alignment startAlignment,
      Alignment endAlignment) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border.all(color: theme.highlightColor.withOpacity(.42)),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [
            theme.highlightColor.withOpacity(.1),
            Colors.transparent,
          ], begin: startAlignment, end: endAlignment)),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.primaryColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(fontSize: 14, color: theme.primaryColor),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
