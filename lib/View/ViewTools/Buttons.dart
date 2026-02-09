// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/FolderController.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Decorations/containerDecorations.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:ringtone_set/ringtone_set.dart';
import 'package:share/share.dart';

class Buttons extends GetView<PlayerController> {
  ItemData item;
  int index;
  bool local;
  FoldersConroller foldersController = FoldersConroller();
  Buttons(
    this.item,
    this.index,
    this.local,
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      //   decoration: MyDecorations.gradiant,
      width: 300,
      height: 50,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: local == false
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        onPressed: () {
                          DataProvider.currentsong = item;
                          if (controller.fromurl.value) {
                            foldersController.downloadfile();
                            Get.snackbar('Dowlnloading', item.name);
                          } else {
                            Share.shareFiles(item.songMP3Url as List<String>);
                            Get.snackbar(' prepare for Shareing ', item.name);
                          }
                        },
                        icon: Icon(
                          Icons.download,
                          color: Colors.greenAccent,
                        )),
                    IconButton(
                        onPressed: () {
                          controller.dbHelper
                              .addDataToTable(item, TablesId.fav_songes);
                          Get.snackbar('Add to Favorits', item.name);
                        },
                        icon: Icon(
                          Icons.favorite,
                          color: Color.fromARGB(255, 7, 121, 66),
                        )),
                    IconButton(
                        onPressed: () {
                          setRingToneFromNetworkButtons(context);
                        },
                        icon: Icon(
                          Icons.ring_volume_outlined,
                          color: Colors.yellow,
                        )),
                  ],
                ),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  IconButton(
                      onPressed: () {
                        controller.stopPlay();
                      },
                      icon: Icon(Icons.stop)),
                  IconButton(
                      onPressed: () {
                        print(item.songMP3Url);
                        Share.shareFiles([item.songMP3Url],
                            subject: item.name,
                            text:
                                'Shared form \n https://play.google.com/store/apps/details?id=com.M2yDevilopers.Oldmusic_Encyclopedia ');
                      },
                      icon: Icon(Icons.share)),
                  Container(
                    child: setReingToneFromFileButtons(),
                  ),
                ]),
              ),
      ),
    );
  }

  setRingToneFromNetworkButtons(context) {
    AwesomeDialog(
      dismissOnTouchOutside: true,
      context: context,
      animType: AnimType.scale,
      dialogType: DialogType.info,
      body: Container(
        decoration: MyDecorations.gradiantDark,
        height: 100,
        width: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  RingtoneSet.setRingtoneFromNetwork(item.songMP3Url).then(
                      (value) => Get.snackbar('RingTone seting',
                          'Ring Tone has been set to ${item.name} had been $value'));
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('RingTone seting'),
                    Icon(
                      Icons.phonelink_ring_outlined,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  RingtoneSet.setNotificationFromNetwork(item.songMP3Url).then(
                      (value) => Get.snackbar('Alarm seting',
                          'Alarm Tone has been set to ${item.name}   had been $value'));
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Alarm seting'),
                    Icon(
                      Icons.add_alarm_sharp,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  RingtoneSet.setNotificationFromNetwork(item.songMP3Url).then(
                      (value) => Get.snackbar('Notifications seting',
                          'Notifications Tone has been set to ${item.name}   had been $value'));
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notifications setin'),
                    Icon(
                      Icons.notifications_on,
                      color: Colors.green,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      title: 'Set Your Ring Ton Type',
      desc: 'Please select your Choices',
      /*  btnOkOnPress: () {
        Get.back();
      }, */
    )..show();
  }

  Widget setReingToneFromFileButtons() {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              //  FlutterRingtonePlayer.playRingtone().then((value) => null);

              RingtoneSet.setRingtoneFromFile(File(item.songMP3Url)).then(
                  (value) => Get.snackbar('RingTone seting',
                      'Ring Tone has been set to ${item.name}   had been $value'));
            },
            icon: Icon(
              Icons.phonelink_ring_outlined,
              color: Colors.green,
            )),
        IconButton(
            onPressed: () {
              RingtoneSet.setAlarmFromFile(File(item.songMP3Url)).then(
                  (value) => Get.snackbar('AlarmTone seting',
                      'Alarm Tone has been set to ${item.name}   had been $value'));
            },
            icon: Icon(
              Icons.alarm_sharp,
              color: Colors.green,
            )),
        IconButton(
            onPressed: () {
              RingtoneSet.setNotificationFromFile(File(item.songMP3Url)).then(
                  (value) => Get.snackbar('Notifications seting',
                      'Notifications Tone has been set to ${item.name}   had been $value'));
              ;
            },
            icon: Icon(
              Icons.notifications_on,
              color: Colors.green,
            ))
      ],
    );
  }
}
