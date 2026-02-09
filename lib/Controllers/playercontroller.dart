import 'package:Khotab_Encyclopedia/Controllers/APIController.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/googlesheet.dart';
import 'package:Khotab_Encyclopedia/Controllers/perminantdata.dart';
import 'package:Khotab_Encyclopedia/DataBase/DataBaseHelper.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/MP3Player/BackGroundPlayer.dart';
import 'package:Khotab_Encyclopedia/googleADs/adhelper.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
//import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayerController extends GetxController {
  final player = AudioPlayer();
  final dbHelper = DbHelper();
  final adhelper = GooGleAdmobhelper();
 final myAPI = APIController();
 Set<String> rantiCategory={};
 Set<String> rantiAlbums={};
   //final myAPI = GoogleSheetsAPI(); 
  // final audioQuery = OnAudioQuery();
  RxList alboum = <ItemData>[].obs;
/*===========================================*/
  var box = GetStorage();
  final fData = Get.put(PerminantData());
  var playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );
  RxBool loop = false.obs;
  RxBool shuffle = false.obs;
  RxBool playlistView = false.obs;
  /************************* */
  RxList dataView = [].obs;
  RxList allSongers = <ItemData>[].obs;
  RxList asingerAlboums = <ItemData>[].obs;
  RxList allSongersData = <ItemData>[].obs;
  RxList lastsonges = <ItemData>[].obs;
  RxList anasheed = <ItemData>[].obs;
  RxList shabyatSonges = <ItemData>[].obs;
  RxList sounBooks = <ItemData>[].obs;
  RxList lectcures = <ItemData>[].obs;
  RxList archiveOrg = <ItemData>[].obs;
  RxList rap = <ItemData>[].obs;
  RxList englishSonges = <ItemData>[].obs;
  RxList trend = <ItemData>[].obs;
  RxList mostView = <ItemData>[].obs;
  RxList favouriteSonges = <ItemData>[].obs;
  RxList favouriteSingers = <ItemData>[].obs;
  /************************* */

  RxInt playIndex = 0.obs;
  var isPlaying = false.obs;
  var duration = ''.obs;
  var position = ''.obs;
  RxDouble slider_Max = 0.0.obs;
  RxDouble slider_value = 0.0.obs;
  RxBool viewListScreen = false.obs;
  var fromurl = true.obs;
  var inPuse = false.obs;
  var onlineUpDate = false.obs;
  var mp3IsCompleted = false.obs;
  RxDouble remin = 0.0.obs;
  var remDuration = ''.obs;
  var item;
  @override
  Future<void> onInit() async {
    super.onInit();
    dbHelper.intDB();
    checkForPermission();

    // spref = await SharedPreferences.getInstance();
    adhelper.createInterstitialAd();
  }

  Future<List<ItemData>> get shabyatAPI async => await myAPI.shabyatAPI();
  Future<List<ItemData>> get lastsongesAPI async =>
      await myAPI.loadlastsongesAPI();
  Future<List<ItemData>> get allSongersDataAPI async =>
      await myAPI.loadlAllSongiersDataAPI();
  Future<List<ItemData>> get anasheedAPI async =>
      await myAPI.loadlAllAnasheedDataAPI();
  Future<List<ItemData>> get lecturesAPI async =>
      await myAPI.loadlAlllectcuresDataAPI();
  Future<List<ItemData>> get sounBooksAPI async =>
      await myAPI.loadlAllsounBooksDataAPI();
 /*  Future<List<ItemData>> get archiveOrgAPI async =>
      await myAPI.loadlArchiveOrgDataAPI(); */
     
Future<List<ItemData>>  getData(TablesId tablename) async {
  switch (tablename) {
    case TablesId.shabyat:
      return await myAPI.shabyatAPI();
      case TablesId.lastsonges:
      return await myAPI.loadlastsongesAPI();
      case TablesId.allSongers:
      return await myAPI.loadlAllSongiersDataAPI();
      case TablesId.anasheed:
      return await myAPI.loadlAllAnasheedDataAPI();
      case TablesId.lectcures:
      return await myAPI.loadlAlllectcuresDataAPI();
      case TablesId.AllsounBooks:
      return await myAPI.loadlAllsounBooksDataAPI();
      case TablesId.Alllectcures:
      return await myAPI.loadlArchiveOrgDataAPI();
      default:return[];
            }
     }
  buildPlayList() {
    fData.buildPlayList(alboum.value.cast(), fromurl.value);
    playlist = fData.playlist;
    print(playlist.toString());
  }

Future<List<ItemData>> ranati() async {
  List<ItemData> temp=[];List<String> cati=[],albumi=[];
await  dbHelper.getRanatiData().then((data) {
  temp=data;
    for (var element in data) {
      cati.add(element.Category);
      albumi.add(element.alboumName);
      }
  });
  cati=cati.toSet().toList();
  albumi=albumi.toSet().toList();
  rantiCategory=cati.toSet();rantiAlbums=albumi.toSet();
  print('${cati.toString()} , ${albumi.toString()} from data of ${temp.length}');
return temp;
}


  setItemDataToGetxBox(List<ItemData> data, String name) {
    box.write('$name', data.map((item) => item.toMap()).toList());
  }

  List<ItemData> getItemDataFromGetxBox(String name) {
    Set<ItemData> data = {};
    final dataList = box.read<List>('$name') ?? [];
    data.assignAll(dataList.map((item) => ItemData.itemDataAdding(
          Category: item['Category'],
          Class: item['Class'],
          savedIndex: item['savedIndex'],
          alboumName: item['alboumName'],
          songerName: item['songerName'],
          name: item['name'],
          songUrl: item['songUrl'],
          songMP3Url: item['songMP3Url'],
          imageUrl: item['imageUrl'],
          url: item['url'],
        )));
    print('All data have been wrote are ${data.length}');
    return data.toList();
  }

  /* Widget inbanner() {
    final Container cont = Container(
      child: AdWidget(
        ad: GooGleAdmobhelper.getBunnerAD()..load(),
        key: UniqueKey(),
      ),
      height: 50,
    );
    return cont;
  } */

  changeDurationToSeconds(second) {
    var duartion = Duration(seconds: second);
    player.seek(duartion);
  }

  updatePosition() {
    try {
      player.durationStream.listen((d) {
        duration.value = d.toString().split('.')[0];
        slider_Max.value = d!.inSeconds.toDouble();
      });
      player.positionStream.listen((d) {
        position.value = d.toString().split('.')[0];
        slider_value.value = d.inSeconds.toDouble();
        remin(slider_Max.value - slider_value.value);
        remDuration.value = remin.toString().split('.')[0];
      });

      player.sequenceStateStream.listen((state) {
        playIndex.value = state!.currentIndex;
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  play(int index) async {
    playIndex(index);
    update();
    updatePosition();
    await player.setAudioSource(playlist,
        initialIndex: playIndex.value, initialPosition: Duration.zero);
    player.play();

    print(
        ' index===>> $index  player.currentIndex  ----->>> ${player.currentIndex} playIndex===>${playIndex.value}');
  }

  checkForPermission() async {
    var perm = await Permission.storage.request();
    if (perm.isGranted) {
    } else {
      checkForPermission();
    }
  }

  stopPlay() {
    player.stop();
    isPlaying(false);
  }

  pusePlay() {
    player.pause();
    isPlaying(false);
  }

  playSongFromURI(String? uri, index) {
    playIndex.value = index;
    /*  player.setSkipSilenceEnabled(true);
    player.setCanUseNetworkResourcesForLiveStreamingWhilePaused(true); */
    try {
      if (inPuse.value == true) {
        player.play();
      } else {
        player.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
      }
      isPlaying(true);
      updatePosition();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }

  playSongFromFile(String? filePath, index) {
    playIndex.value = index;
    player.setSkipSilenceEnabled(true);
    try {
      if (inPuse.value == true) {
        player.play();
      } else {
        player.setAudioSource(AudioSource.file(filePath!));
        player.play();
      }
      isPlaying(true);
      updatePosition();
    } on Exception catch (e) {
      debugPrint(e.toString());
    }
  }
}
