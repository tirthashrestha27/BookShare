import 'package:flutter/material.dart';
import 'package:bool_chain_v2/services/ad_manager.dart';
import 'package:firebase_admob/firebase_admob.dart';

class AdScreen extends StatefulWidget {
  @override
  _AdScreenState createState() => _AdScreenState();
}

class _AdScreenState extends State<AdScreen> {
  BannerAd _bannerAd;

  @override
  void initState() {
    FirebaseAdMob.instance.initialize(appId: AdManager.appId);

    _bannerAd = BannerAd(
      adUnitId: AdManager.bannerAdUnitId,
      size: AdSize.banner,
    );
    _loadBannerAd();

    super.initState();
  }

  // Future<void> _initAdMob() {
  //   ;
  // }

  void _loadBannerAd() {
    _bannerAd
      ..load()
      ..show(anchorType: AnchorType.bottom);
  }

  @override
  void dispose() {
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
    // return FutureBuilder<void>(
    //     future: _initAdMob(),
    //     builder: (context, snapshot) {
    //       return Container();
    //     });
  }
}
