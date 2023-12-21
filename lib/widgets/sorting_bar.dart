import 'package:crypto_buddy/controllers/coin_listing_controller.dart';
import 'package:crypto_buddy/widgets/sorting_button.dart';
import 'package:flutter/material.dart';

import '../utils/sorting_metrics.dart';

class SortingBar extends StatefulWidget {
  final CoinListingController controller;
  final VoidCallback onChange;
  const SortingBar(
      {super.key, required this.controller, required this.onChange});

  @override
  State<SortingBar> createState() => _SortingBarState();
}

class _SortingBarState extends State<SortingBar> {
  CoinListingController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            margin: const EdgeInsets.only(left: 10, right: 5),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.highlightColor, //Colors.black.withOpacity(.2),
                  spreadRadius: .3,
                  blurRadius: .3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: PopupMenuButton<SortingMetric>(
              color: theme.cardColor,
              surfaceTintColor: Colors.transparent,
              shadowColor: theme.highlightColor,
              shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                  side: BorderSide(color: theme.highlightColor)),
              onSelected: (SortingMetric metric) {
                setState(() {
                  controller.priceChangeInterval = metric;
                  if (controller.lastClickedSortingButton ==
                      'priceChangeButton') {
                    controller.sortWithCurrentOrder(metric);
                  }
                  widget.onChange();
                });
              },
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem<SortingMetric>(
                    enabled: false,
                    child: Text(
                      'Select Time Interval',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                  const PopupMenuDivider(),
                  ...SortingMetric.values
                      .where((metric) =>
                          metric != SortingMetric.marketCap &&
                          metric != SortingMetric.price)
                      .map((SortingMetric metric) {
                    return PopupMenuItem<SortingMetric>(
                      value: metric,
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        metric.longName,
                        style: TextStyle(
                          color: theme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }),
                ];
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.priceChangeInterval.name,
                    style: TextStyle(
                        color: theme.primaryColor, fontWeight: FontWeight.bold),
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
                widget.onChange();
              });
            },
            label: 'Market Cap',
            isActive: controller.lastClickedSortingButton == 'marketCapButton',
            icon: controller.isMarketCapAscending
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up,
          ),
          SortingButton(
            onTap: () {
              setState(() {
                controller.sortAndChangeOrder(controller.priceChangeInterval);
                controller.lastClickedSortingButton = 'priceChangeButton';
                controller.lastPriceChangeSortOrder =
                    controller.isPriceChangeAscending;
                widget.onChange();
              });
            },
            label: 'Price Change',
            isActive:
                controller.lastClickedSortingButton == 'priceChangeButton',
            icon: controller.isPriceChangeAscending
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up,
          ),
          SortingButton(
            onTap: () {
              setState(() {
                controller.sortAndChangeOrder(SortingMetric.price);
                controller.lastClickedSortingButton = 'priceButton';
                widget.onChange();
              });
            },
            label: 'Price',
            isActive: controller.lastClickedSortingButton == 'priceButton',
            icon: controller.isPriceAscending
                ? Icons.keyboard_arrow_down
                : Icons.keyboard_arrow_up,
          ),
        ],
      ),
    );
  }
}
