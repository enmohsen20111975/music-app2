import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/View/CountriesSelector.dart';
import 'package:Khotab_Encyclopedia/View/Radio/RadioStationsView.dart';
// audio_service imports removed from main; background player is implemented separately when needed
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:Khotab_Encyclopedia/View/WaitloadingData.dart';
import 'package:Khotab_Encyclopedia/View/NewHomeScreen.dart';
import 'package:Khotab_Encyclopedia/View/SearchScreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:Khotab_Encyclopedia/View/SongesList.dart';
import 'package:Khotab_Encyclopedia/View/ViewDownloadedFiles.dart';
import 'package:Khotab_Encyclopedia/View/UpdateDataScreen.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'MP3Player/BackGroundPlayer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  // Initialize Google Mobile Ads and wait until ready
  try {
    await MobileAds.instance.initialize();
  } catch (e) {
    // ignore errors during ads init to avoid blocking startup
    debugPrint('MobileAds init error: $e');
  }

  runApp(const MyApp());
}

/// ******** to do in your plan  ************* /////
/// make offline source data done
/// ==========> Ring tone problem with package
/// ============> background Player done
/// add English music
/// equlizer
///  audio query
/// add mre categories
/// ///////////////////////////////////////////////////////////////
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  /// سياسة الخصوصية  https://www.privacypolicygenerator.info/live.php?token=D8bKtSRLyRtpTHTkUPn6hqv8TQ8nEhHR
  /// https://doc-hosting.flycricket.io/arabic-old-music-privacy-policy/f9d5ab5c-bf15-4b35-a370-9f4df1095760/privacy
  @override
  Widget build(BuildContext context) {
    return DataProvider(
      child: GetMaterialApp(
        color: const Color.fromARGB(255, 222, 224, 86),
        debugShowCheckedModeBanner: false,
        initialRoute: NewHomeScreen.route,
        routes: {
          UpdateDataScreen.route: (context) => UpdateDataScreen(),
          SearchScreen.route: (context) => SearchScreen(),
          SongelsListView.route: (context) => SongelsListView(),
          ViewDownLoadedFiles.route: (context) => ViewDownLoadedFiles(),
          NewHomeScreen.route: (context) => NewHomeScreen(),
          WaitloadingData.route: (context) => WaitloadingData(),
          CountriesSelector.route: (context) => CountriesSelector(),
        },
      ),
    );
  }
}
