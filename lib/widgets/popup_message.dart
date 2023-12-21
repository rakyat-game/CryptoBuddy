import 'package:crypto_buddy/widgets/sorting_button.dart';
import 'package:flutter/material.dart';

class PopupMessage extends StatelessWidget {
  final String message;
  const PopupMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AlertDialog(
      backgroundColor: theme.cardColor,
      content: Text(
        message,
        style: TextStyle(color: theme.primaryColor),
      ),
      actions: [
        SortingButton(
          onTap: () => Navigator.of(context).pop(),
          label: 'OK Buddy',
        ),
      ],
    );
  }
}
