import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/Scraping/MrMazikaScrapping.dart';
import 'package:Khotab_Encyclopedia/Scraping/ScrappingMP3Songes_Site.dart';
import 'package:Khotab_Encyclopedia/Scraping/AudioBooksScrapping.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/IsalmicScrapping.dart';

import 'package:permission_handler/permission_handler.dart';



class FoldersConroller {
  String downlodingpath =
      '/data/user/0/com.M2yDevilopers.Oldmusic_Encyclopedia/app_flutter/Downloads/';

  // String downlodingpath = '';
  Future<String> createDownloadFolder() async {
    // Directory? created = await getExternalStorageDirectory();
    // Directory? created = await DownloadsPathProvider.downloadsDirectory;
    Directory created = Directory('/storage/emulated/0/Download');
    final Directory appDocDirFolder = Directory('${created.path}/smany/');

    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      try {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
          //add more permission to request here.
        ].request();
        if (statuses[Permission.storage]!.isGranted) {
          final Directory appDocDirNewFolder =
              await appDocDirFolder.create(recursive: true);
          created = appDocDirNewFolder;
        }
      } catch (e) {
        print('Error from creating download Folder$e');
      }
      return created.path;
    }
  }

  Future<String> creatNewFolder(String folderName) async {
    downlodingpath = await createDownloadFolder();
    Directory created = await Directory(downlodingpath);
    // await getApplicationDocumentsDirectory();
    final Directory appDocDirFolder =
        Directory('${downlodingpath}${folderName}/');
    if (await appDocDirFolder.exists()) {
      return appDocDirFolder.path;
    } else {
      try {
        final Directory appDocDirNewFolder =
            await appDocDirFolder.create(recursive: true);
        created = appDocDirNewFolder;
      } catch (e) {
        print(e);
      }
      return created.path;
    }
  }

  Future<List<FileSystemEntity>> getDirData() async {
    late List<FileSystemEntity> folders;
    final myDir = Directory(await createDownloadFolder());
    folders = await myDir.listSync(recursive: true, followLinks: false);
    return folders;
  }

  Future<List<FileSystemEntity>> getDirList() async {
    late List<FileSystemEntity> output = [];
    final myDir = new Directory(await createDownloadFolder());
    List<FileSystemEntity> folders =
        await myDir.listSync(recursive: true, followLinks: false);
    output.clear();
    for (var element in folders) {
      // FileStat f = await element.stat(); // as FileStat;
      output.add(element);
      output.removeWhere((folder) => folder.path.contains('.mp3'));
    }
    return output;
  }

  Future<List<ItemData>> getDirFilesList(String alboumFolder) async {
    downlodingpath = await createDownloadFolder();
    List<ItemData> list = [];
    String DownloadDir = '$downlodingpath/';
    final myDir = new Directory(DownloadDir);
    List<FileSystemEntity> folders =
        await myDir.listSync(recursive: true, followLinks: false);

    folders.forEach((element) async {
      ItemData temp = ItemData();
      temp.name = element.path.split('/').last.replaceAll('.MP3', '');
      temp.songUrl = element.path;
      temp.songMP3Url = element.path;
      temp.imageUrl = '';
      temp.url = '';
      list.add(temp);
    });
    /*  print(
        "Output Alboum List from $alboumFolder ===> ${list.length} and main data are ${folders.length}"); */
    DataProvider.alboum = list;
    return list;
  }

  Future<String> downloadfile() async {
    tostView('Start Downloading ');
    await createDownloadFolder();
    DataProvider.downloadprocess = 1;
    ItemData data = DataProvider.currentsong;
    // print('data.ur = ${data.url}  data.songMP3Url= ${data.songMP3Url}');
    if (data.songMP3Url.isEmpty) data.songMP3Url = data.url;
    Uri url = Uri.parse(data.songMP3Url);
    String filename = data.name.replaceAll(' ', '_').trim();
    String foldername = DataProvider.subCategoryName.trim();
    if (foldername.isEmpty) foldername = 'NewFiles';
    String? dir = await creatNewFolder(foldername);
    dir = dir.toString().replaceAll('.mp3', '').replaceAll('.MP3', '');
    String categoryFolder = DataProvider.mainCategoryName;
    File file = new File('$dir$filename.mp3');
    print(file.path);
    var request = await http.get(
      url,
    );
    var bytes = await request.bodyBytes; //close();
    try {
      await file.writeAsBytes(bytes);
      print(file.path);
      DataProvider.downloadprocess = 2;
      tostView('DownLoad has been Done ');
    } catch (e) {
      DataProvider.downloadprocess = 3;
      tostView('DownLoad  Error \n $e ');
    }
    return file.path;
  }

  deleteFileinFolder(List<FileSystemEntity> folders, int index) async {
    await folders[index].delete();
  }

  tostView(String title) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  /********************************* */

  saveToPC(String tablename, List<ItemData> data) async {
    String dir =
        'F:/my_progarmming_study/flutter_projects/working_Projects/music_Encyclopedia/assets/';
    List<String> output = [];
    data.forEach((element) {
      String jsonline = element.toJson();
      output.add(jsonline);
    });
    File file = new File('$dir$tablename.json');
    print(file.path);
    try {
      await file.writeAsString(output.toString());
      print(file.path);
      DataProvider.downloadprocess = 2;
      print('DownLoad  Done ');
    } catch (e) {
      DataProvider.downloadprocess = 3;
      print('DownLoad  Error \n $e ');
    }
  }

  Future<List<ItemData>> collectSubData(
      String tablename, List<ItemData> data) async {
    List<ItemData> output = [];
    List<ItemData> temp = [];
    for (ItemData element in data) {
      switch (tablename) {
        case 'AllAnashed':
          temp = await Sacrapper.getAnashedList(element.url);
          break;
        case 'AllsounBooks':
          temp = await AudioBooks.getDownloadUrlPath(element.url);
          break;
        case 'Alllectcures':
          temp = await IslamicTapeSacrapper.getKhotabList(element.url);
          break;
        default:
      }
      for (ItemData subelement in temp) {
        subelement.songerName = element.name;
        if (element.imageUrl.isNotEmpty) subelement.imageUrl = element.imageUrl;
        output.add(subelement);
      }
    }
    print(output.length);
    return output;
  }

  Future<List<ItemData>> songersSubData() async {
    List<ItemData> output = [];
    DataProvider.allSongers.forEach((singer) async {
      String singerName = singer.name;
      String singerUri = singer.url;
      await MrMazikkaScrapping.allAlboumsForSelectedSongerFuture(singerUri)
          .then((alboums) {
        alboums.forEach((alboum) async {
          String alboumName = alboum.name;
          await MrMazikkaScrapping.getAlboumSongesListFuture(alboum.url)
              .then((song) {
            song.forEach((element) {
              element.alboumName = alboumName;
              element.songerName = singerName;
              output.add(element);
            });
          });
        });
      });
    });
    return output;
  }

  getDatafromJson() async {
    String data = await rootBundle.loadString('assets/anasheed.json');
    print(data.length);
  }
}
