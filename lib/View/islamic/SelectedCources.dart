import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/globalData.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/lecturersFromAssabile.dart';

import 'package:Khotab_Encyclopedia/View/WaitloadingData.dart';
import 'package:Khotab_Encyclopedia/googleADs/adhelper.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SelectedCources extends StatefulWidget {
  const SelectedCources({super.key});
  static const route = 'SelectedCources';
  @override
  State<SelectedCources> createState() => _SelectedCourcesState();
}

class _SelectedCourcesState extends State<SelectedCources> {
  String selected = '';

  String url = '';
  final controller = Get.put(PlayerController());
  List<String> menuList = [];
  List<Map<String, dynamic>> dataView = [];
  GooGleAdmobhelper adhelper = GooGleAdmobhelper();
  ScrappingOfAssbile scrapper = ScrappingOfAssbile();
  List<ItemData> data = [];
  Widget inbanner() {
    final Container cont = Container(
      child: AdWidget(
        ad: GooGleAdmobhelper.getBunnerAD()..load(),
        key: UniqueKey(),
      ),
      height: 50,
    );
    return cont;
  }

  dataSelected(String selectedname) async {
    GlobalData.selectedLessonMap.forEach((element) {
      if (element['main'].toString().contains(selectedname)) {
        dataView.add(element);
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    // stream = scrapeLecture.getAllLeacters();
    dataSelected('عام');
    adhelper.createInterstitialAd();
    DataProvider.globalcoursesID = 12;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider.screenNameForViewDownLoad = 'SelectedCources';
    return Scaffold(
      appBar: AppBar(
        title: Text('أختار التصنيف '),
        centerTitle: true,
      ),
      drawer: menu(),
      extendBody: true,
      body: SingleChildScrollView(child: body()),
    );
  }

  Widget menu() {
    menuList = List.generate(GlobalData.imagelocation.length,
        (index) => GlobalData.imagelocation[index]['name']);
    //  menuList.sort((a, b) => a.length.compareTo(b.length));
    return Drawer(
      backgroundColor: Color.fromARGB(255, 6, 44, 75),
      child: ListView.builder(
          itemCount: menuList.length,
          itemBuilder: (context, i) {
            return TextButton(
                onPressed: () async {
                  selected = menuList[i];
                  dataView.clear();
                  DataProvider.globalcoursesID = i + 1;
                  if (selected == '') selected = 'عام';
                  GlobalData.selectedLessonMap.forEach((element) {
                    if (element['main']
                        .toString()
                        .trim()
                        .contains(selected.trim())) {
                      dataView.add(element);
                    }
                  });
                  setState(() {});

                  Navigator.pop(context);
                },
                child: ListTile(
                  title: Text(
                    menuList[i],
                    style: TextStyle(color: Colors.yellowAccent),
                  ),
                  leading: Image.asset(
                    'assets/images/${i + 1}.jpg',
                    width: 80,
                    height: 100,
                  ),
                ) //cardView(menuList[i].toString());
                );
          }),
    );
  }

  Widget body() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height - 50,
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
                  adhelper.showInterstitialAd();
                  Navigator.pushNamed(context, WaitloadingData.route);
                },
                child: Column(
                  children: [
                    index % 4 == 0 ? inbanner() : Container(),
                    cardView(dataView[index]['name'],
                        ItemData.fromMap(controller.dataView[index])),
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
