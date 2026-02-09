import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/View/newshape/SongerAlboumsView.dart';
import 'package:get/get.dart';

class FavouriteSingers extends GetView<PlayerController> {
  Widget listData() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: DataProvider.favouriteSingers.length,
        itemBuilder: ((context, index) {
          return InkWell(
            onLongPress: () {
              controller.dbHelper
                  .delete(DataProvider.favouriteSingers[index].name,
                      TablesId.fav_singers)
                  .then((value) => Get.snackbar('Delete',
                      'Delete Done for ${DataProvider.favouriteSingers[index].name}'));
            },
            onTap: () {
              DataProvider.subCategoryUrl =
                  DataProvider.favouriteSingers[index].url;
              DataProvider.subCategoryName = 'المفضلين';
              DataProvider.singerName =
                  DataProvider.favouriteSingers[index].name;
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
                    child: DataProvider.favouriteSingers[index].imageUrl
                            .contains('https')
                        ? SizedBox(
                            width: 80,
                            height: 100,
                            child: Image.network(
                              DataProvider.favouriteSingers[index].imageUrl,
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
                    child: SizedBox(
                      width: 80,
                      child: AutoSizeText(
                        DataProvider.favouriteSingers[index].name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(255, 191, 223, 11),
                            fontSize: 22),
                      ),
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
                'المفضلين',
                style: TextStyle(color: Colors.greenAccent),
              ),
            ],
          )),
          /*  if (DataProvider.favouriteSingers.isEmpty)
           streamData(songersStream)
          else
            listData(), */
          listData(),
        ],
      ),
    );
  }
}
