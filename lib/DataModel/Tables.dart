// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class ItemData {
  String Category = '';
  String Class = '';
  int savedIndex = 0;
  String alboumName = '';
  String songerName = '';
  String name = '';
  String songUrl = '';
  String songMP3Url = '';
  String imageUrl = '';
  String url = '';
  ItemData({
    Category,
    Class,
    savedIndex,
    alboumName,
    songerName,
    name,
    songUrl,
    songMP3Url,
    imageUrl,
    url,
  });
  static ItemData itemDataAdding(
      {String alboumName = '',
      String songerName = '',
      String name = '',
      String songUrl = '',
      String songMP3Url = '',
      String imageUrl = '',
      String url = '',
      Category = '',
      Class = '',
      savedIndex = 0}) {
    ItemData temp = ItemData();
    temp.alboumName = alboumName;
    temp.songerName = songerName;
    temp.name = name;
    temp.songUrl = songUrl;
    temp.songMP3Url = songMP3Url;
    temp.imageUrl = imageUrl;
    temp.url = url;
    return temp;
  }

  ItemData copyWith({
    String? Category,
    String? Class,
    int? savedIndex,
    String? alboumName,
    String? songerName,
    String? name,
    String? songUrl,
    String? songMP3Url,
    String? imageUrl,
    String? url,
  }) {
    return ItemData(
      Category: Category ?? this.Category,
      Class: Class ?? this.Class,
      savedIndex: savedIndex ?? this.savedIndex,
      alboumName: alboumName ?? this.alboumName,
      songerName: songerName ?? this.songerName,
      name: name ?? this.name,
      songUrl: songUrl ?? this.songUrl,
      songMP3Url: songMP3Url ?? this.songMP3Url,
      imageUrl: imageUrl ?? this.imageUrl,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'Category': Category,
      'Class': Class,
      'savedIndex': savedIndex,
      'alboumName': alboumName,
      'songerName': songerName,
      'name': name,
      'songUrl': songUrl,
      'songMP3Url': songMP3Url,
      'imageUrl': imageUrl,
      'url': url,
    };
  }

  factory ItemData.fromMap(Map<String, dynamic> map) {
    return ItemData(
      Category: map['Category'] as String,
      Class: map['Class'] as String,
      savedIndex: map['savedIndex'] as int,
      alboumName: map['alboumName'] as String,
      songerName: map['songerName'] as String,
      name: map['name'] as String,
      songUrl: map['songUrl'] as String,
      songMP3Url: map['songMP3Url'] as String,
      imageUrl: map['imageUrl'] as String,
      url: map['url'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ItemData.fromJson(String source) =>
      ItemData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ItemData(Category: $Category, Class: $Class, savedIndex: $savedIndex, alboumName: $alboumName, songerName: $songerName, name: $name, songUrl: $songUrl, songMP3Url: $songMP3Url, imageUrl: $imageUrl, url: $url)';
  }

  @override
  bool operator ==(covariant ItemData other) {
    if (identical(this, other)) return true;
    return other.Category == Category &&
        other.Class == Class &&
        other.savedIndex == savedIndex &&
        other.alboumName == alboumName &&
        other.songerName == songerName &&
        other.name == name &&
        other.songUrl == songUrl &&
        other.songMP3Url == songMP3Url &&
        other.imageUrl == imageUrl &&
        other.url == url;
  }

  @override
  int get hashCode {
    return Category.hashCode ^
        Class.hashCode ^
        savedIndex.hashCode ^
        alboumName.hashCode ^
        songerName.hashCode ^
        name.hashCode ^
        songUrl.hashCode ^
        songMP3Url.hashCode ^
        imageUrl.hashCode ^
        url.hashCode;
  }
}

class SongData {
  String singerName = '';
  String songName = '';
  String mp3Url = '';
  String imageurl = '';
  SongData({
    singerName,
    songName,
    mp3Url,
    imageurl,
  });
}

class AlboumData {
  String alboumUrl = '';
  String imageurl = '';
  String alboumName = '';
  List<SongData> alboumdata = [];
  AlboumData({
    alboumUrl,
    imageurl,
    alboumName,
    alboumdata,
  });
}

class SingerData {
  List<AlboumData> alboums = [];
  String singerName = '';
  String alboumsUrl = '';
  SingerData({
    alboums,
    singerName,
    alboumsUrl,
  });
}
