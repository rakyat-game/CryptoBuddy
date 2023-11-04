import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../utils/sorting_metrics.dart';
import '../widgets/coin_list.dart';
import '../widgets/custom_button.dart';
import 'coin_tracker_controller.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.black,
                width: 1,
              ),
            ),
          ),
          child: AppBar(
            title: Row(
              children: [
                Flexible(
                  child: SizedBox(
                    height: 32.0,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4, top: 2),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
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
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.only(top: 2),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(LineIcons.search, size: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  LineIcons.sort,
                  //color: Colors.white,
                ),
                onPressed: () {
                  //TODO
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
                  onPressed: () async {
                    await controller.reloadData();
                    setState(() {});
                  },
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
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
                    CustomButton(
                      onTap: () {
                        setState(() {
                          controller
                              .sortAndChangeOrder(SortingMetric.marketCap);
                          controller.lastClickedSortingButton =
                              'marketCapButton';
                        });
                      },
                      label: 'Market Cap',
                      isActive: controller.lastClickedSortingButton ==
                          'marketCapButton',
                      icon: controller.isMarketCapAscending
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_up,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller.sortAndChangeOrder(
                                controller.priceChangeInterval);
                            controller.lastClickedSortingButton =
                                'priceChangeButton';
                            controller.lastPriceChangeSortOrder =
                                controller.isPriceChangeAscending;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return controller.lastClickedSortingButton ==
                                    'priceChangeButton'
                                ? Colors.blueGrey.shade200
                                : const Color(0xFFF8F8FF);
                          }),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 13.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Price Change',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              controller.isPriceChangeAscending
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              size: 18.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                    ),
                    CustomButton(
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
            ),
          ),
        ),
      ),
      body: Column(
        children: [
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
        ],
      ),
    );
  }
}
