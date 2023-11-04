import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool isActive;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.label,
    this.isActive = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.only(left: 10, right: 5),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withRed(10) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withRed(10),
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
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (icon != null)
              Icon(
                icon,
                size: 18.0,
                color: Colors.black,
              ),
          ],
        ),
      ),
    );
  }
}
