import 'package:crypto_buddy/models/settings.dart';
import 'package:crypto_buddy/views/accent_colors_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/gradient_app_bar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late Settings settings;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Settings settings = Provider.of<Settings>(context);
    final theme = Theme.of(context);
    final highlight = theme.highlightColor;
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: GradientAppBar(
          header: 'Settings',
        ),
      ),
      body: Column(children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 10),
                child: InkWell(
                  hoverColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  enableFeedback: true,
                  onTap: () => 3 + 4,
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 25, right: 23, top: 10, bottom: 10),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(.6),
                        border: Border.all(
                            color: highlight.withOpacity(
                                .42)), // color: Colors.grey.shade400
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dark Mode',
                              style: TextStyle(
                                  fontSize: 16, color: theme.primaryColor)),
                          SizedBox(
                            width: 40,
                            height: 15,
                            child: Switch(
                                inactiveTrackColor:
                                    theme.highlightColor.withOpacity(.2),
                                activeColor: highlight,
                                value: settings.isDarkModeOn,
                                onChanged: (value) {
                                  settings.setDarkMode(value);
                                  Settings.saveSettings(settings);
                                }),
                          )
                        ],
                      )),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: InkWell(
                  hoverColor: highlight.withOpacity(.2),
                  focusColor: highlight.withOpacity(.3),
                  highlightColor: highlight.withOpacity(.5),
                  borderRadius: BorderRadius.circular(20),
                  enableFeedback: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SetAccentColor()),
                    );
                  },
                  child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 10),
                      decoration: BoxDecoration(
                        color: theme.cardColor.withOpacity(.6),
                        border: Border.all(
                            color: highlight.withOpacity(
                                .42)), // color: Colors.grey.shade400
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Accent Color',
                              style: TextStyle(
                                  fontSize: 16, color: theme.primaryColor)),
                          Text(settings.accentColor,
                              style: TextStyle(
                                  color: theme.primaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400))
                        ],
                      )),
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
