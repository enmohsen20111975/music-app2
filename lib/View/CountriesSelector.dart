import 'package:Khotab_Encyclopedia/View/ViewTools/webView.dart';
import 'package:get/get.dart';
import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataBase/DataBaseHelper.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/Scraping/Melody4araAndSm3nabSacrapper.dart';
import 'package:Khotab_Encyclopedia/View/SingerbyCountrySm3na.dart';
import 'package:Khotab_Encyclopedia/View/WaitloadingData.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class CountriesSelector extends StatefulWidget {
  const CountriesSelector({super.key});
  static const route = 'CountriesSelector';
  @override
  State<CountriesSelector> createState() => _CountriesSelectorState();
}

class _CountriesSelectorState extends State<CountriesSelector> {
  // Melody4arabSacrapper melody4arabSacrapper = Melody4arabSacrapper();
  final controller = Get.put(PlayerController());
  bool insearch = false;

  @override
  void initState() {
    insearch = false;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: insearch == false ? countriesList() : singerView(),
      bottomSheet: IconButton(
          onPressed: (() {
            insearch = false;
            setState(() {});
          }),
          icon: Icon(Icons.arrow_back)),
    );
  }

  Widget countriesList() {
    return Center(
      child: FutureBuilder<List<ItemData>>(
          future: Melody4arabSacrapper.selectcountrySm3na(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return card(snapshot.data![index]);
                  }));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget singerView() {
    return Center(
      child: StreamBuilder<List<ItemData>>(
          stream: Melody4arabSacrapper.getSongerListNameFromSm3na(
                  DataProvider.selectedCountry.url)
              .asBroadcastStream(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return card(snapshot.data![index]);
                  }));
            }
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return card(snapshot.data![index]);
                  }));
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  Widget card(ItemData data) {
    return Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
        //   color: Color.fromARGB(25, 144, 13, 164),
        border: Border.all(
          width: 1,
          color: Color.fromARGB(255, 122, 187, 233),
        ),
        borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
        gradient: LinearGradient(colors: [
          Color.fromARGB(255, 197, 7, 255),
          Color.fromARGB(255, 11, 141, 135)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 82, 79, 79),
            offset: Offset(10, 20),
            blurRadius: 30,
          )
        ],
      ),
      child: InkWell(
        onTap: () {
          if (insearch == false) {
            DataProvider.selectedCountry = data;
            insearch = true;
            setState(() {});
          } else {
            DataProvider.selectedCountry = data;
            Get.to(() => viewWebPage(data.url));
            // Get.to(SingerByCountry());
          }
        },
        child: AutoSizeText(
          data.name,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.yellowAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
