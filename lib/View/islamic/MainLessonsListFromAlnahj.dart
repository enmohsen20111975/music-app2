import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/IsalmicScrapping.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';

class LessonListView extends StatefulWidget {
  const LessonListView({super.key});
  static const route = 'LessonListView';
  @override
  State<LessonListView> createState() => _LessonListViewState();
}

class _LessonListViewState extends State<LessonListView> {
  // IslamicTapeSacrapper scrapper = IslamicTapeSacrapper();

  AudioPlayer audioPlayer = AudioPlayer();
  double currentposition = 0;
  Duration position = const Duration();
  Duration musicLength = const Duration();
  late Stream<List<ItemData>> strem;
  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/MEDIA/r4.jpg'),
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill),
        ),
        child: streambody());
  }

  Widget streambody() {
    IslamicTapeSacrapper.getFromAlnahjLssonsDataStream(
        DataProvider.mainCategoryUrl, DataProvider.subCategoryUrl);
    return StreamBuilder<List<ItemData>>(
      stream: IslamicTapeSacrapper.controller.stream,
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: ((context, index) {
              return TextButton.icon(
                onPressed: (() async {
                  DataProvider.subCategoryUrl = index.toString();
                  DataProvider.mainCategoryName = snapshot.data![index].name;
                  String title =
                      'يرجي الإنظار لحين ترتيب الدروس  \nو الوقت حسب كمية الدروس فيرجي لاإنتظار' +
                          DataProvider.numberOfLessons.toString() +
                          'عدد الدروس هو ';
                  tostView(title);
                }),
                icon: Icon(Icons.book),
                label: Container(
                  color: Colors.white,
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      cardView(snapshot.data![index].name),
                      mp3Player(snapshot.data![index])
                    ],
                  ),
                ),
              );
            }),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }),
    );
  }

  Widget cardView(String title) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      shadowColor: Colors.blueAccent,
      elevation: 15,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: Colors.red, width: 15)),
            color: Color.fromARGB(255, 151, 27, 223),
          ),
          padding: EdgeInsets.all(2.0),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Color.fromARGB(255, 248, 248, 248), fontSize: 20),
          ),
        ),
      ),
    );
  }

  tostView(String title) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 2,
        backgroundColor: Color.fromARGB(255, 136, 11, 194),
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget mp3Player(ItemData data) {
    // PlayerControllers.audioPlayer = audioPlayer;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () async {
              tostView('Strat Downloading ');
              //  await PlayerControllers.downloadMP3();
            },
            icon: Icon(Icons.download)),
        IconButton(
          icon: Icon(Icons.play_arrow),
          iconSize: 64.0,
          onPressed: () async {
            Duration? duration =
                await audioPlayer.setUrl(data.url).then((value) async {
              await audioPlayer.play();
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.pause),
          iconSize: 64.0,
          onPressed: () async {
            await audioPlayer.pause();
          },
        ),
        IconButton(
          icon: Icon(Icons.stop),
          iconSize: 64.0,
          onPressed: () async {
            await audioPlayer.stop();
          },
        )
        // Play/pause/restart
        /*  StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (_, snapshot) {
            final playerState = snapshot.data;
            return PlayerControllers.playPauseButton(playerState!);
          },
        ), */
      ],
    );
  }
/*
  Widget progress() {
    musicLength = DataProvider.mp3lenght;
    return Container(
        width: 500.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${position.inMinutes}:${position.inSeconds.remainder(60)}",
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
            slider(),
            Text(
              "${musicLength.inMinutes}:${musicLength.inSeconds.remainder(60)}",
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ));
  }

  Widget slider() {
    return Container(
      width: 300.0,
      child: Slider.adaptive(
          activeColor: Colors.blue[800],
          inactiveColor: Colors.grey[350],
          value: currentposition,
          max: DataProvider.mp3lenght.inSeconds.toDouble(),
          onChanged: (value) {
            audioPlayer.seek(Duration(seconds: value.toInt()));
          }),
    );
  }
 */
}
