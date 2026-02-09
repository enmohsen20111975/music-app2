/* import 'package:Khotab_Encyclopedia/DataBase/DataBaseHelper.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/Scraping/AganynaScrapper.dart';
import 'package:Khotab_Encyclopedia/Scraping/AudioBooksScrapping.dart';
import 'package:Khotab_Encyclopedia/Scraping/MrMazikaScrapping.dart';
import 'package:Khotab_Encyclopedia/Scraping/ScrappingMP3Songes_Site.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/IsalmicScrapping.dart';

import 'package:Khotab_Encyclopedia/View/NewHomeScreen.dart';
import 'package:Khotab_Encyclopedia/controllers/DataProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class StartLoadingScreen extends StatefulWidget {
  const StartLoadingScreen({super.key});
  static const route = 'Start Loading Screen';
  @override
  State<StartLoadingScreen> createState() => _StartLoadingScreenState();
}

class _StartLoadingScreenState extends State<StartLoadingScreen> {
  late Stream<List<ItemData>> songersStream;
  late Stream<List<ItemData>> lastSongesStream;
  late Stream<List<ItemData>> ansheedstream;

  // late Stream<List<ItemData>> shabyatstream;
  late Stream<List<ItemData>> booksstream;
  late Stream<List<ItemData>> shortIslamicLeacturesStream;
  DbHelper dbHelper = DbHelper();
  @override
  void initState() {
    // TODO: implement initState
    dbHelper.intDB();
    clearData();
    intalization();

    super.initState();
  }

  clearData() {
    DataProvider.shabyatSonges.clear();
    DataProvider.allSongers.clear();
    DataProvider.lastsonges.clear();
    DataProvider.anasheed.clear();
    DataProvider.sounBooks.clear();
  }

  intalization() {
    songersStream =
        MrMazikkaScrapping.getAllSongersName_uri().asBroadcastStream();
    lastSongesStream =
        MrMazikkaScrapping.getLastSongesList().asBroadcastStream();
    ansheedstream = Sacrapper.getMainAnashedCategories().asBroadcastStream();
    //  shabyatstream =
    AngamyScrapping.getAghanynaShabyatList().asBroadcastStream();
    booksstream = AudioBooks.getMainBooksList().asBroadcastStream();
    shortIslamicLeacturesStream =
        IslamicTapeSacrapper.getMainCategories().asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(25, 144, 13, 164),
              border: Border.all(
                width: 1,
                color: Color.fromARGB(255, 122, 187, 233),
              ),
              borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
            ),
            height: MediaQuery.of(context).size.height / 1.25,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  //   stremLoading(songersStream, 'كل المطربين', 1),
                  stremLoading(lastSongesStream, 'أحدث الأغاني', 2),
                  stremLoading(ansheedstream, 'الأناشيد', 3),
                  // stremLoading(shabyatstream, 'شعبيات ومهرجانات', 4),
                  stremLoading(booksstream, 'الكتب المسموعة', 5),
                  stremLoading(
                      shortIslamicLeacturesStream, 'المحاضرات الدينية', 6),
                ],
              ),
            ),
          ),
        ));
  }

  Widget stremLoading(Stream<List<ItemData>> stream, String name, int i) {
    int count = 0;
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 62, 93, 146),
        border: Border.all(
          width: 2,
          color: Color.fromARGB(255, 117, 9, 179),
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      child: SizedBox(
        height: 60,
        child: StreamBuilder(
          stream: stream,
          builder: ((context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              switch (i) {
                case 4:
                  DataProvider.shabyatSonges = snapshot.data!;
                  count = i;
                  break;
                case 1:
                  DataProvider.allSongers = snapshot.data!;
                  count = i;
                  break;
                case 2:
                  controller.lastsonges.value = snapshot.data!;
                  count = i;
                  break;
                case 3:
                  DataProvider.anasheed = snapshot.data!;
                  count = i;
                  break;
                case 5:
                  DataProvider.sounBooks = snapshot.data!;
                  count = i;
                  break;
                case 6:
                  DataProvider.lectcures = snapshot.data!;
                  count = i;
                  break;

                default:
              }
              if (count == 2 + 3 + 5 + 6) {
                Navigator.popAndPushNamed(context, NewHomeScreen.route);
              }
              checkDone();
              return Center(
                child: Text('  تم جلب البياتات  ' + '$name'),
              );
            }
            if (snapshot.hasData) {
              switch (i) {
                case 4:
                  DataProvider.shabyatSonges = snapshot.data!;
                  count = i;
                  break;
                case 1:
                  DataProvider.allSongers = snapshot.data!;
                  count = i;
                  break;
                case 2:
                  controller.lastsonges.value = snapshot.data!;
                  count = i;
                  break;
                case 3:
                  count = i;
                  break;
                case 5:
                  DataProvider.sounBooks = snapshot.data!;
                  count = i;
                  break;
                case 6:
                  DataProvider.lectcures = snapshot.data!;
                  count = i;
                  break;

                default:
              }

              return Center(
                child: Text(
                  ' يتم جلب البياتات ....$name \n${snapshot.data!.length}',
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return Center(
                child: Text('$name في إنتظار البيانات'),
              );
            }
          }),
        ),
      ),
    );
  }

  checkDone() {
    if (DataProvider.allSongers.isNotEmpty &&
        DataProvider.lastsonges.isNotEmpty &&
        DataProvider.anasheed.isNotEmpty &&
        /*     DataProvider.shabyatSonges.isNotEmpty && */
        DataProvider.sounBooks.isNotEmpty &&
        DataProvider.lectcures.isNotEmpty) {
      print('Loading done');
    }
  }
}
 */