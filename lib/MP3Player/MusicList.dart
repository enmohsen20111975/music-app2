import 'dart:async';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/FolderController.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Decorations/containerDecorations.dart';
import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';
import 'package:Khotab_Encyclopedia/View/ViewTools/Buttons.dart';
import 'package:Khotab_Encyclopedia/googleADs/adhelper.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:ringtone_set/ringtone_set.dart';

import 'package:share/share.dart';

import '../Controllers/AppWriteIO.dart';

class MusicList extends GetView<PlayerController> {
  FoldersConroller foldersController = FoldersConroller();
  final ScrollController scontroller = ScrollController();
  void scrollDown() {
    double to = controller.playIndex.value.toDouble();
    Timer(Duration(milliseconds: 200), () {
      scontroller.position.animateTo(
        to,
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
      );
      scontroller.jumpTo(to);
      print('Scrolling down to $to');
    });
  }

  @override
  Widget build(BuildContext context) {
    DataProvider.alboum = controller.getItemDataFromGetxBox('alboum');
    controller.buildPlayList();
    scrollDown();
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 29, 29),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        //  decoration: MyDecorations.image1,
        child: ListView.builder(
            controller: scontroller,
            itemCount: controller.playlist.length,
            itemBuilder: ((context, index) {
              MediaItem data = controller.playlist.sequence[index].tag;
              ItemData item = ItemData.itemDataAdding(
                  name: data.title,
                  imageUrl: data.displayTitle!,
                  songMP3Url: data.displayDescription!,
                  songerName: data.artist!);
              // bool selected = (controller.playIndex.value == index);
              return Column(
                children: [
           /*        index % 4 == 0 && kDebugMode == false
                      ? controller.inbanner()
                      : Container(
                          height: 1,
                        ), */
                  Obx(() {
                    return FadeInRightBig(
                      child: ListTile(
                          autofocus: true,
                          focusColor: Color.fromARGB(255, 134, 10, 172),
                          selected: controller.playIndex.value == index,
                          selectedColor: Colors.pink,
                          selectedTileColor: Color.fromARGB(255, 54, 31, 101),
                          shape: BeveledRectangleBorder(
                            side: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 51, 141, 214)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: Card(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: (){
                                AppWrite appWrite=AppWrite();
                                appWrite.intialization();
                                appWrite.addData(item.toMap());
                              //  controller.play(index);
                              },
                              child: Text(
                                item.name,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 225, 231, 134)),
                              ),
                            ),
                          ),
                          leading: Text(
                            (index + 1).toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 127, 221, 143)),
                          ),
                          subtitle: playerButtons(item, index),
                          trailing: item.imageUrl.contains('http')
                              ? Image.network(item.imageUrl)
                              : Image.asset('assets/MEDIA/U.jpg'),
                          onTap: () {
                            controller.inPuse(false);
                            controller
                                .playIndex(index); // set current songe index
                            controller.play(index);
                            print('index=====> $index');
                            Get.to(PlayerScreen());
                            if (kDebugMode == false)
                              controller.adhelper.showInterstitialAd();
                          }),
                    );
                  }),
                ],
              );
            })),
      ),
    );
  }

  playerButtons(ItemData item, int index) {
    return Buttons(item, index, false);
  }
}
