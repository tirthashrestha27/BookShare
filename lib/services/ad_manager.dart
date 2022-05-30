import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "<YOUR_ADMOB_APP_ID>";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_ADMOB_APP_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

// ca-app-pub-3940256099942544/6300978111
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "<YOUR_IOS_ADMOB_APP_ID>"; //real banner id
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "<YOUR_ANDROID_INTERSTITIAL_AD_UNIT_ID>";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static BannerAd _bannerAd;

  static BannerAd _getbannerAD() {
    return BannerAd(adUnitId: bannerAdUnitId, size: AdSize.smartBanner);
  }

  static void show() {
    if (_bannerAd == null) _bannerAd = _getbannerAD();
    _bannerAd
      ..load()
      ..show(
        anchorType: AnchorType.bottom,
      );
  }

  static void hide() async {
    if (_bannerAd != null) await _bannerAd.dispose();
    _bannerAd = null;
  }
}
