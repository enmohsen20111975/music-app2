import 'dart:async';

import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:get/get.dart';

class ShabyatListView extends GetView<PlayerController> {
  // static AngamyScrapping shabyatScrapper = AngamyScrapping();
  // final controller = Get.put(PlayerController());
  List<ItemData> shabyatSonges = DataProvider.shabyatSonges;

  /* sortShabyatbysiger() {
    DataProvider.shabyatSonges
        .sort(((a, b) => a.songerName.compareTo(b.songerName)));
    List<String> names = [];
    List<ItemData> shabyatSinger = [];
    DataProvider.shabyatSonges.forEach((element) {
      if (element.songerName.isNotEmpty) {
        names.add(element.songerName);
      } else {
        names
            .add(element.name.replaceAll('اغنية', '').replaceAll('مهرجان', ''));
      }
    });
    print('names1= ${names.length}');
    names.toSet().toList();
    print('names= >>>${names.length}');
    try {
      names.forEach((name) {
        shabyatSinger.add(DataProvider.shabyatSonges
            .firstWhere((element) => element.songerName == name));
      });
      print('output = ${shabyatSinger.length}');
    } on Exception catch (e) {
      // TODO

    }
  }
 */
  /*  Widget stremData(Stream<List<ItemData>> shabyatSongesStream) {
    return Container(
      height: 180,
      child: StreamBuilder(
          stream: shabyatSongesStream,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              shabyatSonges = snapshot.data!;
              DataProvider.shabyatSonges = shabyatSonges;
              print(
                  ' DataProvider.shabyatSonges==>${DataProvider.shabyatSonges.length}');
            }
            if (snapshot.hasData) {
              print(snapshot.data!.length);
              shabyatSonges = snapshot.data!;
              return listbody();
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          })),
    );
  }
 */
  Widget listbody() {
    return Container(
      height: 180,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: shabyatSonges.length,
          itemBuilder: ((context, index) {
            //   Timer(Duration(microseconds: 20), () {});
            Timer(Duration(milliseconds: 10), () {});
            return InkWell(
              onTap: () async {
                DataProvider.alboumName = shabyatSonges[index].name;
                DataProvider.alboumUrl = shabyatSonges[index].url;
                DataProvider.alboum.clear();
                DataProvider.alboum.add(shabyatSonges[index]);
                DataProvider.subCategoryName = "شعبيات";

                /******************************** */
                controller.alboum.value = DataProvider.alboum;
                controller.playIndex(
                    DataProvider.alboum.indexOf(DataProvider.alboum.first));
                controller.fromurl(true);
                Get.to(MusicList());
                controller.adhelper.showInterstitialAd();
                //Navigator.pushNamed(context, PlayerControl.route);;
              },
              child: shabyatSonges[index].name.isNotEmpty
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
                            child: shabyatSonges[index]
                                    .imageUrl
                                    .contains('https')
                                ? SizedBox(
                                    width: 80,
                                    height: 100,
                                    child: Image.network(
                                      shabyatSonges[index].imageUrl.trim(),
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
                                shabyatSonges[index].name,
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
    //  sortShabyatbysiger();
    shabyatSonges = DataProvider.shabyatSonges;
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
        children: [
          Container(
              child: Center(
            child: Text(
              ' شعبيات ومهرجانات',
              style: TextStyle(color: Colors.white),
            ),
          )),
          listbody(), // cardList(context),
          /*  DataProvider.shabyatSonges.isEmpty
              ? stremData(shabyatSongesStream)
              : cardList(context), */
        ],
      ),
    );
  }
}
