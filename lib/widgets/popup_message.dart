import 'package:crypto_buddy/widgets/sorting_button.dart';
import 'package:flutter/material.dart';

class PopupMessage extends StatelessWidget {
  final String message;
  const PopupMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(message),
      actions: [
        SortingButton(
          onTap: () => Navigator.of(context).pop(),
          label: 'OK Buddy',
        ),
      ],
    );
  }
}
