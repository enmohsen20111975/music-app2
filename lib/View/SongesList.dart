import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

import 'package:Khotab_Encyclopedia/Scraping/ScrappingMP3Songes_Site.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Scraping/Melody4araAndSm3nabSacrapper.dart';

import 'package:Khotab_Encyclopedia/googleADs/adhelper.dart';

class SongelsListView extends StatefulWidget {
  const SongelsListView({super.key});
  static const route = "SongelsListView";
  @override
  State<SongelsListView> createState() => _SongelsListViewState();
}

class _SongelsListViewState extends State<SongelsListView> {
  // Sacrapper scrapper = Sacrapper();
  final controller = Get.put(PlayerController());
  GooGleAdmobhelper adhelper = GooGleAdmobhelper();

  @override
  void initState() {
    adhelper.createInterstitialAd();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 6, 87, 153),
      appBar: AppBar(title: Text('أختيار الأغنية')),
      body: SingleChildScrollView(
        child:
            view1() /* DataProvider.songerListSelector == 0 ? view1() : view2() */,
      ),
    );
  }

  Widget view1() {
    return FutureBuilder<List<ItemData>>(
      future: Sacrapper.getAlboumSongesList(DataProvider.alboumUrl),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> buttons = List.generate(snapshot.data!.length, (index) {
            return FadeInLeftBig(
              child: TextButton(
                onPressed: () async {
                  DataProvider.songeName = snapshot.data![index].name;
                  DataProvider.songUrl = snapshot.data![index].url;
                  DataProvider.songMP3Url = snapshot.data![index].songMP3Url;
                  DataProvider.alboum = snapshot.data!;
                  /******************************** */
                  controller.alboum.value = DataProvider.alboum;
                  controller.playIndex(
                      DataProvider.alboum.indexOf(DataProvider.alboum.first));
                  controller.fromurl(true);
                  Get.to(MusicList());
                  controller.adhelper.showInterstitialAd();
                  //Navigator.pushNamed(context, PlayerControl.route);;
                  if (!kDebugMode) {
                    adhelper.showInterstitialAd();
                  }
                },
                child: CircleAvatar(
                  foregroundColor: Color.fromARGB(255, 48, 108, 219),
                  radius: 50,
                  child: Text(
                    snapshot.data![index].name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color.fromARGB(255, 6, 4, 88), fontSize: 20),
                  ),
                ),
              ),
            );
          });
          return Center(
            child: Wrap(
              children: buttons,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }
}
