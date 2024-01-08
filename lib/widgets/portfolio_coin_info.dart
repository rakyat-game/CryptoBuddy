import 'package:crypto_buddy/models/crypto_asset.dart';
import 'package:crypto_buddy/utils/format_number.dart';
import 'package:crypto_buddy/widgets/sorting_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/portfolio.dart';
import '../views/manage_holdings_page.dart';

class PortfolioCoinInfo extends StatelessWidget {
  final CryptoAsset asset;
  final VoidCallback onTap;

  const PortfolioCoinInfo(
      {super.key, required this.asset, required this.onTap});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color primary = theme.primaryColor;
    Color highlight = theme.highlightColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: InkWell(
        hoverColor: highlight.withOpacity(.2),
        focusColor: highlight.withOpacity(.8),
        highlightColor: highlight.withOpacity(.5),
        borderRadius: BorderRadius.circular(20),
        enableFeedback: true,
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              theme.highlightColor.withOpacity(.07),
              Colors.transparent,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            color: theme.cardColor.withOpacity(.8),
            border: Border.all(color: highlight.withOpacity(.42)),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Section: Image, Name, and Symbol
              Row(
                children: [
                  SizedBox(
                    width: 34,
                    height: 34,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18.0),
                      child: Image.network(
                        asset.coin.image ??
                            'https://purepng.com/public/uploads/large/purepng.com-gold-coingoldatomic-number-79chemical-elementgroup-11-elementaurumgold-dustprecious-metalgold-coins-1701528977728s2dcq.png',
                        loadingBuilder: (BuildContext context, Widget child,
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
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        asset.coin.name,
                        style: TextStyle(
                            color: primary, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        asset.coin.symbol.toUpperCase(),
                        style: TextStyle(color: primary),
                      ),
                    ],
                  ),
                ],
              ),
              // Right Section: Holdings in USD and Amount of Coins
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '\$${Formatter.formatNumber(asset.totalValue)}',
                        style: TextStyle(
                            color: primary, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${Formatter.formatNumber(asset.quantity)} ${asset.coin.symbol.toUpperCase()}',
                        style: TextStyle(color: primary),
                      ),
                    ],
                  ),
                  const SizedBox(width: 5),
                  SortingButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageHoldingsPage(
                            asset: asset,
                            portfolio: Provider.of<Portfolio>(context),
                          ),
                        ),
                      );
                    },
                    label: "+ / -",
                    fontSize: 16,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 9),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
