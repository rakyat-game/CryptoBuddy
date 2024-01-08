import 'package:coingecko_api/data/market.dart';
import 'package:crypto_buddy/main.dart';
import 'package:crypto_buddy/models/crypto_asset.dart';
import 'package:crypto_buddy/models/portfolio.dart';
import 'package:crypto_buddy/models/settings.dart';
import 'package:crypto_buddy/views/coin_listing_page.dart';
import 'package:crypto_buddy/views/manage_holdings_page.dart';
import 'package:crypto_buddy/views/portfolio_page.dart';
import 'package:crypto_buddy/views/settings_page.dart';
import 'package:crypto_buddy/widgets/custom_input_field.dart';
import 'package:crypto_buddy/widgets/popup_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SharedPreferences.setMockInitialValues({});
  testWidgets('Start app and switch pages', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Settings>(
              create: (_) => Settings(
                  isDarkModeOn: false, accentColor: 'Blue', currency: 'usd')),
          ChangeNotifierProvider<CoinDataProvider>(
              create: (_) => CoinDataProvider()),
          ChangeNotifierProvider<Portfolio>(
              create: (_) => Portfolio(assets: [])),
        ],
        child: const CryptoBuddy(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1000));

    expect(find.byType(CoinListingPage), findsOneWidget);
    final Finder portfolioIconFinder = find.byWidgetPredicate(
      (Widget widget) => widget is GButton && widget.text == 'Portfolio',
    );
    await tester.tap(portfolioIconFinder);
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1000));

    expect(find.byType(PortfolioPage), findsOneWidget);

    final Finder settingsIconFinder = find.byWidgetPredicate(
      (Widget widget) => widget is GButton && widget.text == 'Settings',
    );
    await tester.tap(settingsIconFinder);
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1000));

    expect(find.byType(SettingsPage), findsOneWidget);

    // Navigate back to CoinListingPage
    final Finder marketIconFinder = find.byWidgetPredicate(
      (Widget widget) => widget is GButton && widget.text == 'Market',
    );
    await tester.tap(marketIconFinder);
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1000));

    expect(find.byType(CoinListingPage), findsOneWidget);

    final Finder searchFieldFinder = find.byType(TextField);
    await tester.enterText(searchFieldFinder, 'Bitcoin');
    await tester.pump(const Duration(milliseconds: 1000));
    expect(find.text('Bitcoin'), findsWidgets);

    await tester.enterText(searchFieldFinder, '');
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.enterText(searchFieldFinder, 'Ethereum');
    await tester.pump(const Duration(milliseconds: 1000));
    await tester.pump(const Duration(milliseconds: 1000));
    expect(find.text('Ethereum'), findsWidgets);
  });
  // custom input field
  // manage holdings page

  SharedPreferences.setMockInitialValues({});

  CryptoAsset testAsset = CryptoAsset(
    coin: Market.fromJson({
      'id': 'bitcoin',
      'symbol': 'btc',
      'name': 'Bitcoin',
      'current_price': 40000.0,
    }),
    quantity: 1.0,
  );

  Portfolio testPortfolio = Portfolio(assets: [testAsset]);

  testWidgets('Test ManageHoldingsPage', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<Portfolio>(create: (_) => testPortfolio),
        ],
        child: MaterialApp(
          home: ManageHoldingsPage(
            asset: testAsset,
            portfolio: testPortfolio,
          ),
        ),
      ),
    );
    expect(find.text('Manage Your BTC Holdings'), findsOneWidget);

    final Finder manageButtonFinder = find.text('Add to Portfolio');
    await tester.tap(manageButtonFinder);
    await tester.pumpAndSettle();
    final Finder buttonFiveFinder = find.text('5');
    await tester.tap(buttonFiveFinder, warnIfMissed: false);
    await tester.pump();
    final Finder submitButtonFinder = find.text('Add to Portfolio');
    await tester.tap(submitButtonFinder);
    await tester.pumpAndSettle(); // Wait for any resulting actions to settle
    expect(find.byType(PopupMessage), findsOneWidget);
  });

  final testCoin = Market.fromJson({
    'id': 'bitcoin',
    'symbol': 'btc',
    'name': 'Bitcoin',
    'current_price': 40000.0,
  });
  testPortfolio = Portfolio(assets: [], investment: 0);
  String input = '';
  bool mode = true;

  testWidgets('Test CustomInputField', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider<Portfolio>.value(
        value: testPortfolio,
        child: MaterialApp(
          home: Scaffold(
            body: CustomInputField(
              onValueChange: (value) {
                input = value;
              },
              isAdding: mode,
              maxDollarAmount: 50000,
              coin: testCoin,
            ),
          ),
        ),
      ),
    );

    for (var i = 1; i <= 9; i++) {
      expect(find.text('$i'), findsOneWidget);
    }
    expect(find.text('.'), findsOneWidget);
    expect(find.text('0'), findsOneWidget);
    expect(find.byIcon(LineIcons.backspace), findsOneWidget);

    await tester.tap(find.text('1'));
    await tester.tap(find.text('2'));
    await tester.tap(find.text('3'));
    await tester.pumpAndSettle();
    expect(input, '123');
    await tester.tap(find.text('0'));
    await tester.tap(find.text('0'));
    await tester.tap(find.text('0'));
    await tester.pumpAndSettle();
    expect(find.byType(PopupMessage), findsOneWidget);
    await tester.tap(find.text('OK Buddy'));
    await tester.pumpAndSettle();

    for (var i = 0; i <= 6; i++) {
      await tester.tap(find.byIcon(LineIcons.backspace));
    }
    await tester.pumpAndSettle();
    expect(input, '');
    await tester.tap(find.text('1'));
    await tester.pumpAndSettle();
  });
}
