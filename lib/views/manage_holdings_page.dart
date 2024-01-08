import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/main.dart';
import 'package:crypto_buddy/models/portfolio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/crypto_asset.dart';
import '../utils/format_number.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/popup_message.dart';
import '../widgets/sorting_button.dart';

class ManageHoldingsPage extends StatefulWidget {
  final CryptoAsset asset;
  final bool isAdding;
  final Portfolio portfolio;

  const ManageHoldingsPage(
      {super.key,
      required this.asset,
      this.isAdding = true,
      required this.portfolio});

  @override
  ManageHoldingsPageState createState() => ManageHoldingsPageState();
}

class ManageHoldingsPageState extends State<ManageHoldingsPage> {
  GlobalKey<CustomInputFieldState> customInputFieldKey = GlobalKey();
  late bool isAdding;
  late Portfolio portfolio;
  late double currentTotalValue;
  late double currentCoinQuantity;
  String inputValue = '';

  @override
  void initState() {
    super.initState();
    isAdding = widget.isAdding;
    portfolio = widget.portfolio;
    currentTotalValue = widget.asset.totalValue;
    currentCoinQuantity = widget.asset.quantity;
  }

  void toggleMode() {
    setState(() {
      isAdding = !isAdding;
      inputValue = '';
      customInputFieldKey.currentState?.resetInputValue();
      portfolio = Provider.of<Portfolio>(context, listen: false);
    });
  }

  void updateInputValue(String newValue) {
    double maxDollarAmount = isAdding ? 1000000 : currentTotalValue;
    double newValueDouble = double.tryParse(newValue) ?? 0.0;

    if (newValueDouble > maxDollarAmount ||
        Formatter.formatNumber(newValueDouble) ==
            Formatter.formatNumber(maxDollarAmount)) {
      newValue = maxDollarAmount.toString();
    } else {
      newValue = newValueDouble.toString();
    }
    setState(() {
      inputValue = newValue;
      currentTotalValue = portfolio.getAsset(widget.asset.coin) == null
          ? 0.0
          : portfolio.getAsset(widget.asset.coin)!.totalValue;
    });
  }

  void handleAssetChange() {
    if (getDollarAmount() == 0.0) {
      showDialog(
        context: context,
        builder: (context) =>
            const PopupMessage(message: 'Please enter a number first!'),
      );
      return;
    }
    Market coin = Provider.of<CoinDataProvider>(context, listen: false)
        .coinData
        .firstWhere((coin) => coin.id == widget.asset.coin.id);
    double dollarAmount = getDollarAmount();
    double coinAmount = getCoinAmount();
    CryptoAsset? asset = portfolio.getAsset(widget.asset.coin);

    if (isAdding) {
      portfolio.buyAsset(CryptoAsset(coin: coin, quantity: coinAmount));
    } else {
      if (asset != null) {
        portfolio.sellAsset(
            portfolio.getAsset(coin)!, coinAmount, dollarAmount);
      } else {
        showDialog(
          context: context,
          builder: (context) => PopupMessage(
              message: 'You don\'t own any ${coin.name}.\nAdd some first!'),
        );
        return;
      }
    }
    asset = portfolio.getAsset(widget.asset.coin);
    setState(() {
      inputValue = '';
      portfolio = Provider.of<Portfolio>(context, listen: false);
      if (asset != null) {
        currentTotalValue = asset.totalValue;
        currentCoinQuantity = asset.quantity;
      } else {
        currentTotalValue = 0;
        currentCoinQuantity = 0;
      }
      customInputFieldKey.currentState?.resetInputValue();
    });
    showDialog(
      context: context,
      builder: (context) => PopupMessage(
          message:
              '${isAdding ? "Added" : "Removed"} ${Formatter.formatNumber(coinAmount)} ${widget.asset.coin.symbol.toUpperCase()} worth \$${Formatter.formatNumber(dollarAmount)} ${isAdding ? "to" : "from"} your portfolio.'),
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
    return isAdding
        ? currentTotalValue + getDollarAmount()
        : currentTotalValue - getDollarAmount();
  }

  double getNewCoinAmount() {
    return isAdding
        ? currentCoinQuantity + getCoinAmount()
        : currentCoinQuantity - getCoinAmount();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: GradientAppBar(
            header:
                'Manage Your ${widget.asset.coin.symbol.toUpperCase()} Holdings'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
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
                          if (index == 0 && !isAdding ||
                              index == 1 && isAdding) {
                            toggleMode();
                          }
                        });
                      },
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 38),
                          child: Text(
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              'Add ${widget.asset.coin.symbol.toUpperCase()}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(
                        'New ${widget.asset.coin.symbol.toUpperCase()} Balance    \$${Formatter.formatNumber(getNewDollarAmount())}',
                        style:
                            TextStyle(fontSize: 18, color: theme.primaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'New ${widget.asset.coin.symbol.toUpperCase()} Quantity   ${Formatter.formatNumber(getNewCoinAmount())} ${widget.asset.coin.symbol.toUpperCase()}',
                          style: TextStyle(
                              fontSize: 18, color: theme.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
            child: SortingButton(
              onTap: handleAssetChange,
              fontSize: 16,
              padding: const EdgeInsets.symmetric(vertical: 13),
              label: isAdding ? 'Add to Portfolio' : 'Remove from Portfolio',
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.48,
            child: CustomInputField(
              key: customInputFieldKey,
              onValueChange: updateInputValue,
              isAdding: isAdding,
              maxDollarAmount: isAdding ? 1000000 : currentTotalValue,
              coin: widget.asset.coin,
            ),
          ),
        ],
      ),
    );
  }
}
