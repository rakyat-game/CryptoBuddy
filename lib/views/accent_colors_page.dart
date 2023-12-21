import 'package:crypto_buddy/models/settings.dart';
import 'package:flutter/material.dart';

import '../widgets/accent_color_list.dart';
import '../widgets/gradient_app_bar.dart';

class SetAccentColor extends StatefulWidget {
  const SetAccentColor({super.key});

  @override
  State<SetAccentColor> createState() => _SetAccentColorState();
}

class _SetAccentColorState extends State<SetAccentColor> {
  @override
  void initState() {
    super.initState();
  }

  void changeAccentColor(Settings settings, String color) {
    setState(() {
      settings.setAccentColor(color);
    });
    Settings.saveSettings(settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GradientAppBar(
          header: 'Accent Colors',
        ),
      ),
      body: AccentColorList(
        onColorSelect: changeAccentColor,
      ),
    );
  }
}
