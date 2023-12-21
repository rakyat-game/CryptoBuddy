import 'package:flutter/material.dart';

class SortingButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool isActive;
  final IconData? icon;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double fontSize;

  const SortingButton(
      {super.key,
      required this.onTap,
      required this.label,
      this.isActive = false,
      this.icon,
      this.margin = const EdgeInsets.only(left: 10.0, right: 5.0),
      this.padding = const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      this.fontSize = 14.0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding,
        margin: margin,
        decoration: BoxDecoration(
          color: isActive ? theme.cardColor.withOpacity(.5) : theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.highlightColor,
              spreadRadius: 0.3,
              blurRadius: 0.3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
            if (icon != null)
              Icon(
                icon,
                size: 18.0,
                color: theme.primaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
