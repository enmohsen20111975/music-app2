import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/globalData.dart';
import 'package:Khotab_Encyclopedia/View/WaitloadingData.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ArchiveViewData extends GetView<PlayerController> {
  double width = 0;
  double height = 0;
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    DataProvider.screenNameForViewDownLoad = 'SelectedCources';
    return Scaffold(
      extendBody: true,
      body: SingleChildScrollView(child: body()),
    );
  }

  Widget body() {
    return Container(
      width: width,
      height: height - 50,
      decoration: BoxDecoration(
        image: DecorationImage(
            image:
                AssetImage('assets/images/${DataProvider.globalcoursesID}.jpg'),
            filterQuality: FilterQuality.high,
            fit: BoxFit.fill),
      ),
      child: Obx(() {
        return ListView.builder(
            itemCount: controller.dataView.length,
            itemBuilder: ((context, index) {
              return TextButton(
                onPressed: () {
                  int i = 0;
                  GlobalData.selectedLessonMap.forEach((element) {
                    if (element['name'] == controller.dataView[index]['name']) {
                      DataProvider.selectedCourceId = i;
                    }
                    i++;
                  });
                  DataProvider.subCategoryName =
                      controller.dataView[index]['name'];
                  // data.clear();
                  controller.adhelper.showInterstitialAd();
                  Navigator.pushNamed(context, WaitloadingData.route);
                },
                child: Column(
                  children: [
                 /*    index % 4 == 0 ? controller.inbanner() : Container(), */
                    cardView(
                        controller.dataView[index]['name'],
                        ItemData.itemDataAdding(
                          name: controller.dataView[index]['name'],
                          imageUrl:
                              'assets/images/${DataProvider.globalcoursesID}.jpg',
                        )),
                  ],
                ),
              );
            }));
      }),
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
                left: BorderSide(
                    color: Color.fromARGB(255, 6, 172, 42), width: 15)),
            color: Color.fromARGB(85, 35, 36, 37),
          ),
          padding: EdgeInsets.all(12.0),
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                flex: 10,
                child: AutoSizeText(
                  maxLines: 10,
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color.fromARGB(255, 252, 251, 251), fontSize: 20),
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
