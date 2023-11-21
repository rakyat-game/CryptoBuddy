import 'dart:async';

import 'package:crypto_buddy/widgets/sorting_bar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../controllers/coin_listing_controller.dart';
import '../services/coingecko_api.dart';
import '../widgets/coin_list.dart';
import '../widgets/popup_message.dart';

class CoinListingPage extends StatefulWidget {
  const CoinListingPage({super.key});

  @override
  State<CoinListingPage> createState() => _CoinListingPageState();
}

class _CoinListingPageState extends State<CoinListingPage> {
  final controller = CoinListingController(apiService: CoingeckoApiService());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title: Row(
          children: [
            Flexible(
              child: SizedBox(
                height: 33,
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withRed(10),
                          spreadRadius: .3,
                          blurRadius: .3,
                          offset: const Offset(0, 1),
                        ),
                      ]),
                  child: TextField(
                    onChanged: (text) {
                      setState(() {
                        controller.searchQuery = text;
                      });
                    },
                    cursorColor: Colors.white.withRed(10),
                    cursorRadius: const Radius.circular(20),
                    cursorHeight: 17,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(LineIcons.search),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 3.5),
            child: IconButton(
              color: controller.isSortingBarVisible
                  ? Colors.white.withRed(10)
                  : Colors.grey.shade800,
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
              icon: const Icon(
                LineIcons.star,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const PopupMessage(message: "Coming soon...");
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.5, right: 15),
            child: IconButton(
              icon: const Icon(
                LineIcons.syncIcon,
              ),
              color: controller.refreshButtonColor,
              onPressed: () async {
                setState(() {
                  controller.refreshButtonColor = Colors.white.withRed(10);
                });

                if (!await controller.reloadData() && mounted) {
                  showDialog(
                    builder: (BuildContext context) {
                      return PopupMessage(
                        message: 'Data can only be refreshed every 60 seconds. '
                            'Please wait another ${controller.refreshWaitTime} seconds.',
                      );
                    },
                    context: context,
                  );
                }
                Timer(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      controller.refreshButtonColor = Colors.grey.shade800;
                    });
                  }
                });
              },
            ),
          ),
        ],
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
          const Padding(
            padding: EdgeInsets.only(top: 3.0),
            child: Divider(
              color: Colors.black,
              thickness: .8,
              height: .8,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: controller.coinData,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                      height: 100,
                      width: 100,
                      child: Image(image: AssetImage("img/new_logo.png")));
                } else if (snapshot.hasError) {
                  return Text(
                      'Yikes, something went wrong:\n ${snapshot.error}');
                } else {
                  var coinData = snapshot.data;
                  return CoinList(
                    coinData: coinData,
                    priceChangeInterval: controller.priceChangeInterval,
                    controller: controller,
                  );
                }
              },
            ),
          ),
          const Divider(
            color: Colors.black,
            thickness: .8,
            height: .8,
          ),
        ],
      ),
    );
  }
}
