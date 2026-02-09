import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataBase/DataBaseHelper.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/View/newshape/SongerAlboumsView.dart';

class SingesListView extends GetView<PlayerController> {
  Widget listData() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: DataProvider.allSongers.length,
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () {
              DataProvider.subCategoryUrl = DataProvider.allSongers[index].url;
              DataProvider.subCategoryName = 'أغاني';
              DataProvider.singerName = DataProvider.allSongers[index].name;
              Get.to(() => AllAlboumsForSelectedSonger(),
                  transition: Transition.zoom);
            },
            child: Container(
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
                    child: DataProvider.allSongers[index].imageUrl
                            .contains('https')
                        ? SizedBox(
                            width: 80,
                            height: 100,
                            child: Image.network(
                              DataProvider.allSongers[index].imageUrl,
                              scale: 1,
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
                    child: AutoSizeText(
                      DataProvider.allSongers[index].name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Color.fromARGB(255, 191, 223, 11),
                          fontSize: 22),
                    ),
                  ),
                ),
              ]),
            ),
          );
        }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(43, 4, 28, 70),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 153, 239, 24),
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(10, 30)),
      ),
      height: 250,
      child: Column(
        children: [
          Container(
              child: Text(
            'كل المطربين',
            style: TextStyle(color: Colors.greenAccent),
          )),
          /*  if (DataProvider.allSongers.isEmpty)
           streamData(songersStream)
          else
            listData(), */
          listData(),
        ],
      ),
    );
  }
}
