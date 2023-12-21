import 'dart:async';

import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/widgets/sorting_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../controllers/coin_listing_controller.dart';
import '../main.dart';
import '../utils/coingecko_api.dart';
import '../widgets/coin_list.dart';
import '../widgets/popup_message.dart';
import 'coin_info_page.dart';

class CoinListingPage extends StatefulWidget {
  const CoinListingPage({super.key});

  @override
  State<CoinListingPage> createState() => _CoinListingPageState();
}

class _CoinListingPageState extends State<CoinListingPage> {
  //final controller = controller(apiService: CoingeckoApiService());
  late CoinListingController controller;

  @override
  void initState() {
    super.initState();
    controller = CoinListingController(apiService: CoingeckoApiService());
    initializeData();
  }

  void initializeData() async {
    try {
      List<Market> data = await controller.apiService.getCoins();
      if (mounted) {
        Provider.of<CoinDataProvider>(context).coinData = data;
      }
    } catch (_) {}
  }

  void navigateToCoinInfoPage(Market coin) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CoinInfoPage(coin: coin),
      ),
    ).then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<CoinDataProvider>(context).coinData = await controller.coinData;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.highlightColor.withOpacity(.2),
              theme.highlightColor.withOpacity(.001),
            ],
          )),
          child: AppBar(
            backgroundColor: Colors.white.withOpacity(0.001),
            surfaceTintColor: Colors.transparent,
            title: Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Row(
                children: [
                  Flexible(
                    child: SizedBox(
                      height: 33,
                      child: TextField(
                        onChanged: (text) {
                          setState(() {
                            controller.searchQuery = text;
                          });
                        },
                        style: TextStyle(color: theme.primaryColor),
                        cursorColor: theme.highlightColor,
                        cursorRadius: const Radius.circular(20),
                        cursorHeight: 22,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.cardColor.withOpacity(.6),
                          contentPadding:
                              const EdgeInsets.only(bottom: 11.5, left: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color:
                                    theme.primaryColor), // Default Border Color
                          ),
                          focusedBorder: OutlineInputBorder(
                            // Border Color when TextField is focused
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: theme.highlightColor),
                          ),
                          disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: theme.highlightColor.withOpacity(.5))),
                          enabledBorder: OutlineInputBorder(
                            // Border Color when TextField is enabled but not focused
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: theme.highlightColor.withOpacity(.5)),
                          ),
                          prefixIcon: Icon(
                            LineIcons.search,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 3.5),
                child: IconButton(
                  color: controller.isSortingBarVisible
                      ? theme.highlightColor
                      : theme.primaryColor,
                  icon: const Icon(
                    LineIcons.sort,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.isSortingBarVisible =
                          !controller.isSortingBarVisible;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.5),
                child: IconButton(
                  icon: Icon(
                    controller.showFavoredCoins
                        ? LineIcons.starAlt
                        : LineIcons.star,
                    color: controller.showFavoredCoins
                        ? theme.highlightColor
                        : theme.primaryColor,
                  ),
                  onPressed: () {
                    setState(() {
                      controller.showFavoredCoins =
                          !controller.showFavoredCoins;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3.5, right: 15),
                child: IconButton(
                  icon: Icon(
                    LineIcons.syncIcon,
                    color: theme.primaryColor,
                  ),
                  color: controller.refreshButtonColor,
                  onPressed: () async {
                    setState(() {
                      controller.refreshButtonColor = theme.highlightColor;
                    });
                    if (await controller.reloadData() && mounted) {
                      controller.lastClickedSortingButton = null;
                      controller.refreshButtonColor = theme.primaryColor;
                    } else {
                      showDialog(
                        builder: (BuildContext context) {
                          return PopupMessage(
                            message:
                                'Data is only refreshed every 60 seconds.\n'
                                'Try again in ${controller.refreshWaitTime} seconds.',
                          );
                        },
                        context: context,
                      );
                    }
                    Timer(const Duration(seconds: 2), () {
                      if (mounted) {
                        setState(() {
                          controller.refreshButtonColor = theme.primaryColor;
                        });
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          if (controller.isSortingBarVisible)
            SortingBar(
              controller: controller,
              onChange: () {
                setState(() {});
              },
            ),
          Expanded(
            child: FutureBuilder(
              future: controller.showFavoredCoins
                  ? controller.getFavoredCoins()
                  : controller.coinData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                        height: 100,
                        width: 100,
                        child: Image(image: AssetImage("img/new_logo.png"))),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                        'Yikes, something went wrong:\n ${snapshot.error}'),
                  );
                } else {
                  return CoinList(
                    coinData: snapshot.data,
                    priceChangeInterval: controller.priceChangeInterval,
                    controller: controller,
                    onCoinTap: navigateToCoinInfoPage,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
