import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {
  final String header;
  const GradientAppBar({super.key, required this.header});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.highlightColor.withOpacity(.2),
            theme.highlightColor.withOpacity(.001),
          ],
        )),
        child: AppBar(
          centerTitle: true,
          title: Text(
            header,
            style: TextStyle(color: theme.primaryColor),
          ),
          backgroundColor: Colors.white.withOpacity(0.001),
          surfaceTintColor: Colors.transparent,
        ));
  }
}
