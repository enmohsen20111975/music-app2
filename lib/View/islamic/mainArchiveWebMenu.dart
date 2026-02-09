import 'package:animate_do/animate_do.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/globalData.dart';
import 'package:Khotab_Encyclopedia/View/WaitloadingData.dart';
import 'package:Khotab_Encyclopedia/View/islamic/IslamicCourcesFromArchiveWeb.dart';

class MainArchiveWebMenu extends GetView<PlayerController> {
  List<String> menuList = [];
  List<Map<String, dynamic>> dataView = [];
  String selected = '';
  int playIndex = 0;
  @override
  Widget build(BuildContext context) {
    menuList = List.generate(GlobalData.imagelocation.length,
        (index) => GlobalData.imagelocation[index]['name']);

    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(43, 4, 28, 70),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 153, 239, 24),
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(10, 30)),
      ),
      height: 210,
      width: 130,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: menuList.length,
          itemBuilder: (context, i) {
            bool selectedindex = (DataProvider.globalcoursesID - 1 == i);
            return InkWell(
                onTap: () async {
                  selected = menuList[i];
                  dataView.clear();
                  DataProvider.globalcoursesID = i + 1;
                  GlobalData.selectedLessonMap.forEach((element) {
                    if (element['main']
                        .toString()
                        .trim()
                        .contains(selected.trim())) {
                      dataView.add(element);
                    }
                  });
                  playIndex = i;
                  Get.dialog(menu(context),
                      transitionDuration: Duration(milliseconds: 300));
                },
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(14, 68, 137, 255),
                    border: Border.all(
                      width: 2,
                      color: Color.fromARGB(255, 71, 236, 56),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Image.asset(
                          'assets/images/${i + 1}.jpg',
                          width: 80,
                          height: 100,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: AutoSizeText(
                            menuList[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 104, 211, 16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          }),
    );
  }
  ////********************************* */

  Widget menu(BuildContext context) {
    DataProvider.screenNameForViewDownLoad = 'SelectedCources';
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: const Color.fromARGB(255, 4, 7, 8),
          ),
          borderRadius: const BorderRadius.all(Radius.elliptical(50, 30)),
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
                    /* index % 4 == 0 ? controller.inbanner() : Container(), */
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
