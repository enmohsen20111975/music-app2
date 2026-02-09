import 'package:Khotab_Encyclopedia/Scraping/Melody4araAndSm3nabSacrapper.dart';
import 'package:Khotab_Encyclopedia/View/APILoading.dart';
import 'package:Khotab_Encyclopedia/View/Radio/RadioStationsView.dart';
import 'package:Khotab_Encyclopedia/View/islamic/archivaAsRow.dart';
import 'package:Khotab_Encyclopedia/View/newshape/LatestSongesView.dart';
import 'package:Khotab_Encyclopedia/View/test.dart';
import 'package:animate_do/animate_do.dart';
import 'package:Khotab_Encyclopedia/AboutUs/aboutAus.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:Khotab_Encyclopedia/Decorations/containerDecorations.dart';
import 'package:Khotab_Encyclopedia/View/islamic/IslamicCourcesFromArchiveWeb.dart';
import 'package:Khotab_Encyclopedia/View/islamic/SelectedCources.dart';
import 'package:Khotab_Encyclopedia/View/islamic/mainArchiveWebMenu.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/View/CountriesSelector.dart';
import 'package:Khotab_Encyclopedia/View/SearchScreen.dart';
import 'package:Khotab_Encyclopedia/View/UpdateDataScreen.dart';
import 'package:Khotab_Encyclopedia/View/ViewDownloadedFiles.dart';
import 'package:Khotab_Encyclopedia/View/islamic/BooksView.dart';
import 'package:Khotab_Encyclopedia/View/ViewTools/LineCard.dart';
import 'package:upgrader/upgrader.dart';

import '../DataModel/Tables.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({
    Key? key,
  }) : super(key: key);

  static const route = 'NewHomeScreen';
  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {
  var controller = Get.put(PlayerController(), permanent: true);
  bool bottumBarEnable = false;
  bool _isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      _isMenuOpen = !_isMenuOpen;
    });
  }

  @override
  void initState() {
    if (!kDebugMode) {
      controller.adhelper.createInterstitialAd();
    }
    loadFavourits().then((value) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future loadFavourits() async {
    DataProvider.favouriteSingers = await controller.dbHelper
        .futureLoadStorage(TablesId.fav_singers, 'name');
    controller.favouriteSingers.value = DataProvider.favouriteSingers;
    DataProvider.favouriteSonges = await controller.dbHelper
        .futureLoadStorage(TablesId.fav_songes, 'name');
    controller.favouriteSonges.value = DataProvider.favouriteSonges;
  }

  @override
  Widget build(BuildContext context) {
    if (DataProvider.countStart == 0) {
      DataProvider.countStart++;
      return Container(
        child: UpdateDataScreen(),
      );
    } else {
      DataProvider.countStart++;
      DataProvider.alboum.clear();
      return UpgradeAlert(
        upgrader: Upgrader(
            canDismissDialog: true,
            durationUntilAlertAgain: Duration(days: 1),
            dialogStyle: UpgradeDialogStyle.cupertino),
        child: Scaffold(
          backgroundColor: Color.fromARGB(204, 61, 59, 59),
          resizeToAvoidBottomInset: true,
          body: Stack(children: [
            bodyView(),
            if (_isMenuOpen) flotboutton(),
          ]),
          floatingActionButton: FloatingActionButton(
            onPressed: _toggleMenu,
            tooltip: 'Menu',
            child: Icon(_isMenuOpen ? Icons.close : Icons.menu),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          extendBody: true,

          //  bottomNavigationBar: FadeInUpBig(child: menu()),
        ),
      );
    }
  }

  Widget menu() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      color: Color.fromARGB(255, 68, 65, 65),
      //  decoration: MyDecorations.greenCard,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            child: TextButton.icon(
              onPressed: () {
                DataProvider.songerListSelector == 0;
                DataProvider.fromUrl = false;
                Get.to(() => ViewDownLoadedFiles())!.then((value) {
                  if (!kDebugMode) {
                    controller.adhelper.showInterstitialAd();
                  }
                });
              },
              icon: Icon(Icons.folder),
              label: Text('Downloaded'),
            ),
          ),
          Container(
            child: TextButton.icon(
              onPressed: () {
                Get.to(() => SearchScreen());
              },
              icon: Icon(Icons.search),
              label: Text('Search'),
            ),
          ),
          Container(
            child: TextButton.icon(
              onPressed: () {
                Get.to(Aboutus());
              },
              icon: Icon(Icons.info),
              label: Text('About us'),
            ),
          ),
          /*   Container(
            child: IconButton(
                onPressed: () {
                  Get.to(() => CountriesSelector());
                },
                icon: Icon(Icons.map_sharp)),
          ), */
         /*  Container(
            child: IconButton(
                onPressed: () {
                  Melody4arabSacrapper.scrapeSeeMoreWebPage(
                      'https://www.sm3na.com/audios/c6bb9f0cd2/');
                },
                icon: Icon(Icons.radio)),
          ), */
          Container(
            child: TextButton(
                onPressed: () {
                  /*   controller.onlineUpDate(true); */
                  Get.to(() => UpdateDataScreen());
                },
                child: Text(
                  'التحديث',
                  style: TextStyle(color: Colors.yellowAccent),
                )),
          ),
        ],
      ),
    );
  }

  Widget flotboutton() {
    return Positioned(
      bottom: 80,
      right: 16,
      child: Container(
        decoration: MyDecorations.greenCard,
        height: 300,
        width: 200,
        child: menu(),
      ),
    );
  }

  Widget bodyView() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      //  decoration: MyDecorations.image1,
      child: ListView(
        children: [
          /**************************************** */
          FadeInUpBig(child: favourets()),
          /**************************************** */
          /**************************************** */
          FadeInUpBig(child: songes()),
          /**************************************** */
          /**************************************** */
          FadeInUpBig(child: islamic()),
          /**************************************** */
          //FadeInRightBig(child: commingSoon()),
          /**************************************** */
         
          TextButton(onPressed: ()  {
            Get.to(()=>Test (),);
          }, child: Text('Test')),
          
        ],
      ),
    );
  }

  Widget islamic() {
    return Column(
      children: [
        FadeInRightBig(
          child: LineCard(
              PagesID.IslamicSonges,
              controller.anasheed.value.cast(),
              'الأناشد الإسلامية',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),
        /*  /*  if (!kDebugMode) controller.inbanner(), */
          MainArchiveWebMenu(), */
       /* /*  if (!kDebugMode) controller.inbanner(), */ */
        //  BooksView(),
        FadeInRightBig(
          child: LineCard(
              PagesID.Books,
              controller.sounBooks.value.cast(),
              ' الكتب المسموعة',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),
         /*  if (!kDebugMode) controller.inbanner(), */
        FadeInRightBig(
          child: LineCard(
              PagesID.IslamicShortLeactures,
              controller.lectcures.value.cast(),
              'محاضرات دينية',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),
       /*  if (!kDebugMode) controller.inbanner(), */
           ArchiveAsRow(),
        FadeInRightBig(
          child: LineCard(
              PagesID.ArchiveOrg,
              controller.archiveOrg.value.cast(),
              'موسوعات دينية',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),
       /*  if (!kDebugMode) controller.inbanner(), */
      ],
    );
  }

  Widget songes() {
    return Column(
      children: [
       /*  if (!kDebugMode) controller.inbanner(), */
        FadeInRightBig(
          child: LineCard(
              PagesID.Singers,
              controller.allSongersData.value.cast(),
              'Songers',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),
       /*  if (!kDebugMode) controller.inbanner(), */
        // LatestSonesListView(),
        FadeInRightBig(
          child: LineCard(
              PagesID.LastSonges,
              controller.lastsonges.value.cast(),
              'New Songes',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),

       /*  if (!kDebugMode) controller.inbanner(), */
        //  ShabyatListView(),
        FadeInRightBig(
          child: LineCard(
              PagesID.Shabyat,
              controller.shabyatSonges.value.cast(),
              'مهرجنات',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),
       /*  if (!kDebugMode) controller.inbanner(), */
      ],
    );
  }

  Widget favourets() {
    return Column(
      children: [
        /*   if (!kDebugMode && DataProvider.favouriteSingers.isNotEmpty)
          controller.inbanner(), */
        controller.favouriteSingers.isNotEmpty
            ? FadeInRightBig(
                child: LineCard(
                    PagesID.Fav_singers,
                    controller.favouriteSingers.value.cast(),
                    'Favourites singers',
                    MyDecorations.rounBlue,
                    MyDecorations.gradiant,
                    true),
              )
            : Container(
                //  child: Card(child: AutoSizeText('Favourits is Empty')),
                ),
        /*   if (!kDebugMode && DataProvider.favouriteSonges.isNotEmpty)
          controller.inbanner(), */
        controller.favouriteSonges.isNotEmpty
            ? FadeInRightBig(
                child: LineCard(
                    PagesID.Fav_Songes,
                    controller.favouriteSonges.value.cast(),
                    'Favourite Songers',
                    MyDecorations.rounBlue,
                    MyDecorations.gradiant,
                    true),
              )
            : Container(
                //   child: Card(child: AutoSizeText('Favourits is Empty')),
                ),
       /*  if (!kDebugMode) controller.inbanner(), */
      ],
    );
  }

  Widget commingSoon() {
    return Column(
      children: [
       /*  if (!kDebugMode) controller.inbanner(), */
        FadeInRightBig(
          child: LineCard(
              PagesID.Singers,
              controller.rap.value.cast(),
              'Rap Songes',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),
       /*  if (!kDebugMode) controller.inbanner(), */
        // LatestSonesListView(),
        FadeInRightBig(
          child: LineCard(
              PagesID.LastSonges,
              controller.englishSonges.value.cast(),
              'English Songes',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),

       /*  if (!kDebugMode) controller.inbanner(), */
        //  ShabyatListView(),
        FadeInRightBig(
          child: LineCard(
              PagesID.Shabyat,
              controller.mostView.value.cast(),
              'Most View',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),
       /*  if (!kDebugMode) controller.inbanner(), */
        FadeInRightBig(
          child: LineCard(
              PagesID.Shabyat,
              controller.trend.value.cast(),
              'Trend Music',
              MyDecorations.rounBlue,
              MyDecorations.gradiant,
              false),
        ),
       /*  if (!kDebugMode) controller.inbanner(), */
      ],
    );
  }
}
