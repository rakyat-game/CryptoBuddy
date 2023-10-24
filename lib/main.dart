import 'dart:io';

import 'package:crypto_buddy/pages/coin_tracking_page.dart';
import 'package:flutter/material.dart';

void main() {
  /* HttpOverrides is needed to fix certificate exception on old Android-Version 7.0 (my physical test device is a Samsung 5A 2016)
      , issue is explained here: https://letsencrypt.org/docs/dst-root-ca-x3-expiration-september-2021/#:~:text=On%20September%2030%202021%2C%20there,accept%20your%20Let */
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CoinTrackingPage(),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
