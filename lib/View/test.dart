

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

import '../Controllers/DataProvider.dart';
import '../Controllers/playercontroller.dart';
import '../DataModel/Tables.dart';
import '../MP3Player/MusicList.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final controller=Get.put(PlayerController(),permanent :true);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: test(),
    );
  }
  Widget test(){
 if(DataProvider.ranati.isEmpty) {
  return FutureBuilder<List<ItemData>>(
    future: controller.ranati(),
    builder: (_,snap){
  if (snap.hasData) {
  List<String> item=controller.rantiAlbums.toList();
  return ListView.builder(
    itemCount: controller.rantiAlbums.length,
    itemBuilder: (BuildContext context, int index) {
      return InkWell(
        onTap: (){
          List<ItemData> songes=List.from(DataProvider.ranati.where((element) => element.alboumName==item[index]));
         print(songes.toString());
          action(songes,1);
        },
        child: Text(item[index]));
    },
  );
  } else {
  return Center(child: CircularProgressIndicator(),);
  }
  });}else{
   List<String> item=controller.rantiAlbums.toList();
  return ListView.builder(
    itemCount: controller.rantiAlbums.length,
    itemBuilder: (BuildContext context, int index) {
      return InkWell(
        onTap: (){
          List<ItemData> songes=List.from(DataProvider.ranati.where((element) => element.alboumName==item[index]));
         print(songes.toString());
          action(songes,1);
        },
        child: Text(item[index],textAlign: TextAlign.center,style: TextStyle(color:Colors.green)));
    },);
  }
}

action(List<ItemData> itemData, int index){
        DataProvider.alboumName = itemData[index].name;
        DataProvider.alboumUrl = itemData[index].url;
        // DataProvider.alboum.clear();
        DataProvider.alboum = itemData;
        controller.setItemDataToGetxBox(DataProvider.alboum, 'alboum');
        controller.alboum.value = itemData;
        controller.playIndex(index);
        DataProvider.subCategoryName = "المفضلة";
        controller.fromurl(true);
        Get.to(() => MusicList())!.then((value) {
          if (kDebugMode == false) controller.adhelper.showInterstitialAd();
        });

}
}