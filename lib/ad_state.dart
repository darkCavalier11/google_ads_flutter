import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdState {
  Future<InitializationStatus> initializationStatus;

  AdState({required this.initializationStatus});

  // todo: replace with real add unit on prod
  static String get bannerAdUnit => Platform.isAndroid
      ? "ca-app-pub-3940256099942544/6300978111"
      : "ca-app-pub-3940256099942544/2934735716";
}
