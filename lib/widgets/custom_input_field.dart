import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/models/portfolio.dart';
import 'package:crypto_buddy/widgets/popup_message.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../utils/format_number.dart';

class CustomInputField extends StatefulWidget {
  final Function(String) onValueChange;
  final bool isAdding;
  final double maxDollarAmount;
  final Market coin;

  const CustomInputField({
    super.key,
    required this.onValueChange,
    required this.isAdding,
    required this.maxDollarAmount,
    required this.coin,
  });

  @override
  CustomInputFieldState createState() => CustomInputFieldState();
}

class CustomInputFieldState extends State<CustomInputField> {
  String currentValue = '';

  void resetInputValue() {
    setState(() {
      currentValue = '';
    });
    widget.onValueChange(currentValue);
  }

  void _onButtonPressed(String value) {
    Portfolio portfolio = Provider.of<Portfolio>(context, listen: false);
    double maxDollarAmount = widget.maxDollarAmount;
    String potentialNewValue = currentValue + value;
    double currentValueDouble = double.tryParse(currentValue) ?? 0.0;
    double newValueDouble = double.tryParse(potentialNewValue) ?? 0.0;
    if (currentValue.contains('.') && currentValueDouble != 0.0) {
      List<String> parts = currentValue.split('.');
      if (parts.length > 1 && parts[1].length >= 2) {
        if (value != 'backspace') {
          return;
        }
      }
    }

    if (currentValueDouble != 0.0 &&
        newValueDouble > maxDollarAmount &&
        Formatter.formatNumber(currentValue) ==
            Formatter.formatNumber(maxDollarAmount) &&
        portfolio.getAsset(widget.coin) != null) {
      return;
    }
    if (value == 'backspace') {
      if (potentialNewValue == 'backspace') {
        setState(() {
          currentValue = '';
          widget.onValueChange(currentValue);
        });
      } else {
        setState(() {
          currentValue = currentValue.isNotEmpty
              ? currentValue.substring(0, currentValue.length - 1)
              : '';
          widget.onValueChange(currentValue);
        });
      }
    } else if ((newValueDouble <= maxDollarAmount ||
            Formatter.formatNumber(newValueDouble) ==
                Formatter.formatNumber(maxDollarAmount)) &&
        !(value == '0' && (currentValue == '' || currentValue == '0'))) {
      setState(() {
        currentValue = potentialNewValue;
        widget.onValueChange(currentValue);
      });
    } else if (!widget.isAdding && portfolio.getAsset(widget.coin) == null) {
      showDialog(
        context: context,
        builder: (context) => PopupMessage(
            message:
                'You don\'t own any ${widget.coin.name}.\nAdd some first!'),
      );
    } else if (currentValue != '') {
      setState(() {
        if (widget.isAdding) {
          currentValue = maxDollarAmount.toString().split('.')[0];
        } else {
          currentValue = maxDollarAmount.toStringAsFixed(2);
        }
        widget.onValueChange(currentValue);
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopupMessage(
              message:
                  'Your surpassed the maximum amount, which is \$${Formatter.formatNumber(maxDollarAmount)}!\n The number was set to the maximum amount.',
            );
          });
    }
  }

  int pressedButton = -1; // -1 means no button is pressed

  Widget _buildInputButton(String value, IconData? icon, int index) {
    ThemeData theme = Theme.of(context);
    bool isPressed = index == pressedButton;

    return GestureDetector(
      onTapDown: (_) => setState(() => pressedButton = index),
      onTapUp: (_) => setState(() => pressedButton = -1),
      onTapCancel: () => setState(() => pressedButton = -1),
      onTap: () {
        _onButtonPressed(value);
        setState(() => pressedButton = -1); // Reset pressed effect
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: isPressed
              ? theme.highlightColor
                  .withOpacity(0.5) // Darker color when pressed
              : theme.cardColor, // Normal color
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.highlightColor),
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, size: 34, color: theme.primaryColor)
            : Text(value,
                style: TextStyle(
                    fontSize: 24,
                    color: theme.primaryColor,
                    fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double availableHeight = MediaQuery.of(context).size.height * 0.5;
    double buttonHeight = (availableHeight - (8 * 2)) / 4;
    double buttonWidth = MediaQuery.of(context).size.width / 3;

    return GridView.count(
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: buttonWidth / buttonHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      children: <Widget>[
        ...List.generate(
            9, (index) => _buildInputButton('${index + 1}', null, index)),
        _buildInputButton('.', null, 9),
        _buildInputButton('0', null, 10),
        _buildInputButton('backspace', LineIcons.backspace, 11),
      ],
    );
  }
}
