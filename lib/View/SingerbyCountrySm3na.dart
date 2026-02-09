import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataBase/DataBaseHelper.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/Scraping/Melody4araAndSm3nabSacrapper.dart';
import 'package:Khotab_Encyclopedia/View/WaitloadingData.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingerByCountry extends GetView<PlayerController> {
  late Stream<List<ItemData>> stream;

  List<ItemData> saved = [];
  @override
  Widget build(BuildContext context) {
    List<ItemData> tempsaved = controller.allSongersData.value.cast();
    saved = List.from(tempsaved.where((element) =>
        element.songerName.trim() == DataProvider.selectedCountry.name.trim()));
    DataProvider.subCategoryName = DataProvider.selectedCountry.name;
    return Scaffold(
      body: songesView(),
      bottomSheet: TextButton.icon(
        onPressed: () {
          //   DataProvider.alboum = data;
          DataProvider.screenNameForViewDownLoad =
              'SongesForSelectedSingeByCountry';
          DataProvider.fromUrl = true;
          Navigator.pushNamed(context, WaitloadingData.route);
        },
        icon: Icon(Icons.play_arrow),
        label: Text('تشغيل جميع الأغاني'),
      ),
    );
  }

  Widget songesView() {
    List<ItemData> output = [];
    return Center(
      child: StreamBuilder<List<ItemData>>(
          stream: Melody4arabSacrapper.getSongesListFromSm3na(
              DataProvider.selectedCountry.url),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              output = snapshot.data!;
              print(saved.length);
              output.addAll(saved);
              output.toSet().toList();
              return ListView.builder(
                  itemCount: output.length,
                  itemBuilder: ((context, index) {
                    return card(output[index], context);
                  }));
            }
            if (snapshot.hasData) {
              return Center(
                  child: AutoSizeText(snapshot.data!.length.toString()));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget card(ItemData data, context) {
    if (data.songMP3Url.contains('.mp3')) {
    } else {
      data.songMP3Url = data.url;
    }
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      height: 40,
      decoration: BoxDecoration(
        //   color: Color.fromARGB(25, 144, 13, 164),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 8, 73, 119),
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 104, 29, 175),
          Color.fromARGB(255, 55, 6, 88)
        ], begin: Alignment.center, end: Alignment.topCenter),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 56, 56, 54),
            offset: Offset(10, 20),
            blurRadius: 30,
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          DataProvider.alboumName = DataProvider.selectedCountry.name;
          DataProvider.alboumUrl = data.url;
          DataProvider.alboum.clear();
          DataProvider.alboum.add(data);

          /******************************** */
          controller.alboum.value = DataProvider.alboum;
          controller.playIndex(
              DataProvider.alboum.indexOf(DataProvider.alboum.first));
          controller.fromurl(true);
          Get.to(MusicList());
          //Navigator.pushNamed(context, PlayerControl.route);;
        },
        child: AutoSizeText(
          data.name,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.yellowAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
