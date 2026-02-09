import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/Scraping/Melody4araAndSm3nabSacrapper.dart';
import 'package:Khotab_Encyclopedia/Scraping/MrMazikaScrapping.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/globalData.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/lecturersFromAssabile.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/IsalmicScrapping.dart';
import 'package:Khotab_Encyclopedia/googleADs/adhelper.dart';

class WaitloadingData extends StatefulWidget {
  const WaitloadingData({super.key});
  static const route = 'WaitloadingData';
  @override
  State<WaitloadingData> createState() => _WaitloadingDataState();
}

class _WaitloadingDataState extends State<WaitloadingData> {
  GooGleAdmobhelper adhelper = GooGleAdmobhelper();
  Stream<List<ItemData>>? _stream;
  Stream<List<ItemData>> get stream => _stream ?? Stream.value([]);
  final controller = Get.put(PlayerController());
  
  @override
  void initState() {
    DataProvider.alboum.clear();
    
    switch (DataProvider.screenNameForViewDownLoad) {
      case 'CourseListView':
        _stream = IslamicTapeSacrapper.getFromalnahjLactureDataStreaming(
            DataProvider.mainCategoryUrl, DataProvider.subCategoryUrl);
        break;
      case 'SelectedCources':
        _stream = ScrappingOfAssbile.archiveOrgScrapper(
            GlobalData.selectedLessonMap[DataProvider.selectedCourceId]['uri']);
        break;
      case 'SongerAlboums':
        _stream = MrMazikkaScrapping.getAlboumSongesList(DataProvider.alboumUrl);
        break;
      case 'SingerAllSonges':
        _stream = MrMazikkaScrapping.singerAllSonges(DataProvider.subCategoryUrl);
        break;
      case 'SongesForSelectedSingeByCountry':
        _stream = Melody4arabSacrapper.getSongesListFromSm3na(
            DataProvider.selectedCountry.url);
        break;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/MEDIA/bb1.jpg'),
            filterQuality: FilterQuality.high,
            fit: BoxFit.fill),
      ),
      child: StreamBuilder<List<ItemData>>(
          stream: stream,
          builder: (context, AsyncSnapshot<List<ItemData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data != null) {
                DataProvider.alboum = snapshot.data!;
                // Use Future.microtask instead of Timer for UI updates
                Future.microtask(() {
                  controller.alboum.value = DataProvider.alboum;
                  controller.playIndex(0);
                  final route = Get.off(() => MusicList());
                  if (route != null) {
                    route.then((_) {
                      if (!kDebugMode) {
                        adhelper.showInterstitialAd();
                      }
                    });
                  }
                });
              }
            }

            if (snapshot.hasData && snapshot.data != null) {
              DataProvider.alboum = snapshot.data!;
              return Center(
                child: Card(
                  color: Colors.transparent,
                  child: AutoSizeText(
                    '  يرجي الإنظار لحن تحميل المواد الصوتية  \n ${snapshot.data?.length ?? 0}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 30,
                        color: Colors.blue),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 60),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text('Error: ${snapshot.error}'),
                    ),
                  ],
                ),
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CircularProgressIndicator(
                      strokeWidth: 5,
                      semanticsLabel: 'يرجي الإنتظار  لحين التحميل  ...',
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'يرجي الإنتظار  لحين التحميل  ...',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 30,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    controller.dispose();
    super.dispose();
  }
}
