import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

class AllAlboumsForSelectedSonger extends GetView<PlayerController> {
  List<ItemData> data = [];
  List<ItemData> singer = [];
  List<ItemData> inputData = [];
  double width = 0;
  adjustData() {
    if (DataProvider.pageID == PagesID.Singers) {
      //  inputData = DataProvider.allSongersData;
      inputData = controller.getItemDataFromGetxBox('allSongersData');
    } else {
      inputData = controller.getItemDataFromGetxBox('archiveOrg');
      //  inputData = DataProvider.archiveOrg;
    }
    Set<String> alboumnames = {};
    singer = [];
    singer = List.from(
        inputData.where((s) => s.songerName == DataProvider.singerName));
    singer.forEach((element) {
      alboumnames.add(element.alboumName);
    });

    alboumnames.forEach((alboum) {
      data.add(singer.firstWhere((item) => alboum.contains(item.alboumName)));
    });
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    adjustData();
    //  DataProvider.screenNameForViewDownLoad = 'SongerAlboums';
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 16, 12, 12),
      body: cardList(),
      // bodyStraem(),
      bottomSheet: Container(
        color: Colors.grey,
        child: Row(
          children: [
            TextButton.icon(
              onPressed: () {
                DataProvider.fromUrl = true;
                DataProvider.alboum = List.from(inputData
                    .where((s) => s.songerName == DataProvider.singerName));
                DataProvider.alboum.toSet().toList();
                controller.setItemDataToGetxBox(DataProvider.alboum, 'alboum');
                {
                  if (kDebugMode == false)
                    controller.adhelper.showInterstitialAd();
                }
                controller.alboum.value = DataProvider.alboum;
                controller.playIndex(0);
                controller.fromurl(true);
                Get.to(() => MusicList(),
                        transition: Transition.circularReveal)!
                    .then((value) {
                  if (kDebugMode == false)
                    controller.adhelper.showInterstitialAd();
                });
              },
              icon: Icon(Icons.all_inbox),
              label: Card(
                child: Text('View All'),
              ),
            ),
            TextButton.icon(
              onPressed: () {
                ItemData item =
                    data.firstWhere((s) => s.name == DataProvider.singerName);
                controller.dbHelper.intDB().then((value) => controller.dbHelper
                    .addDataToTable(item, TablesId.fav_singers)
                    .then((value) => Get.snackbar('Adding to favourites',
                        'Singer Had been added to favourites')));
                ;
              },
              icon: Icon(Icons.favorite),
              label: Card(
                child: Text('Add to Favourits'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cardList() {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: ((context, index) {
          return Container(
            child: Column(
              children: [
              /*   index % 2 == 0 && kDebugMode == false
                    ? controller.inbanner()
                    : Container(), */
                Container(
                    //  padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      /* image: DecorationImage(
                          image: AssetImage('assets/MEDIA/4.jpg'),
                          fit: BoxFit.fill,
                          filterQuality: FilterQuality.high), */
                      color: Color.fromARGB(194, 9, 13, 21),
                      border: Border.all(
                        width: 3,
                        color: Color.fromARGB(255, 155, 156, 150),
                      ),
                      borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromARGB(255, 101, 102, 98),
                          offset: Offset(10, 20),
                          blurRadius: 30,
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () async {
                        /*    DataProvider.alboumName = data[index].name;
                        DataProvider.alboumUrl = data[index].url;
                        DataProvider.subCategoryName = data[index].name;
                        DataProvider.screenNameForViewDownLoad =
                            'SongerAlboums'; */
                        DataProvider.fromUrl = true;
                        DataProvider.alboum = List.from(singer.where(
                            (s) => s.alboumName == data[index].alboumName));
                        DataProvider.alboum.toSet().toList();
                        controller.setItemDataToGetxBox(
                            DataProvider.alboum, 'alboum');
                        print(
                            '    ${data[index].alboumName} has ${DataProvider.alboum.length}   all singer data= ${singer.length}');
                        {
                          if (kDebugMode == false)
                            controller.adhelper.showInterstitialAd();
                        }
                        controller.alboum.value = DataProvider.alboum;
                        controller.playIndex(index);
                        controller.fromurl(true);
                        Get.to(() => MusicList(),
                                transition: Transition.circularReveal)!
                            .then((value) {
                          if (kDebugMode == false)
                            controller.adhelper.showInterstitialAd();
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          data[index].imageUrl.contains('http')
                              ? Image.network(
                                  data[index].imageUrl,
                                  width: 80,
                                  height: 80,
                                )
                              : Container(),
                          DataProvider.pageID == PagesID.ArchiveOrg
                              ? Container(
                                  height: 200,
                                  width: width - 100,
                                  child: Center(
                                    child: Text(
                                      data[index].alboumName,
                                      textAlign: TextAlign.center,
                                      maxLines: 10,
                                      overflow: TextOverflow.ellipsis,
                                      //   softWrap: true,
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 20),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: AutoSizeText(
                                    data[index].alboumName,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:
                                            Color.fromARGB(255, 245, 245, 243)),
                                  ),
                                ),
                        ],
                      ),
                    )),
              ],
            ),
          );
        }));
  }
}
