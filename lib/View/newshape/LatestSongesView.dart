import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';
import 'package:Khotab_Encyclopedia/Scraping/MrMazikaScrapping.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataBase/DataBaseHelper.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:get/get.dart';

class LatestSonesListView extends GetView<PlayerController> {
  // i should use stream to get last update
  // List<ItemData> lastsonges = [];
  Widget lastSonges(BuildContext context) {
//    lastsonges = DataProvider.lastsonges;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(25, 144, 13, 164),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 122, 187, 233),
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
      ),
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 20,
              child: Center(
                child: AutoSizeText(
                  'أحدث الأغاني',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: streamData(context)),
        ],
      ),
    );
  }

  Widget streamData(context) {
    List<ItemData> lastsonges = [];
    return StreamBuilder(
        stream: MrMazikkaScrapping.getLastSongesList().asBroadcastStream(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            lastsonges = snapshot.data!.toSet().toList();
            return dataList(context, lastsonges);
          }
          if (snapshot.hasData) {
            lastsonges = snapshot.data!.toSet().toList();
            // lastsonges = lastsonges.toSet().toList();
            //     DataProvider.lastsonges = lastsonges;
            return dataList(context, lastsonges);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }

  Widget dataList(context, List<ItemData> lastsonges) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lastsonges.length,
        itemBuilder: ((context, index) {
          return InkWell(
            onTap: () async {
              DataProvider.alboumName = lastsonges[index].name;
              DataProvider.alboumUrl = lastsonges[index].url;
              DataProvider.subCategoryName = "جديد";
              DataProvider.alboum.clear();
              DataProvider.alboum = lastsonges;
              controller.alboum.value = DataProvider.alboum;
              controller.playIndex(index);
              controller.fromurl(true);
              Get.to(MusicList());
              //Navigator.pushNamed(context, PlayerControl.route);;
            },
            child: Container(
              height: 120,
              padding: EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                color: Color.fromARGB(47, 96, 125, 139),
                border: Border.all(
                  width: 1,
                  color: Color.fromARGB(255, 156, 13, 175),
                ),
                borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(25, 82, 79, 79),
                    offset: Offset(10, 20),
                    blurRadius: 30,
                  )
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                      flex: 5,
                      child: lastsonges[index].imageUrl.contains('https')
                          ? SizedBox(
                              width: 80,
                              height: 100,
                              child: Image.network(
                                lastsonges[index].imageUrl.trim(),
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
                          lastsonges[index].name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Color.fromARGB(255, 191, 223, 11),
                              fontSize: 22),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }));
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
//    lastsonges = DataProvider.lastsonges;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(25, 144, 13, 164),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 122, 187, 233),
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
      ),
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 20,
              child: Center(
                child: AutoSizeText(
                  'أحدث الأغاني',
                  style: TextStyle(color: Colors.white),
                ),
              )),
          Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: streamData(context)),
        ],
      ),
    );
    throw UnimplementedError();
  }
}
