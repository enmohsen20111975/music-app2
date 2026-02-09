import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/MP3Player/MusicList.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';

import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/Scraping/ScrappingMP3Songes_Site.dart';
import 'package:Khotab_Encyclopedia/View/newshape/SongerAlboumsView.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  static const route = 'Search secreen';
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController singersearchbox = TextEditingController();

  final getcontroller = Get.put(PlayerController());
  List<ItemData> searched = [];
  int tabID = 0;

  TextEditingController controller = new TextEditingController();

  @override
  void initState() {
    // TODO: implement initState

    if (kDebugMode == false) {
      getcontroller.adhelper.createInterstitialAd();
    }
    super.initState();
  }

  Widget tabsView() {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.grey,
            title: Text('Search Screen'),
            centerTitle: true,
            bottom: TabBar(tabs: [
              Tab(
                icon: Image.asset('assets/MEDIA/singer.jpg'),
              ),
              Tab(
                icon: Image.asset('assets/MEDIA/new.png'),
              ),
              Tab(
                icon: Image.asset('assets/MEDIA/shabyat.jpg'),
              ),
              Tab(
                icon: Image.asset('assets/MEDIA/anashed.jpg'),
              ),
              Tab(
                icon: Image.asset('assets/MEDIA/dross.jpg'),
              ),
            ]),
          ),
          body: TabBarView(children: [
            searchcard('songers', 1),
            searchcard('last', 2),
            searchcard('shabyat', 3),
            searchcard('anashed', 4),
            searchcard('Archive', 5),
          ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return tabsView();
  }

  Widget searchcard(String type, int tabnumber) {
    List<ItemData> data = [];
    switch (tabnumber) {
      case 1:
        searched.isNotEmpty && tabID == tabnumber
            ? data = searched
            : data = DataProvider.allSongersData;
        break;
      case 2:
        searched.isNotEmpty && tabID == tabnumber
            ? data = searched
            : data = DataProvider.lastsonges;
        break;
      case 3:
        searched.isNotEmpty && tabID == tabnumber
            ? data = searched
            : data = DataProvider.shabyatSonges;
        break;
      case 4:
        searched.isNotEmpty && tabID == tabnumber
            ? data = searched
            : data = DataProvider.anasheed;
        break;
      case 5:
        searched.isNotEmpty && tabID == tabnumber
            ? data = searched
            : data = DataProvider.archiveOrg;
        break;
      default:
    }
    return Container(
      padding: EdgeInsets.only(left: 8, right: 8),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Color.fromARGB(255, 55, 15, 78),
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
        color: Color.fromARGB(255, 2, 11, 15),
        gradient: LinearGradient(colors: [
          Color.fromARGB(92, 8, 99, 99),
          Color.fromARGB(72, 62, 9, 122)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(83, 244, 67, 54),
            offset: Offset(10, 20),
            blurRadius: 30,
          )
        ],
      ),
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(flex: 1, child: searchbar2(type, data)),
          Expanded(
            flex: 10,
            child: Container(
              //  color: Color.fromARGB(45, 158, 158, 158),
              height: MediaQuery.of(context).size.height - 180,
              child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: ((context, index) {
                    return InkWell(
                      onTap: () {
                        /*   switch (type) {
                          case 'songers':
                            DataProvider.subCategoryName = 'أغاني';
                            DataProvider.subCategoryUrl = data[index].url;
                            Get.to(() => AllAlboumsForSelectedSonger(),
                                transition: Transition.zoom);
                            break;
                          case 'last':
                            DataProvider.subCategoryName = 'جديد';
                            DataProvider.alboumName = data[index].name;
                            DataProvider.alboumUrl = data[index].url;
                            DataProvider.alboum.clear();
                            DataProvider.alboum.add(data[index]);
                            /******************************** */
                            getcontroller.alboum.value = DataProvider.alboum;
                            getcontroller.playIndex(DataProvider.alboum
                                .indexOf(DataProvider.alboum.first));
                            getcontroller.fromurl(true);
                            Get.to(MusicList());

                            //Navigator.pushNamed(context, PlayerControl.route);;
                            if (kDebugMode == false)
                              getcontroller.adhelper.showInterstitialAd();

                            break;
                          case 'shabyat':
                            DataProvider.subCategoryName = 'مهرجنات';
                            DataProvider.alboumName = data[index].name;
                            DataProvider.alboumUrl = data[index].url;
                            DataProvider.alboum.clear();
                            DataProvider.alboum.add(data[index]);
                            /******************************** */
                            getcontroller.alboum.value = DataProvider.alboum;
                            getcontroller.playIndex(DataProvider.alboum
                                .indexOf(DataProvider.alboum.first));
                            getcontroller.fromurl(true);
                            Get.to(MusicList());
                            getcontroller.adhelper.showInterstitialAd();
                            //Navigator.pushNamed(context, PlayerControl.route);;
                            if (kDebugMode == false)
                              getcontroller.adhelper.showInterstitialAd();

                            break;
                          case 'anashed':
                            DataProvider.subCategoryName = 'أناشيد';
                            DataProvider.subCategoryImage =
                                data[index].imageUrl;
                            DataProvider.subCategoryUrl = data[index].url;

                            Sacrapper.getAnashedList(
                                    DataProvider.subCategoryUrl)
                                .then((value) {
                              /******************************** */
                              getcontroller.alboum.value = DataProvider.alboum;
                              getcontroller.playIndex(DataProvider.alboum
                                  .indexOf(DataProvider.alboum.first));
                              getcontroller.fromurl(true);
                              Get.to(MusicList());
                              getcontroller.adhelper.showInterstitialAd();
                              //Navigator.pushNamed(context, PlayerControl.route);;
                              if (kDebugMode == false) {
                                getcontroller.adhelper.showInterstitialAd();
                              }
                            });
                            break;
                          default:
                        } */
                        DataProvider.alboum.clear();
                        DataProvider.alboum.add(data[index]);
                        /******************************** */
                        getcontroller.alboum.value = DataProvider.alboum;
                        getcontroller.playIndex(DataProvider.alboum
                            .indexOf(DataProvider.alboum.first));
                        getcontroller.fromurl(true);
                        Get.to(MusicList());
                        //Navigator.pushNamed(context, PlayerControl.route);;
                        if (kDebugMode == false)
                          getcontroller.adhelper.showInterstitialAd();
                      },
                      child: Card(
                        color: Color.fromARGB(97, 18, 32, 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: ListTile(
                          title: Text(
                            data[index].name,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.yellow),
                          ),
                          subtitle: Text(
                            data[index].songerName,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.yellow),
                          ),
                          trailing: type != 'Archive'
                              ? Text(
                                  data[index].alboumName,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.yellow),
                                )
                              : Text(''),
                          leading: data[index].imageUrl.contains('https')
                              ? SizedBox(
                                  width: 80,
                                  height: 100,
                                  child: Image.network(
                                    data[index].imageUrl,
                                    scale: 1,
                                  ),
                                )
                              : SizedBox(
                                  width: 80,
                                  height: 100,
                                  child: Image.asset('assets/MEDIA/U.jpg')),
                        ),
                      ),
                    );
                  })),
            ),
          ),
        ],
      ),
    );
  }

  Widget searchbar2(String type, List<ItemData> data) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          flex: 8,
          child: TextField(
            controller: singersearchbox,
            decoration: InputDecoration(
              suffixIcon: Icon(Icons.search),
              fillColor: Colors.white,
              focusColor: Color.fromARGB(255, 217, 228, 61),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 175, 11, 148),
                ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              hintText: "أبحث عن ماتريد من هنا ",
            ),
            enabled: true,
            onChanged: (txt) {
              selector(type, txt);
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: TextButton.icon(
              onPressed: () {
                DataProvider.alboum.clear();
                DataProvider.alboum.addAll(data);
                /******************************** */
                getcontroller.alboum.value = DataProvider.alboum;
                getcontroller.playIndex(
                    DataProvider.alboum.indexOf(DataProvider.alboum.first));
                getcontroller.fromurl(true);
                Get.to(MusicList());
                //Navigator.pushNamed(context, PlayerControl.route);;
                if (kDebugMode == false)
                  getcontroller.adhelper.showInterstitialAd();
              },
              icon: Icon(
                Icons.play_arrow_sharp,
                color: Colors.yellowAccent,
              ),
              label: Text(
                'Play',
                style: TextStyle(color: Colors.greenAccent),
              )),
        ),
      ],
    );
  }

  selector(String type, String name) {
    switch (type) {
      case 'songers':
        getsearchedSinger(name);
        tabID = 1;
        break;
      case 'last':
        getsearchedLastSonges(name);
        tabID = 2;
        break;
      case 'anashed':
        getsearchedAnasheed(name);
        tabID = 3;
        break;
      case 'shabyat':
        getsearchedShabyat(name);
        tabID = 4;
        break;
      case 'Archive':
        getsearchedArchive(name);
        tabID = 5;
        break;
      default:
    }
  }

  getsearchedSinger(String name) {
    searched.clear();
    DataProvider.allSongers.forEach((element) {
      if (element.name.contains(name)) {
        searched.add(element);
      }
    });
    setState(() {});
  }

  getsearchedArchive(String name) {
    searched.clear();
    DataProvider.archiveOrg.forEach((element) {
      if (element.name.contains(name)) {
        searched.add(element);
      }
    });
    setState(() {});
  }

  getsearchedShabyat(String name) {
    searched.clear();
    DataProvider.shabyatSonges.forEach((element) {
      if (element.name.contains(name)) {
        searched.add(element);
      }
    });
    setState(() {});
  }

  getsearchedAnasheed(String name) {
    searched.clear();
    DataProvider.anasheed.forEach((element) {
      if (element.name.contains(name)) {
        searched.add(element);
      }
    });
    setState(() {});
  }

  getsearchedLastSonges(String name) {
    searched.clear();
    DataProvider.lastsonges.forEach((element) {
      if (element.name.contains(name)) {
        searched.add(element);
      }
    });
    setState(() {});
  }
}
