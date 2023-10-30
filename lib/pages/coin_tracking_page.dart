import 'package:flutter/material.dart';

import '../utils/sorting_metrics.dart';
import '../widgets/coin_list_widget.dart';
import 'coin_tracking_controller.dart';

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
      backgroundColor: const Color(
          0xFFF8F8FF), //const Color(0xFFF5F5F5), //Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey,
                width: 1.5,
              ),
            ),
          ),
          child: AppBar(
            backgroundColor:
                const Color(0xFFF8F8FF), //Colors.blueGrey.shade200,
            title: Row(
              children: [
                Flexible(
                  child: SizedBox(
                    height: 40.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.2),
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
                            hintText: 'Search...',
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            prefixIcon: const Icon(Icons.search),
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
                  Icons.star_border,
                  //color: Colors.white,
                ),
                onPressed: controller.reloadData,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: IconButton(
                  icon: const Icon(
                    Icons.refresh,
                    //color: Colors.white,
                  ),
                  onPressed: controller.reloadData,
                ),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(bottom: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      margin: const EdgeInsets.only(left: 10, right: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.2),
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
                                  metric != SortingMetric.marketCap)
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller
                                .sortAndChangeOrder(SortingMetric.marketCap);
                            controller.lastClickedSortingButton =
                                'marketCapButton';
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return controller.lastClickedSortingButton ==
                                    'marketCapButton'
                                ? Colors.blueGrey.shade200
                                : Colors.white; // Conditional background color
                          }),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Market Cap',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Icon(
                              controller.isMarketCapAscending
                                  ? Icons.keyboard_arrow_down
                                  : Icons.keyboard_arrow_up,
                              size: 18.0,
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
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
                            controller.lastPriceChangeSortOrder = controller
                                .isPriceChangeAscending; // Add this line
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return controller.lastClickedSortingButton ==
                                    'priceChangeButton'
                                ? Colors.blueGrey.shade200
                                : Colors.white;
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
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            controller
                                .sortAndChangeOrder(SortingMetric.marketCap);
                            controller.lastClickedSortingButton =
                                'marketCapButton';
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                            return controller.lastClickedSortingButton ==
                                    'marketCapButton'
                                ? Colors.blueGrey.shade200
                                : Colors.white; // Conditional background color
                          }),
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
                            const EdgeInsets.symmetric(horizontal: 13.0),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Price',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
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
