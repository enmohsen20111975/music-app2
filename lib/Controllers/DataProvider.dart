//
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

class DataProvider extends InheritedWidget {
  DataProvider({required this.child}) : super(child: child);
  Widget child;
  bool toload = false;
  static int downloadprocess = 0, countStart = 0;
  static bool offline = true, toupdate = false;
  static int savedIndex = 0;
  static int index = 0;

  static String screenNameForViewDownLoad = 'CourseListView';
  static int numberOfLessons = 0, globalcoursesID = 1;
  static int selectedCourceId = 0;
  static int selectedSongeFromList = 0;
  static int currentSongnumber = 0;
  static ItemData selectedCountry = ItemData();
  static List<ItemData> allSongers = [];
  static List<ItemData> ranati = [];
  static List<ItemData> allSongersData = [];
  static List<ItemData> lastsonges = [];
  static List<ItemData> anasheed = [];
  static List<ItemData> shabyatSonges = [];
  static List<ItemData> sounBooks = [];
  static List<ItemData> lectcures = [];
  static List<ItemData> archiveOrg = [];
  static List<ItemData> favouriteSonges = [];
  static List<ItemData> favouriteSingers = [];
  static PagesID pageID = PagesID.Singers;
  static int mainSelector = 1;
  static int songerListSelector = 0;
  static bool fromUrl = true;
  static String mainCategoryName = '';
  static String mainCategoryUrl = '';
  static String subCategoryName = '';
  static String subCategoryImage = '';
  static String subCategoryUrl = '';
  static String alboumName = '';
  static String alboumUrl = '';
  static String songeName = '';
  static String singerName = '';
  static String songUrl = '';
  static String songMP3Url = '';
  static List<ItemData> alboum = [];
  static List<ItemData> allData = [];
  static bool update = false;

  static ItemData currentsong = ItemData();

  static DataProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<DataProvider>();
  }

  @override
  bool updateShouldNotify(DataProvider oldWidget) {
    toload = false;
    return oldWidget.toload != toload;
  }
}
