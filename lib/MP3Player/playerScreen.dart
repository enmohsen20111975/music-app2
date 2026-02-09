// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:async';
//import 'package:flutter_ez_setup/flutter_ez_setup.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Decorations/containerDecorations.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:audio_service/audio_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_visualizer/music_visualizer.dart';
import 'package:siri_wave/siri_wave.dart';

class PlayerScreen extends GetView<PlayerController> {
  double width = 0;
  /* List<EqualizerModel> _equalizers;
  EqualizerModel _selectedEqualizer;
  void _initEqualizer() async {
    await FlutterEzSetup.initEqualizer();
    _equalizers = await FlutterEzSetup.getEqualizers();
    _selectedEqualizer = _equalizers.first;
    controller.player.set.setEqualizer(_selectedEqualizer.id);
  } */

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 32, 31, 31),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         /*  kDebugMode == false
              ? Expanded(flex: 2, child: controller.inbanner())
              : Container(), */
          Expanded(
            flex: 10,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.7,
              child: avatarDataView(),
            ),
          ),
          /* kDebugMode == false
              ? Expanded(flex: 2, child: controller.inbanner())
              : Container(), */
          Expanded(
            flex: 4,
            child: Container(
              decoration: MyDecorations.gradiant2,
              child: Column(
                children: [
                  progress(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: playerButtons(),
                  ),
                ],
              ),
            ),
          ),
         /*  kDebugMode == false
              ? Expanded(flex: 2, child: controller.inbanner())
              : Container(), */
        ],
      ),
    );
  }

  Widget playListView() {
    return ListView.builder(
        itemCount: controller.playlist.length,
        itemBuilder: (_, i) {
          return InkWell(
            onTap: () {
              controller.playIndex(i);
              controller.play(controller.playIndex.value);
              controller.update();
            },
            child: Obx(() {
              MediaItem data = controller.playlist.sequence[i].tag;
              return Container(
                  decoration: controller.playIndex.value == i
                      ? MyDecorations.gradiant
                      : MyDecorations.greenCard,
                  child: AutoSizeText(
                    data.title,
                    textAlign: TextAlign.center,
                    style: controller.playIndex.value == i
                        ? TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)
                        : TextStyle(color: Colors.white, fontSize: 14),
                  ));
            }),
          );
        });
  }

  Widget visualization() {
    final vcontroller = SiriWaveController();
    final List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.brown
    ];
    final List<int> duration = [900, 700, 600, 800, 500];
    vcontroller.setAmplitude(1);
    vcontroller.setSpeed(0.1);
    vcontroller.setFrequency(8);
    return ListView(scrollDirection: Axis.horizontal, children: [
      Container(width: width, child: SiriWave(controller: vcontroller)),
      Container(
        width: width,
        child: MusicVisualizer(
          barCount: 30,
          colors: colors,
          duration: duration,
        ),
      ),
      //  playListView(),
      // avatarView(),
    ]);
  }

  Widget avatarView() {
    MediaItem data =
        controller.playlist.sequence[controller.playIndex.value].tag;
    return Container(
      decoration: data.displayTitle!.toString().contains('http')
          ? BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(data.displayTitle!), fit: BoxFit.fill))
          : BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/MEDIA/songers.jpg'),
                  fit: BoxFit.fill)),
    );
  }

  Widget avatarDataView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          return Expanded(
            flex: 6,
            child: controller.fromurl == true
                ? controller.playlistView.value
                    ? visualization()
                    : avatarView()
                : controller.playlistView.value
                    ? visualization()
                    : playListView(),
          );
        }),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        controller.playlistView(true);
                      },
                      icon: Icon(
                        Icons.playlist_play,
                        color: Colors.white,
                      )),
                  Obx(() {
                    MediaItem data = controller
                        .playlist.sequence[controller.playIndex.value].tag;
                    return AutoSizeText(
                      data.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.blue, fontSize: 20),
                    );
                  }),
                  IconButton(
                      onPressed: () {
                        controller.playlistView(false);
                      },
                      icon: Icon(
                        Icons.art_track_sharp,
                        color: Colors.white,
                      )),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget progress() {
    return Container(
      width: width,
      child: Obx((() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              controller.position.value,
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            Container(
              width: 250.0,
              child: Slider.adaptive(
                  activeColor: Colors.blue[800],
                  inactiveColor: Color.fromARGB(255, 73, 36, 36),
                  value: controller.slider_value.value,
                  max: controller.slider_Max.value,
                  min: Duration(seconds: 0).inSeconds.toDouble(),
                  onChanged: (value) {
                    controller.changeDurationToSeconds(value.toInt());
                  }),
            ),
            Text(
              controller.duration.value,
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ],
        );
      })),
    );
  }

  playerButtons() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: MyDecorations.gradiant,
      height: 100,
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
                onPressed: () {
                  if (controller.player.hasPrevious) {
                    controller.player.seekToPrevious;
                    controller.playIndex(controller.playIndex.value - 1);
                    controller.play(controller.playIndex.value);
                  }
                },
                icon: const Icon(
                  Icons.skip_previous_sharp,
                  size: 50,
                )),
            /**************************Play / Puse ******************************* */
            StreamBuilder<PlayerState>(
                stream: controller.player.playerStateStream,
                builder: (context, snapshot) {
                  var state = snapshot.data!;
                  if (state.processingState == ProcessingState.buffering) {
                    return CircularProgressIndicator(color: Colors.yellow,);
                  } else {if (state.processingState == ProcessingState.loading) {
                    return CircularProgressIndicator(color: Colors.red,);
                  }
                    return IconButton(
                        onPressed: () {
                          /*  */
                          if (controller.isPlaying.value == true) {
                            controller.pusePlay();
                            controller.isPlaying(false);
                            controller.inPuse(true);
                          } else {
                            controller.isPlaying.value = true;
                            controller.play(controller.playIndex.value);
                          }
                        },
                        icon: controller.isPlaying.value
                            ? const Icon(
                                Icons.play_circle_rounded,
                                color: Color.fromARGB(255, 114, 11, 134),
                                size: 50,
                              )
                            : const Icon(
                                Icons.pause_circle_rounded,
                                size: 50,
                                color: Color.fromARGB(255, 10, 22, 189),
                              ));
                  }
                }),
            IconButton(
                onPressed: () {
                  if (controller.player.hasNext) {
                    controller.player.seekToNext;
                    controller.playIndex.value = controller.playIndex.value + 1;
                    controller.playIndex(controller.playIndex.value);
                    controller.play(controller.playIndex.value);
                    controller.update();
                    print(
                        '----${controller.playIndex.value}--------->>> ${controller.playlist.sequence[controller.playIndex.value].tag.toString()}');
                  }
                  ;
                },
                icon: const Icon(
                  Icons.skip_next_sharp,
                  size: 50,
                )),
            IconButton(
                onPressed: () {
                  controller.loop.value = !controller.loop.value;
                  !controller.loop.value
                      ? controller.player.setLoopMode(LoopMode.all)
                      : controller.player.setLoopMode(LoopMode.one);
                  ;
                },
                icon: Icon(
                  controller.loop.value ? Icons.loop_rounded : Icons.repeat_on,
                  size: 50,
                )),
            IconButton(
                onPressed: () {
                  controller.shuffle.value = !controller.shuffle.value;
                  if (!controller.shuffle.value) {
                    controller.player.shuffle();
                    controller.player.setShuffleModeEnabled(true);
                  } else {
                    controller.player.setShuffleModeEnabled(false);
                  }
                  ;
                },
                icon: !controller.shuffle.value
                    ? Icon(
                        Icons.shuffle_rounded,
                        size: 50,
                        // color: Colors.blue,
                      )
                    : Icon(
                        Icons.shuffle,
                        size: 50,
                        color: Colors.grey,
                      )),
            IconButton(
                onPressed: () {
                  //   setState(() {});
                  controller.stopPlay();
                },
                icon: const Icon(
                  Icons.stop_circle_sharp,
                  size: 50,
                )),
          ],
        );
      }),
    );
  }
}
