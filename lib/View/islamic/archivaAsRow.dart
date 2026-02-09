import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/Decorations/containerDecorations.dart';
import 'package:Khotab_Encyclopedia/Scraping/islamic/globalData.dart';
import 'package:Khotab_Encyclopedia/View/islamic/ArchiveviewData.dart';
import 'package:Khotab_Encyclopedia/View/islamic/SelectedCources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class ArchiveAsRow extends GetView<PlayerController> {
  List<String> menuList = [];
  List<Map<String, dynamic>> dataView = [];
  String selected = '';
  @override
  Widget build(BuildContext context) {
    menuList = List.generate(GlobalData.imagelocation.length,
        (index) => GlobalData.imagelocation[index]['name']);
    //  menuList.sort((a, b) => a.length.compareTo(b.length));
    return Container(
      decoration: MyDecorations.greenCard,
      height: 200,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: menuList.length,
          itemBuilder: (context, i) {
            return InkWell(
              onTap: () async {
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
                controller.dataView(dataView);
                Get.to(() => ArchiveViewData());
              },
              child: Row(
                children: [
                  Container(
                    width: 20,
                  ),
                  Container(
                    height: 180,
                    //   decoration: MyDecorations.gradiantDark,
                    child: Column(
                      children: [
                        Expanded(
                          flex: 4,
                          child: SizedBox(
                            width: 80,
                            height: 100,
                            child: Image.asset(
                              'assets/images/${i + 1}.jpg',
                              width: 80,
                              height: 100,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            width: 80,
                            height: 40,
                            child: Text(
                              menuList[i],
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.yellowAccent),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
