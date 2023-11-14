import 'dart:async';

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../controllers/coin_tracker_controller.dart';
import '../utils/sorting_metrics.dart';
import '../widgets/coin_list.dart';
import '../widgets/sorting_button.dart';

class CoinTrackingPage extends StatefulWidget {
  const CoinTrackingPage({super.key});

  @override
  State<CoinTrackingPage> createState() => _CoinTrackingPageState();
}

class _CoinTrackingPageState extends State<CoinTrackingPage> {
  final controller = CoinTrackingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Flexible(
              child: SizedBox(
                height: 33.0,
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
                        controller.setSearchQuery(text);
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
          IconButton(
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
          IconButton(
            icon: const Icon(
              LineIcons.star,
              //color: Colors.white,
            ),
            onPressed: () {
              //TODO
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: IconButton(
              icon: const Icon(
                LineIcons.syncIcon,
                //color: Colors.white,
              ),
              color: controller.refreshButtonColor,
              onPressed: () async {
                setState(() {
                  controller.refreshButtonColor = Colors.white.withRed(10);
                });
                await controller.reloadData();
                Timer(const Duration(seconds: 2), () {
                  if (mounted) {
                    setState(() {
                      controller.refreshButtonColor = Colors.grey.shade800;
                    });
                  }
                });
              },
            ),
          )
        ],
      ),
      body: Column(
        children: [
          if (controller.isSortingBarVisible)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    margin: const EdgeInsets.only(left: 10, right: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white
                              .withRed(10), //Colors.black.withOpacity(.2),
                          spreadRadius: .3,
                          blurRadius: .3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: PopupMenuButton<SortingMetric>(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(12.0))),
                      onSelected: (SortingMetric metric) {
                        setState(() {
                          controller.priceChangeInterval = metric;
                          if (controller.lastClickedSortingButton ==
                              'priceChangeButton') {
                            controller.sortWithCurrentOrder(metric);
                          }
                        });
                      },
                      itemBuilder: (BuildContext context) {
                        return SortingMetric.values
                            .where((SortingMetric metric) =>
                                metric != SortingMetric.marketCap &&
                                metric != SortingMetric.price)
                            .map((SortingMetric metric) {
                          return PopupMenuItem<SortingMetric>(
                            value: metric,
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              metric.longName,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.priceChangeInterval.name,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SortingButton(
                    onTap: () {
                      setState(() {
                        controller.sortAndChangeOrder(SortingMetric.marketCap);
                        controller.lastClickedSortingButton = 'marketCapButton';
                      });
                    },
                    label: 'Market Cap',
                    isActive: controller.lastClickedSortingButton ==
                        'marketCapButton',
                    icon: controller.isMarketCapAscending
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                  ),
                  SortingButton(
                    onTap: () {
                      setState(() {
                        controller
                            .sortAndChangeOrder(controller.priceChangeInterval);
                        controller.lastClickedSortingButton =
                            'priceChangeButton';
                        controller.lastPriceChangeSortOrder =
                            controller.isPriceChangeAscending;
                      });
                    },
                    label: 'Price Change',
                    isActive: controller.lastClickedSortingButton ==
                        'priceChangeButton',
                    icon: controller.isPriceChangeAscending
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                  ),
                  SortingButton(
                    onTap: () {
                      setState(() {
                        controller.sortAndChangeOrder(SortingMetric.price);
                        controller.lastClickedSortingButton = 'priceButton';
                      });
                    },
                    label: 'Price',
                    isActive:
                        controller.lastClickedSortingButton == 'priceButton',
                    icon: controller.isPriceAscending
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                  ),
                ],
              ),
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
              future: controller.coinFuture,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
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
