import 'dart:io';

import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/models/crypto_asset.dart';
import 'package:crypto_buddy/utils/theme_data.dart';
import 'package:crypto_buddy/views/coin_listing_page.dart';
import 'package:crypto_buddy/views/portfolio_page.dart';
import 'package:crypto_buddy/views/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/portfolio_model.dart';
import 'models/settings.dart';

Future<void> main() async {
  //HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (context) => Settings(
                  isDarkModeOn: prefs.getBool('isDarkModeOn') ?? false,
                  accentColor: prefs.getString('accentColor') ?? 'Blue',
                  currency: prefs.getString('currency') ?? 'usd',
                )),
        ChangeNotifierProvider(
          create: (context) => CoinDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PortfolioModel(
            investment: 2000.0,
            assets: [
              CryptoAsset(
                coin: Market.fromJson({
                  'id': 'stellar',
                  'symbol': 'xlm',
                  'name': 'Stellar',
                  'current_price': 1500.0,
                }),
                quantity: 1,
              ),
              CryptoAsset(
                coin: Market.fromJson({
                  'id': 'cardano',
                  'symbol': 'ada',
                  'name': 'Cardano',
                  'current_price': 1000.0,
                }),
                quantity: 1,
              ),
            ],
          ),
        ),
      ],
      child: const CryptoBuddy(),
    ),
  );
}

class CryptoBuddy extends StatelessWidget {
  const CryptoBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context);
    return MaterialApp(
      title: 'CryptoBuddy',
      theme:
          AppTheme.lightTheme(AppTheme.getColorFromName(settings.accentColor)),
      darkTheme:
          AppTheme.darkTheme(AppTheme.getColorFromName(settings.accentColor)),
      themeMode: settings.isDarkModeOn ? ThemeMode.dark : ThemeMode.light,
      home: const PageSwitcher(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CoinDataProvider extends ChangeNotifier {
  List<Market> _coinData = [];

  List<Market> get coinData => _coinData;
  set coinData(List<Market> newData) {
    _coinData = newData;
    notifyListeners();
  }
}

class PageSwitcher extends StatefulWidget {
  const PageSwitcher({super.key});

  @override
  State<PageSwitcher> createState() => _PageSwitcherState();
}

class _PageSwitcherState extends State<PageSwitcher> {
  int _selectedIndex = 0;
  static const List<Widget> _pages = [
    CoinListingPage(),
    PortfolioPage(),
    SettingsPage(),
  ];
  final List<bool> _pageVisibility = [true, false, false];

  void _changeVisibility(int index) {
    setState(() {
      for (int i = 0; i < _pageVisibility.length; i++) {
        _pageVisibility[i] = i == index;
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: List.generate(_pages.length, (index) {
          return Visibility(
              maintainState: true,
              visible: _pageVisibility[index],
              child: _pages[index]);
        }),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min, // Use min to fit content
        children: [
          Divider(
            color: theme.highlightColor
                .withOpacity(.42), // Choose your color for the divider
            thickness: 1,
            height: .3, // Set the thickness of the divider
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: _changeVisibility,
              gap: 8,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              color: theme.primaryColor,
              activeColor: theme.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              tabActiveBorder: Border.all(
                  color: theme.highlightColor.withOpacity(.5), width: .5),
              tabBackgroundColor: Colors.transparent,
              tabBackgroundGradient: LinearGradient(colors: [
                theme.highlightColor.withOpacity(.1),
                theme.highlightColor.withOpacity(.02),
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              tabs: const [
                GButton(icon: LineIcons.barChartAlt, text: 'Coins'),
                GButton(icon: LineIcons.pieChart, text: 'Portfolio'),
                GButton(icon: LineIcons.cog, text: 'Settings'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* HttpOverrides is used to fix certificate exception on old Android-Version 7.0 (my physical test device is a Samsung 5A 2016)
, issue is explained here: https://letsencrypt.org/docs/dst-root-ca-x3-expiration-september-2021/#:~:text=On%20September%2030%202021%2C%20there,accept%20your%20Let */
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
