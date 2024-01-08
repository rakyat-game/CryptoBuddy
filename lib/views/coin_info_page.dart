import 'package:coingecko_api/data/market.dart';
import 'package:coingecko_api/data/market_chart_data.dart';
import 'package:crypto_buddy/models/crypto_asset.dart';
import 'package:crypto_buddy/models/portfolio.dart';
import 'package:crypto_buddy/utils/coingecko_api.dart';
import 'package:crypto_buddy/utils/favorites.dart';
import 'package:crypto_buddy/widgets/coin_statistics.dart';
import 'package:crypto_buddy/widgets/line_chart.dart';
import 'package:crypto_buddy/widgets/sorting_button.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../controllers/coin_listing_controller.dart';
import '../utils/format_number.dart';
import 'manage_holdings_page.dart';

class CoinInfoPage extends StatefulWidget {
  final Market coin;

  const CoinInfoPage({super.key, required this.coin});

  @override
  State<CoinInfoPage> createState() => _CoinInfoPageState();
}

class _CoinInfoPageState extends State<CoinInfoPage> {
  final CoinListingController controller =
      CoinListingController(apiService: CoingeckoApiService());
  Market get coin => widget.coin;
  late Future<Map<String, List<MarketChartData>>> _sparkLineData;
  late Map<String, List<MarketChartData>> chartData;
  late double activePriceChange;
  String activeChartRange = 'lastWeek';
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _sparkLineData =
        controller.apiService.getLastWeekToLastDayData(coinId: coin.id);
    activePriceChange = coin.priceChangePercentage7dInCurrency ?? 0;
    _checkIfFavorite();
  }

  void getChartData(String chartRange) async {
    Map<String, List<MarketChartData>> data = await _sparkLineData;
    bool containsChartRange = data.containsKey(chartRange);
    if (!containsChartRange) {
      if (chartRange == 'lastHour') {
        Map<String, List<MarketChartData>> newData =
            await controller.apiService.getLastHourData(coinId: coin.id);
        data.addAll(newData);
      } else {
        Map<String, List<MarketChartData>> newData = await controller.apiService
            .getLastYearToLastMonthData(coinId: coin.id);
        data.addAll(newData);
      }
    }
    setState(() {
      _sparkLineData = Future.value(data);
      activeChartRange = chartRange;
    });
  }

  List<FlSpot> _getSpots(List<MarketChartData> data) {
    return data
        .map((data) => FlSpot(
              data.date.millisecondsSinceEpoch.toDouble(),
              data.price ?? 0.0,
            ))
        .toList();
  }

  void _checkIfFavorite() async {
    isFavorite = await FavoritesService.isFavorite(widget.coin);
    setState(() {});
  }

  void _toggleFavorite() async {
    if (isFavorite) {
      await FavoritesService.removeFromFavorites(widget.coin.id);
    } else {
      await FavoritesService.addToFavorites(widget.coin.id);
    }
    _checkIfFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final portfolio = Provider.of<Portfolio>(context, listen: true);
    CryptoAsset? asset = Provider.of<Portfolio>(context).getAsset(coin);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.highlightColor.withOpacity(.3),
              theme.highlightColor.withOpacity(.001),
            ],
          )),
          child: AppBar(
              backgroundColor: Colors.white.withOpacity(0.001),
              surfaceTintColor: Colors.transparent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child:
                            Text('${coin.name}(${coin.symbol.toUpperCase()})'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: IconButton(
                      icon: Icon(
                        isFavorite ? LineIcons.starAlt : LineIcons.star,
                        color: isFavorite
                            ? theme.highlightColor
                            : theme.primaryColor,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                  ),
                ],
              )),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 12),
              child: Text(
                  style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 25),
                  '\$${Formatter.formatNumber(coin.currentPrice)}'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, bottom: 10),
              child: Text(
                  style: TextStyle(
                      fontSize: 18,
                      color:
                          activePriceChange >= 0 ? Colors.green : Colors.red),
                  '${activePriceChange >= 0 ? '+${activePriceChange.toStringAsFixed(2)}' : activePriceChange.toStringAsFixed(2)} %'),
            ),
            Container(
              padding: const EdgeInsets.only(top: 12, left: 24, right: 24),
              width: MediaQuery.of(context).size.width,
              height: 155,
              child: FutureBuilder<Map<String, List<MarketChartData>>>(
                future: _sparkLineData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: theme.highlightColor,
                    ));
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text(
                            'Chart data could not be loaded! Please check your internet connection. '));
                  } else if (!snapshot.hasData ||
                      snapshot.data![activeChartRange]!.isEmpty) {
                    return Center(
                        child: Text(
                      'No chart data available.',
                      style: TextStyle(color: theme.primaryColor),
                    ));
                  } else {
                    return SparkLineChart(
                        spots: _getSpots(snapshot.data![activeChartRange]!));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 10, bottom: 0, top: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SortingButton(
                      onTap: () {
                        if (activeChartRange != 'lastHour') {
                          getChartData('lastHour');
                        }
                        activePriceChange =
                            coin.priceChangePercentage1hInCurrency ?? 0;
                      },
                      label: '1 Hour',
                      isActive: 'lastHour' == activeChartRange,
                      margin: const EdgeInsets.only(
                          left: 2, right: 3, top: 12, bottom: 12),
                    ),
                    SortingButton(
                      onTap: () {
                        if (activeChartRange != 'lastDay') {
                          getChartData('lastDay');
                          activePriceChange =
                              coin.priceChangePercentage24h ?? 0;
                        }
                      },
                      label: '1 Day',
                      isActive: 'lastDay' == activeChartRange,
                      margin: const EdgeInsets.only(
                          left: 2, right: 3, top: 12, bottom: 12),
                    ),
                    SortingButton(
                      onTap: () {
                        if (activeChartRange != 'lastWeek') {
                          getChartData('lastWeek');
                          activePriceChange =
                              coin.priceChangePercentage7dInCurrency ?? 0;
                        }
                      },
                      label: '1 Week',
                      isActive: 'lastWeek' == activeChartRange,
                      margin: const EdgeInsets.only(
                          left: 2, right: 3, top: 12, bottom: 12),
                    ),
                    SortingButton(
                      onTap: () {
                        if (activeChartRange != 'lastMonth') {
                          getChartData('lastMonth');
                          activePriceChange =
                              coin.priceChangePercentage30dInCurrency ?? 0;
                        }
                      },
                      label: '1 Month',
                      isActive: 'lastMonth' == activeChartRange,
                      margin: const EdgeInsets.only(
                          left: 2, right: 3, top: 12, bottom: 12),
                    ),
                    SortingButton(
                      onTap: () {
                        if (activeChartRange != 'lastSixMonths') {
                          getChartData('lastSixMonths');
                          activePriceChange =
                              coin.priceChangePercentage200dInCurrency ?? 0;
                        }
                      },
                      label: '6 Months',
                      isActive: 'lastSixMonths' == activeChartRange,
                      margin: const EdgeInsets.only(
                          left: 2, right: 3, top: 12, bottom: 12),
                    ),
                    SortingButton(
                      onTap: () {
                        if (activeChartRange != 'lastYear') {
                          getChartData('lastYear');
                          activePriceChange =
                              coin.priceChangePercentage1yInCurrency ?? 0;
                        }
                      },
                      label: '1 Year',
                      isActive: 'lastYear' == activeChartRange,
                      margin: const EdgeInsets.only(
                          left: 2, right: 3, top: 12, bottom: 12),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22, top: 16),
              child: Text(
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: theme.primaryColor),
                  'Your ${coin.name} Balance'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, top: 6),
              child: Text(
                '\$${Formatter.formatNumber(portfolio.getAsset(coin)?.totalValue ?? 0.0)}',
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 22.0, top: 0),
              child: Text(
                '${Formatter.formatNumber(portfolio.getAsset(coin)?.quantity ?? 0.0)} ${coin.symbol.toUpperCase()}',
                style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, bottom: 14, top: 8),
              child: Row(
                children: [
                  SortingButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ManageHoldingsPage(
                              portfolio: Provider.of<Portfolio>(context),
                              asset: asset ??
                                  CryptoAsset(coin: coin, quantity: 0.0)),
                        ),
                      );
                    },
                    label: 'Add ${coin.symbol.toUpperCase()}',
                  ),
                  SortingButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManageHoldingsPage(
                                portfolio: Provider.of<Portfolio>(context),
                                asset: asset ??
                                    CryptoAsset(coin: coin, quantity: 0.0),
                                isAdding: false),
                          ),
                        );
                      },
                      label: 'Remove ${coin.symbol.toUpperCase()}'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 21, top: 12, bottom: 4),
              child: Text(
                  style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 20),
                  'Statistics'),
            ),
            CoinStatistics(coin: coin),
            const SizedBox(
              height: 33,
            )
          ],
        ),
      ),
    );
  }
}
