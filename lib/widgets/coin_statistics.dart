import 'package:coingecko_api/data/market.dart';
import 'package:flutter/material.dart';

import '../utils/format_number.dart';

class CoinStatistics extends StatefulWidget {
  final Market coin;
  const CoinStatistics({super.key, required this.coin});

  @override
  State<CoinStatistics> createState() => _CoinStatisticsState();
}

class _CoinStatisticsState extends State<CoinStatistics> {
  Market get coin => widget.coin;

  TableRow buildTableRow(String label, String value, Color color) {
    return TableRow(
      children: [
        Text(
          label,
          style: TextStyle(
              color: color, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12.0, bottom: 6),
          child: Text(
            value,
            style: TextStyle(color: color),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 23.0),
      child: Table(
        columnWidths: const {
          0: IntrinsicColumnWidth(),
          1: FlexColumnWidth(),
        },
        children: [
          buildTableRow('Market Cap Rank', '${coin.marketCapRank ?? 'N/A'}',
              theme.primaryColor),
          buildTableRow(
              'Market Cap',
              coin.marketCap == null
                  ? 'N/A'
                  : '\$${Formatter.formatNumber(coin.marketCap)}',
              theme.primaryColor),
          buildTableRow(
              'All Time Low',
              coin.atl == null
                  ? 'N/A'
                  : '\$${Formatter.formatNumber(coin.atl)}',
              theme.primaryColor),
          buildTableRow(
              'All Time High',
              coin.ath == null
                  ? 'N/A'
                  : '\$${Formatter.formatNumber(coin.ath)}',
              theme.primaryColor),
          buildTableRow(
              'Circulating Supply',
              coin.circulatingSupply == null
                  ? 'N/A'
                  : Formatter.formatNumber(coin.circulatingSupply),
              theme.primaryColor),
          buildTableRow(
              'Maximum Supply',
              coin.maxSupply == null
                  ? coin.circulatingSupply == null
                      ? 'N/A'
                      : Formatter.formatNumber(coin.circulatingSupply)
                  : Formatter.formatNumber(coin.maxSupply),
              theme.primaryColor),
        ],
      ),
    );
  }
}
