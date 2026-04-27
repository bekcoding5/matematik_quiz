import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBanner extends StatefulWidget {
  const AdBanner({super.key});

  @override
  State<AdBanner> createState() => _AdBannerState();
}

class _AdBannerState extends State<AdBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final String _adUnitID = kReleaseMode
      ? 'ca-app-pub-3940256099942544/9214589741'
      : 'ca-app-pub-7707631696231474/4416627462';

  @override
  void initState() {
    super.initState();
    print('start');
    loadAD();
  }

  void loadAD() {
    print('loading');

    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: _adUnitID,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _isLoaded = true;
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    )..load();
    print('finished');
  }

  @override
  void dispose() {
    print('closed');

    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoaded && _bannerAd != null) {
      return SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    }
    return const SizedBox.shrink();
  }
}
