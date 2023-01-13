import 'dart:convert';

import 'package:async_redux/async_redux.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_state.dart';

late Store<AdState> store;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();
  final adState = AdState(initializationStatus: initFuture);
  store = Store(initialState: adState);
  runApp(
    StoreProvider<AdState>(
      store: store,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter google ads",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BannerAd? bannerAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adState = store.state;
    adState.initializationStatus.then((status) {
      setState(() {
        bannerAd = BannerAd(
          size: AdSize.banner,
          adUnitId: AdState.bannerAdUnit,
          // todo: configure for listening to ad state
          listener: const BannerAdListener(),
          // todo: configure an ad request from server for an ad
          request: const AdRequest(),
        )..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, idx) => ListTile(
                  title: Text('$idx'),
                ),
                itemCount: 20,
              ),
            ),
            if (bannerAd != null)
              Container(
                height: 50,
                color: Colors.white,
                child: AdWidget(
                  ad: bannerAd!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
