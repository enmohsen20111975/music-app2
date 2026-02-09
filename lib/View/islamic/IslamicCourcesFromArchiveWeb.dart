import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/FolderController.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/globalData.dart';
import 'package:Khotab_Encyclopedia/View/WaitloadingData.dart';

class SelectedCources2 extends GetView<PlayerController> {
  SelectedCources2(this.selected, this.playIndex, this.dataView);
  String selected;
  int playIndex;
  List<Map<String, dynamic>> dataView;

  FoldersConroller foldersController = FoldersConroller();

  @override
  Widget build(BuildContext context) {
    DataProvider.screenNameForViewDownLoad = 'SelectedCources';
    return Scaffold(
      extendBody: true,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: DataProvider.globalcoursesID == 0
                  ? AssetImage('assets/images/1.jpg')
                  : AssetImage(
                      'assets/images/${DataProvider.globalcoursesID}.jpg'),
              filterQuality: FilterQuality.high,
              fit: BoxFit.fill),
        ),
        child: ListView.builder(
            itemCount: dataView.length,
            itemBuilder: ((context, index) {
              return TextButton(
                onPressed: () {
                  int i = 0;
                  GlobalData.selectedLessonMap.forEach((element) {
                    if (element['name'].toString().trim() ==
                        dataView[index]['name'].toString().trim()) {
                      DataProvider.selectedCourceId = i;
                    }
                    i++;
                  });
                  DataProvider.subCategoryName =
                      dataView[index]['name'].toString();

                  if (!kDebugMode) {
                    controller.adhelper.showInterstitialAd();
                  }
                  Get.to(() => WaitloadingData());
                },
                child: Column(
                  children: [
                 /*    index % 4 == 0 ? controller.inbanner() : Container(), */
                    FadeInLeft(
                      child: cardView(dataView[index]['name'],
                          ItemData.fromMap(dataView[index])),
                    ),
                  ],
                ),
              );
            })),
      ),
    );
  }

  Widget cardView(String title, ItemData item) {
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      shadowColor: Color.fromARGB(255, 47, 175, 22),
      elevation: 15,
      child: ClipPath(
        clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        child: Container(
          //  height: 40,
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    color: Color.fromARGB(255, 6, 172, 42), width: 15)),
            color: Color.fromARGB(85, 35, 36, 37),
          ),
          padding: EdgeInsets.all(12.0),
          alignment: Alignment.center,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: AutoSizeText(
                  maxLines: 10,
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 252, 251, 251), fontSize: 15),
                ),
              ),
              Expanded(flex: 4, child: playerButtons(item)),
            ],
          ),
        ),
      ),
    );
  }

  playerButtons(ItemData item) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              Get.snackbar('Adding to Favourits', item.name);
              controller.dbHelper.addDataToTable(item, TablesId.fav_singers);
              Get.snackbar('Added to Favorits', item.name,
                  snackPosition: SnackPosition.TOP, colorText: Colors.red);
            },
            icon: Icon(
              Icons.favorite,
              color: Color.fromARGB(255, 0, 12, 6),
            )),
      ],
    );
  }
}
