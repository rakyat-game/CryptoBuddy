import 'package:flutter/material.dart';

import '../models/crypto_asset.dart';
import '../utils/format_number.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/popup_message.dart';
import '../widgets/sorting_button.dart';

class ManageHoldingsPage extends StatefulWidget {
  final CryptoAsset asset;

  const ManageHoldingsPage({super.key, required this.asset});

  @override
  ManageHoldingsPageState createState() => ManageHoldingsPageState();
}

class ManageHoldingsPageState extends State<ManageHoldingsPage> {
  bool isAdding = true;
  String inputValue = '0';

  void toggleMode() {
    setState(() {
      isAdding = !isAdding;
      inputValue = '0';
    });
  }

  void updateInputValue(String newValue) {
    double maxDollarAmount = isAdding ? 1000000 : widget.asset.totalValue;
    double newValueDouble = double.tryParse(newValue) ?? 0.0;

    if (newValueDouble > maxDollarAmount) {
      newValue = maxDollarAmount.toString();
    } else {
      newValue = newValueDouble.toString();
    }

    setState(() {
      inputValue = newValue;
    });
  }

  void handleAssetChange() {
    double dollarAmount = getDollarAmount();
    double coinAmount = getCoinAmount();

    // Logic to update the portfolio

    showDialog(
      context: context,
      builder: (context) => PopupMessage(
          message:
              '${isAdding ? "Added" : "Removed"} ${Formatter.formatNumber(coinAmount)} ${widget.asset.coin.symbol.toUpperCase()} worth \$${Formatter.formatNumber(dollarAmount)} to your portfolio.'),
    );
  }

  double getDollarAmount() {
    return double.tryParse(inputValue) ?? 0.0;
  }

  double getCoinAmount() {
    double dollarAmount = getDollarAmount();
    return dollarAmount / widget.asset.coin.currentPrice!;
  }

  double getNewDollarAmount() {
    double currentAmount = widget.asset.totalValue;
    double changeAmount = getDollarAmount();
    return isAdding
        ? currentAmount + changeAmount
        : currentAmount - changeAmount;
  }

  double getNewCoinAmount() {
    double currentCoins = widget.asset.quantity;
    double changeCoins = getCoinAmount();
    return isAdding ? currentCoins + changeCoins : currentCoins - changeCoins;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    void handleAssetChange() {
      double dollarAmount = getDollarAmount();
      double coinAmount = getCoinAmount();
      double maxDollarAmount = isAdding ? 1000000 : dollarAmount;
      if (dollarAmount > maxDollarAmount) {
        dollarAmount = maxDollarAmount;
        coinAmount = dollarAmount / widget.asset.coin.currentPrice!;
      }

      // Logic to update the portfolio

      showDialog(
        context: context,
        builder: (context) => PopupMessage(
            message:
                '${isAdding ? "Added" : "Removed"} ${Formatter.formatNumber(coinAmount)} ${widget.asset.coin.symbol.toUpperCase()} worth \$${Formatter.formatNumber(dollarAmount)} to your portfolio.'),
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GradientAppBar(
            header:
                'Manage ${widget.asset.coin.symbol.toUpperCase()} Holdings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 21),
                  ToggleButtons(
                    borderColor: theme.highlightColor,
                    disabledColor: theme.cardColor,
                    color: theme.primaryColor,
                    selectedColor: theme.primaryColor,
                    selectedBorderColor: theme.highlightColor,
                    fillColor: theme.highlightColor.withOpacity(.5),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    borderWidth: 1.5,
                    isSelected: [isAdding, !isAdding],
                    onPressed: (int index) {
                      setState(() {
                        if (index == 0 && !isAdding || index == 1 && isAdding) {
                          toggleMode();
                        }
                      });
                    },
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 38),
                        child: Text(
                            style: const TextStyle(fontSize: 16),
                            'Add ${widget.asset.coin.symbol.toUpperCase()}'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                            style: const TextStyle(fontSize: 16),
                            'Remove ${widget.asset.coin.symbol.toUpperCase()}'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 21),
                  Text(
                    '\$${Formatter.formatNumber(getDollarAmount())}',
                    style: TextStyle(fontSize: 44, color: theme.primaryColor),
                  ),
                  Text(
                    '${Formatter.formatNumber(getCoinAmount())} ${widget.asset.coin.symbol.toUpperCase()}',
                    style: TextStyle(fontSize: 30, color: theme.primaryColor),
                  ),
                  const SizedBox(
                    height: 21,
                  ),
                  Text(
                    'New USD Value       \$${Formatter.formatNumber(getNewDollarAmount())}',
                    style: TextStyle(fontSize: 18, color: theme.primaryColor),
                  ),
                  Text(
                    'New Coin Quantity  ${Formatter.formatNumber(getNewCoinAmount())} ${widget.asset.coin.symbol.toUpperCase()}',
                    style: TextStyle(fontSize: 18, color: theme.primaryColor),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: SortingButton(
              onTap: handleAssetChange,
              padding: const EdgeInsets.symmetric(vertical: 13),
              label: isAdding ? 'Add to Portfolio' : 'Remove from Portfolio',
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.48,
            child: CustomInputField(
              onValueChange: updateInputValue,
              isAdding: isAdding,
              maxDollarAmount: isAdding ? 1000000 : widget.asset.totalValue,
            ),
          ),
        ],
      ),
    );
  }
}
