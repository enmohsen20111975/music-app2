import 'package:Khotab_Encyclopedia/googleADs/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GooGleAdmobhelper {
  static String get bannerunit => AdHelper.bannerAdUnitId;
  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  static int maxFailedLoadAttempts = 5;
  static InterstitialAd? _interstitialAd;
  static int _numInterstitialLoadAttempts = 0;
  late bool calling;
  int press = 1;
  static RewardedAd? _rewardedAd;
  static int _numRewardedLoadAttempts = 0;

  Future<void> createInterstitialAd() async {
    return await InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId, // InterstitialAd.testAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
              createInterstitialAd();
            }
          },
        ));
  }

  Future<void> showInterstitialAd() async {
    createInterstitialAd();
    if (_interstitialAd == null) {
      return;
    }
    _interstitialAd!.fullScreenContentCallback =
        await FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }

  Future<void> createRewardedAd() async {
    await RewardedAd.load(
        adUnitId: AdHelper.rewardedAdUnitId, //RewardedAd.testAdUnitId,
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              createRewardedAd();
            }
          },
        ));
  }

  Future<void> showRewardedAd() async {
    if (_rewardedAd == null) {
      return;
    }
    _rewardedAd!.fullScreenContentCallback = await FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(onUserEarnedReward: (ad, RewardItem reward) {});
    _rewardedAd = null;
  }

  bool togle(int pre) {
    double re = pre % 2;
    if (re == 0) {
      calling = false;

      return calling;
    } else {
      calling = true;

      return calling;
    }
  }

  static BannerAd getBunnerAD() {
    BannerAd bannerAD = new BannerAd(
        size: AdSize.fullBanner,
        adUnitId: bannerunit,
        listener: BannerAdListener(),
        request: AdRequest());
    return bannerAD;
  }
}
