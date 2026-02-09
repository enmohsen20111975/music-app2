import 'package:flutter/material.dart';

class MyDecorations {
  static BoxDecoration gradiant = BoxDecoration(
    color: const Color.fromARGB(242, 219, 110, 236),
    border: Border.all(
      width: 1,
      color: const Color.fromARGB(255, 4, 7, 8),
    ),
    borderRadius: const BorderRadius.all(Radius.elliptical(50, 30)),
    gradient: const LinearGradient(colors: [
      Color.fromARGB(255, 47, 48, 49),
      Color.fromARGB(255, 233, 189, 233),
      Color.fromARGB(255, 57, 57, 58),
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    boxShadow: [
      const BoxShadow(
        color: Color.fromARGB(25, 82, 79, 79),
        offset: Offset(10, 20),
        blurRadius: 30,
      )
    ],
  );
  static BoxDecoration gradiant2 = BoxDecoration(
    color: const Color.fromARGB(22, 219, 110, 236),
    border: Border.all(
      width: 1,
      color: const Color.fromARGB(255, 4, 7, 8),
    ),
    //  borderRadius: const BorderRadius.all(Radius.elliptical(50, 30)),
    gradient: const LinearGradient(colors: [
      Color.fromARGB(255, 47, 48, 49),
      Color.fromARGB(255, 233, 189, 233),
      Color.fromARGB(255, 57, 57, 58),
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    boxShadow: [
      const BoxShadow(
        color: Color.fromARGB(25, 82, 79, 79),
        offset: Offset(10, 20),
        blurRadius: 30,
      )
    ],
  );
  static BoxDecoration gradiantDark = BoxDecoration(
    //  color: const Color.fromARGB(222, 219, 110, 236),
    border: Border.all(
      width: 1,
      color: const Color.fromARGB(255, 4, 7, 8),
    ),
    //  borderRadius: const BorderRadius.all(Radius.elliptical(50, 30)),
    gradient: const LinearGradient(colors: [
      Color.fromARGB(255, 85, 8, 148),
      Color.fromARGB(255, 42, 103, 235),
      Color.fromARGB(255, 3, 3, 112),
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    boxShadow: [
      const BoxShadow(
        color: Color.fromARGB(225, 82, 79, 79),
        offset: Offset(10, 20),
        blurRadius: 30,
      )
    ],
  );
  static BoxDecoration image1 = BoxDecoration(
    image: DecorationImage(
        image: AssetImage('assets/MEDIA/1.jpg'),
        fit: BoxFit.fill,
        opacity: 0.75,
        filterQuality: FilterQuality.high),
    color: const Color.fromARGB(22, 219, 110, 236),
    border: Border.all(
      width: 1,
      color: const Color.fromARGB(255, 4, 7, 8),
    ),
    //  borderRadius: const BorderRadius.all(Radius.elliptical(50, 30)),
    gradient: const LinearGradient(colors: [
      Color.fromARGB(255, 8, 83, 158),
      Color.fromARGB(255, 51, 43, 124),
      Color.fromARGB(255, 14, 14, 196),
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    boxShadow: [
      const BoxShadow(
        color: Color.fromARGB(25, 82, 79, 79),
        offset: Offset(10, 20),
        blurRadius: 30,
      )
    ],
  );

  static BoxDecoration rounBlue = BoxDecoration(
    color: Color.fromARGB(25, 144, 13, 164),
    border: Border.all(
      width: 1,
      color: Color.fromARGB(255, 122, 187, 233),
    ),
    borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
  );
  static BoxDecoration greenCard = BoxDecoration(
    color: Color.fromARGB(14, 68, 137, 255),
    border: Border.all(
      width: 2,
      color: Color.fromARGB(255, 71, 236, 56),
    ),
    borderRadius: BorderRadius.all(Radius.circular(10)),
  );
  static BoxDecoration purplegradiant = BoxDecoration(
    border: Border.all(
      width: 1,
      color: Color.fromARGB(255, 122, 187, 233),
    ),
    borderRadius: BorderRadius.all(Radius.elliptical(50, 30)),
    gradient: LinearGradient(colors: [
      Color.fromARGB(255, 197, 7, 255),
      Color.fromARGB(255, 11, 141, 135)
    ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    boxShadow: [
      BoxShadow(
        color: Color.fromARGB(255, 82, 79, 79),
        offset: Offset(10, 20),
        blurRadius: 30,
      )
    ],
  );
}
