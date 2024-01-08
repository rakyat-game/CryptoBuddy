import 'package:flutter/material.dart';

class SortingButton extends StatefulWidget {
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
  SortingButtonState createState() => SortingButtonState();
}

class SortingButtonState extends State<SortingButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color containerColor = widget.isActive
        ? theme.cardColor.withOpacity(0.5) // active color
        : theme.cardColor; // default color
    if (_isHovering) {
      containerColor = theme.highlightColor.withOpacity(0.3); // Hover color
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (event) => setState(() => _isHovering = true),
        onExit: (event) => setState(() => _isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: widget.padding,
          margin: widget.margin,
          decoration: BoxDecoration(
            color: containerColor, // use the color determined by state
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
                widget.label,
                style: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: widget.fontSize,
                ),
              ),
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  size: 18.0,
                  color: theme.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
