import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/View/Radio/stations.dart';
import 'package:flutter/material.dart';

import 'package:Khotab_Encyclopedia/Scraping/RadioScrapping.dart';
import 'package:get/get.dart';
/* import 'package:radio_player/radio_player.dart'; */

class RadioStationsView extends GetView<PlayerController> {
  List<ItemData> data = [];
  @override
  Widget build(BuildContext context) {
    data = StationsData.loadstations();
    return Scaffold(
      body: Container(
          child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (_, i) {
                return InkWell(
                  onTap: () {
                    controller.alboum.value = DataProvider.alboum;
                    controller.playIndex(1);
                    controller.fromurl(true);
                    Get.to(MusicList());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Card(
                        child: Text(data[i].alboumName),
                      ),
                      Card(
                        child: Text(data[i].name),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
