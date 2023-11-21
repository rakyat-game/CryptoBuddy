import 'dart:io';

import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/models/crypto_asset.dart';
import 'package:crypto_buddy/views/coin_listing_page.dart';
import 'package:crypto_buddy/views/portfolio_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'models/portfolio_model.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    // provider is used to change & access the portfolio across different pages
    ChangeNotifierProvider(
      // fill portfolio with test data, will later be replaced with user data
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
      child: const CryptoBuddy(),
    ),
  );
}

class CryptoBuddy extends StatelessWidget {
  const CryptoBuddy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CryptoBuddy',
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
      ),
      home: const PageSwitcher(),
      debugShowCheckedModeBanner: false,
    );
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
    Portfolio(),
  ];
  final List<bool> _pageVisibility = [true, false];

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
    return Scaffold(
      body: Stack(
        children: List.generate(_pages.length, (index) {
          return Visibility(
              maintainState: true,
              visible: _pageVisibility[index],
              child: _pages[index]);
        }),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GNav(
              selectedIndex: _selectedIndex,
              onTabChange: _changeVisibility,
              gap: 8,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              tabActiveBorder: Border.all(color: Colors.white.withRed(10)),
              tabs: const [
                GButton(icon: LineIcons.barChartAlt, text: 'Coins'),
                GButton(icon: LineIcons.pieChart, text: 'Portfolio'),
              ]),
        ),
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
