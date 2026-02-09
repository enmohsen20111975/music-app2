import 'dart:async';

import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:get/get.dart';

class FavouritSonges extends GetView<PlayerController> {
  // static AngamyScrapping shabyatScrapper = AngamyScrapping();
  final controller = Get.put(PlayerController());
  List<ItemData> favouriteSonges = DataProvider.favouriteSonges;

  /*  */

  Widget listbody() {
    return Container(
      height: 180,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: favouriteSonges.length,
          itemBuilder: ((context, index) {
            //   Timer(Duration(microseconds: 20), () {});
            Timer(Duration(milliseconds: 10), () {});
            return InkWell(
              onLongPress: () {
                controller.dbHelper
                    .delete(DataProvider.favouriteSonges[index].name,
                        TablesId.fav_singers)
                    .then((value) => Get.snackbar('Delete',
                        'Delete Done for ${DataProvider.favouriteSonges[index].name}'));
              },
              onTap: () async {
                DataProvider.alboumName = favouriteSonges[index].name;
                DataProvider.alboumUrl = favouriteSonges[index].url;
                // DataProvider.alboum.clear();
                DataProvider.alboum = favouriteSonges;
                DataProvider.subCategoryName = "المفضلة";

                /******************************** */
                controller.alboum.value = DataProvider.alboum;
                controller.playIndex(
                    DataProvider.alboum.indexOf(DataProvider.alboum.first));
                controller.fromurl(true);
                Get.to(MusicList());
                controller.adhelper.showInterstitialAd();
                //Navigator.pushNamed(context, PlayerControl.route);;
              },
              child: favouriteSonges[index].name.isNotEmpty
                  ? Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(14, 68, 137, 255),
                        border: Border.all(
                          width: 2,
                          color: Color.fromARGB(255, 71, 236, 56),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Column(children: [
                        Expanded(
                            flex: 5,
                            child: favouriteSonges[index]
                                    .imageUrl
                                    .contains('https')
                                ? SizedBox(
                                    width: 80,
                                    height: 100,
                                    child: Image.network(
                                      favouriteSonges[index].imageUrl.trim(),
                                      //   scale: 1,
                                    ),
                                  )
                                : SizedBox(
                                    width: 80,
                                    height: 100,
                                    child: Image.asset('assets/MEDIA/U.jpg'))),
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: SizedBox(
                              width: 80,
                              child: AutoSizeText(
                                favouriteSonges[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color.fromARGB(255, 191, 223, 11),
                                    fontSize: 22),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    )
                  : Container(),
            );
          })),
    );
  }

  tostView(String title) {
    Fluttertoast.showToast(
        msg: title,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 152, 33, 231),
        textColor: Color.fromARGB(255, 158, 228, 148),
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    favouriteSonges = DataProvider.favouriteSonges;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(25, 144, 13, 164),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 122, 187, 233),
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
      ),
      height: 210,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              Text(
                ' المقطوعات المفضلة ',
                style: TextStyle(color: Colors.white),
              ),
            ],
          )),
          listbody(), // cardList(context),
          /*  DataProvider.favouriteSonges.isEmpty
              ? stremData(favouriteSongesStream)
              : cardList(context), */
        ],
      ),
    );
  }
}
