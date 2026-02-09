import 'dart:convert';
import 'package:appwrite/appwrite.dart';

import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/Controllers/playercontroller.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:Khotab_Encyclopedia/DataModel/enum.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AppWrite{

  Client client = Client();
  String endPoint='https://cloud.appwrite.io/v1';
  String  projectID='64bd83ce610b040fb2d9';
  String databaseId='64bd8503616f3be8a06b';
  String collectionId='64bd85398508b7eee0e3';
  String documentId='64bd8ab41940ef175677';

  addDatatodocumentAPI(){
    String posting='${endPoint}/databases/${databaseId}/collections/${collectionId}/documents';
  }
intialization() async {
 client
        .setEndpoint(endPoint)
        .setProject(projectID)
        .setSelfSigned(status: true);
        print ('intialization done');
Map<String, String> header={'Content-Type': 'application/json',
'X-Appwrite-Project': '$projectID',};
 Map<String, String> body = {
  "email": "enmohsen20111975@gmail.com",
  "password": "M2y@01021064328"};

      http.Response auth =await http.post(Uri.parse('/v1/account/sessions/email HTTP/1.1'),headers:header,body:body);
}

 addData(Map data){
  Databases databases = Databases(client);
  Future result = databases.createDocument(
    databaseId: databaseId,
    collectionId: collectionId,
    documentId: ID.unique(),// for auto generate ID 
    data: data,
  );
  print ('request in progress......... ');
  result
    .then((response) {
      print(response);// 201 == ok 
    }).catchError((error) {
      print(error.response);
  });
 }
}