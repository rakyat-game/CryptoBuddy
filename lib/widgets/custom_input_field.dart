import 'package:crypto_buddy/widgets/popup_message.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../utils/format_number.dart';

class CustomInputField extends StatefulWidget {
  final Function(String) onValueChange;
  final bool isAdding;
  final double maxDollarAmount;

  const CustomInputField({
    super.key,
    required this.onValueChange,
    required this.isAdding,
    required this.maxDollarAmount,
  });

  @override
  CustomInputFieldState createState() => CustomInputFieldState();
}

class CustomInputFieldState extends State<CustomInputField> {
  String currentValue = '';

  void _onButtonPressed(String value) {
    double maxDollarAmount = widget.maxDollarAmount;
    String potentialNewValue = currentValue + value;
    double newValueDouble = double.tryParse(potentialNewValue) ?? 0.0;

    if (value == 'backspace' && currentValue.isNotEmpty) {
      setState(() {
        currentValue = currentValue.substring(0, currentValue.length - 1);
        widget.onValueChange(currentValue);
      });
    } else if (newValueDouble <= maxDollarAmount) {
      setState(() {
        currentValue = potentialNewValue;
        widget.onValueChange(currentValue);
      });
    } else {
      // Show popup if maximum value is exceeded
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopupMessage(
              message:
                  'The maximum amount is \$${Formatter.formatNumber(maxDollarAmount)}',
            );
          });
    }
  }

  Widget _buildInputButton(String value, IconData? icon) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        _onButtonPressed(value);
      },
      child: Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.highlightColor),
        ),
        alignment: Alignment.center,
        child: icon != null
            ? Icon(icon, size: 34)
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
        ...List.generate(9, (index) => _buildInputButton('${index + 1}', null)),
        _buildInputButton('.', null),
        _buildInputButton('0', null),
        _buildInputButton('backspace', LineIcons.backspace),
      ],
    );
  }
}
