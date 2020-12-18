import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

import 'main.dart';

class AdmobService{
  static const String testDevice = 'YOUR_DEVICE_ID';
  static BannerAd _bannerAd;
  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    childDirected: true,
    nonPersonalizedAds: true,
  );

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: getBannerAdUnitId(),
      size: AdSize.fullBanner,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  static showBanner(double offs){
    _bannerAd ??= AdmobService().createBannerAd();
    _bannerAd
      ..load()..show(anchorOffset: offs,horizontalCenterOffset:0);
  }
 static removeBanner(){
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  String getAdMobId(){
    if(Platform.isIOS){
      return 'ca-app-pub-2182756097973140~5592479163';
    }else if(Platform.isAndroid){
      print('ca-app-pub-2182756097973140~3169676013');
      return 'ca-app-pub-2182756097973140~3169676013';
    }
    return null;
  }
  String getBannerAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2182756097973140/6606177931';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2182756097973140/9148060303';
    }
    return null;
  }
  String getinterstitialAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2182756097973140/8027070819';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2182756097973140/9973372023';
    }
    return null;
  }
  String getNativeAdUnitId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-2182756097973140/5923829260';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-2182756097973140/4465237936';
    }
    return null;
  }
}