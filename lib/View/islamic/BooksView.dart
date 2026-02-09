import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:Khotab_Encyclopedia/MP3Player/playerScreen.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

import '../../Scraping/AudioBooksScrapping.dart';

class BooksView extends GetView<PlayerController> {
  static const route = "BooksView";

  List<ItemData> books = DataProvider.sounBooks;

  Widget dataList(context) {
    List<Widget> buttons = List.generate(books.length, (index) {
      return Container(
          width: 150,
          child: InkWell(
            onTap: (() async {
              DataProvider.alboum.clear();
              DataProvider.fromUrl = false;
              DataProvider.subCategoryName = "كتب";
              print(books[index].songMP3Url);
              await AudioBooks.getDownloadUrlPath(books[index].url.trim())
                  .then((value)
                      /******************************** */
                      {
                int i = 0;
                value.forEach((element) {
                  element.imageUrl = books[index].imageUrl;
                  element.name = books[index].name + ' ج $i';
                });
                value.toSet().toList();
                DataProvider.alboum = value;
                controller.alboum.value = DataProvider.alboum;
                // controller.alboum.value = DataProvider.alboum;
                controller.playIndex(
                    DataProvider.alboum.indexOf(DataProvider.alboum.first));
                controller.fromurl(true);
                Get.to(MusicList());
                controller.adhelper.showInterstitialAd();
                //Navigator.pushNamed(context, PlayerControl.route););
              });
            }),
            child: Stack(
              children: [
                books[index].imageUrl != null &&
                        books[index].imageUrl.contains('http')
                    ? Image.network(books[index].imageUrl)
                    : Image.asset('assets/MEDIA/U.jpg'),
                books[index].imageUrl == ''
                    ? Center(
                        child: AutoSizeText(
                          books[index].name,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : AutoSizeText(''),
              ],
            ),
          ));
    });
    buttons = buttons.toSet().toList();
    return Container(
        height: 150,
        // padding: EdgeInsets.only(left: 8, right: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Wrap(
            direction: Axis.vertical,
            spacing: 5,
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.spaceAround,
            children: buttons,
          ),
        ));
  }

  Widget streamData(Stream<List<ItemData>> booksstream) {
    return StreamBuilder<List<ItemData>>(
      stream: booksstream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {}
        if (snapshot.hasData ||
            snapshot.connectionState == ConnectionState.active) {
          if (DataProvider.sounBooks.isEmpty) {
            books = snapshot.data!;
          } else {
            books = DataProvider.sounBooks;
          }
          return dataList(context);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    books = DataProvider.sounBooks;
    return Container(
      decoration: BoxDecoration(
        color: Color.fromARGB(25, 144, 13, 164),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 122, 187, 233),
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
      ),
      height: 200,
      child: Column(
        children: [
          Container(
            child: Center(
              child: Text(
                ' الكتب المسموعة',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          dataList(context),
        ],
      ),
    );
  }
}
