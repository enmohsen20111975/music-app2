import 'dart:async';
import 'dart:io';

import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';
import 'package:Khotab_Encyclopedia/View/ViewTools/Buttons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/Decorations/containerDecorations.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/FolderController.dart';
import 'package:ringtone_set/ringtone_set.dart';
import 'package:share/share.dart';

class ViewDownLoadedFiles extends GetView<PlayerController> {
  static const route = 'ViewDownLoadedFiles';
  FoldersConroller foldersConroller = FoldersConroller();
  List<FileSystemEntity> dirs = [];
  int folderID = 0;
  String title = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 6, 87, 153),
        /*  appBar: AppBar(
          title: Text('Downloades '),
          centerTitle: true,
        ),
        drawer: viewFolders(), */
        body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/MEDIA/4.jpg'),
                      fit: BoxFit.fill,
                      filterQuality: FilterQuality.high)),
              child: body()),
        ));
  }

  Widget body() {
    return FutureBuilder<List<FileSystemEntity>>(
      future: foldersConroller.getDirList(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dirs = snapshot.data!;
          /*  return viewFolders(); */
          title = snapshot.data![folderID].path.split('/').last;
          Timer(Duration(microseconds: 10), (() {}));
          return filesView(title);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget viewFolders() {
    if (dirs.isNotEmpty) {
      return Drawer(
        // shape: ,
        backgroundColor: Color.fromARGB(255, 5, 59, 131),
        child: ListView.builder(
            itemCount: dirs.length,
            itemBuilder: ((context, index) {
              String alboumname = dirs[index].path.split('/').last;
              final myDir = new Directory(dirs[index].path);
              List<FileSystemEntity> files =
                  myDir.listSync(recursive: true, followLinks: false);
              return Column(
                children: [
                 /*  index % 4 == 0 && !kDebugMode
                      ? controller.inbanner()
                      : Container(
                          height: 1,
                        ), */
                  InkWell(
                    onTap: (() async {
                      folderID = index;

                      Navigator.pop(context);
                    }),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.folder,
                          color: Colors.yellow,
                        ),
                        card(dirs[index].path.split('/').last),
                        CircleAvatar(
                            child: AutoSizeText(files.length.toString())),
                        IconButton(
                            onPressed: () {
                              folderToPlayList(alboumname);
                            },
                            icon: Icon(Icons.play_circle_fill_sharp))
                      ],
                    ),
                  ),
                ],
              );
            })),
      );
    } else {
      // getdirdata();
      return Center(
        child: Card(
          child: Text('Nothing had been downloaded'),
        ),
      );
    }
  }

  Widget filesView(String alboumname) {
    return FutureBuilder<List<ItemData>>(
        future: foldersConroller.getDirFilesList(alboumname),
        builder: ((context, snapshot) {
          controller.alboum.clear();
          snapshot.data!.forEach((element) {
            controller.alboum.add(element);
          });

          controller.buildPlayList();
          if (snapshot.hasData) {
            return Center(
              child: ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return Center(
                      child: Container(
                        decoration: MyDecorations.gradiant,
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: ListTile(
                          textColor: Color.fromARGB(255, 11, 13, 139),
                          iconColor: Color.fromARGB(255, 37, 92, 6),
                          shape: BeveledRectangleBorder(
                            side: BorderSide(
                                width: 2,
                                color: Color.fromARGB(255, 2, 20, 36)),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          title: AutoSizeText(snapshot.data![index].name),
                          leading: Icon(Icons.music_note),
                          subtitle: bottums(snapshot.data![index]),
                          onTap: () {
                            controller.inPuse(false);
                            controller
                                .playIndex(index); // set current songe index
                            controller.play(index);
                            controller.fromurl(false);
                            Get.to(PlayerScreen());
                            if (kDebugMode == false)
                              controller.adhelper.showInterstitialAd();
                          },
                        ),
                      ),
                    );
                  })),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }

  folderToPlayList(String alboumname) async {
    DataProvider.fromUrl = false;
    if (kDebugMode == false) {
      controller.adhelper.showInterstitialAd();
    }
    await foldersConroller.getDirFilesList(alboumname).then((value) {
      /******************************** */
      DataProvider.alboum = value;
      controller.alboum.value = DataProvider.alboum;
      controller.fromurl(false);
      controller.playIndex(0);
      print('List of value in $alboumname Folder= ${value.length}');
      Get.to(MusicList());

      ;
    });
  }

  Widget bottums(ItemData snapshot) {
    return Buttons(snapshot, 0, true);
  }

  Widget card(String txt) {
    return SizedBox(
      width: 180,
      child: Card(
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
            child: AutoSizeText(
              stepGranularity: 2,
              wrapWords: false,
              txt,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromARGB(255, 248, 248, 248), fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
