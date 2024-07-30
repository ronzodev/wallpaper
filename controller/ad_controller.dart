import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';


class AdController extends GetxController {
  late AppOpenAd _appOpenAd;
  InterstitialAd? _interstitialAd1;
  late BannerAd _bannerAd;
  late RewardedAd? _rewardedAd;
  late BannerAd _anchoredAdaptiveAd;
  final AppOpenAdStatus _appOpenAdStatus = AppOpenAdStatus.loading;
  AppOpenAdStatus get appOpenAdStatus => _appOpenAdStatus;

// Observable to track if the rewarded ad is loaded
  RxBool isRewardedAdLoaded = false.obs;
  // final rewardController = Get.put(RewardController());
  int _interstetialLoadAttempts = 0;
  // unit ids
  final String _bannerAdUnitId = 'ca-app-pub-9049620363523701/4743661101';
  final String _interstitialAdUnitId = 'ca-app-pub-9049620363523701/5097479354';


  @override
  void onInit() {
    super.onInit();

    _initAd();
    
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    )..load();
  }

 
  int remainingTimeWhenAdTriggered = 0;

  

  void _initAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
          // ad loaded
          onAdLoaded: (InterstitialAd ad) {
        _interstitialAd1 = ad;
        _interstetialLoadAttempts = 0;
      },
          // ad failed to load
          onAdFailedToLoad: (e) {
        _interstetialLoadAttempts += 1;
        _interstitialAd1 = null;
        if (_interstetialLoadAttempts >= 0) {
          _initAd();
        }
      }),
    );
  }

  void showInterstitialAd() {
    if (_interstitialAd1 != null) {
      _interstitialAd1!.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _initAd();
      }, onAdFailedToShowFullScreenContent: (ad, e) {
        ad.dispose();
        _initAd();
      });
      _interstitialAd1!.show();
    }
  }

  //////////////

  Widget buildBannerAd() {
    return SizedBox(
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd));
  }


  @override
  void onClose() {
    _appOpenAd.dispose();
    _interstitialAd1!.dispose();
    _bannerAd.dispose();
    _anchoredAdaptiveAd.dispose();
    _rewardedAd!.dispose(); // Dispose of the rewarded ad
    super.onClose();
  }
}

enum AppOpenAdStatus {
  loading,
  loaded,
  failed,
}