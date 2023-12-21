import 'package:crypto_buddy/models/settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccentColorList extends StatefulWidget {
  final Function(Settings setting, String color) onColorSelect;
  const AccentColorList({super.key, required this.onColorSelect});

  @override
  State<AccentColorList> createState() => _AccentColorListState();
}

class _AccentColorListState extends State<AccentColorList> {
  List<String> accentColors = ['Blue', 'Red', 'Green', 'Grey'];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Settings settings = Provider.of<Settings>(context);
    String currentAccentColor =
        settings.accentColor; // Assuming this method exists

    return ListView.builder(
        itemCount: accentColors.length,
        itemBuilder: (BuildContext context, int index) {
          Color accentColor;
          switch (accentColors[index]) {
            case 'Blue':
              accentColor = Colors.blue.withRed(10).withOpacity(.42);
              break;
            case 'Red':
              accentColor = Colors.red.shade400.withOpacity(.42);
              break;
            case 'Green':
              accentColor = Colors.lime.withOpacity(.42);
              break;
            case 'Grey':
              accentColor = Colors.grey.withOpacity(.42);
            default:
              accentColor = Colors.blue.withRed(10).withOpacity(.42);
              break;
          }

          bool isSelected = currentAccentColor == accentColors[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: InkWell(
              onTap: () => widget.onColorSelect(settings, accentColors[index]),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  border: Border.all(color: accentColor),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      accentColors[index],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: theme.primaryColor),
                    ),
                    if (isSelected) Icon(Icons.check, color: accentColor),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
