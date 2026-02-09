/* import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class RingtoneFromUrl extends StatefulWidget {
  final String ringtoneUrl;
  RingtoneFromUrl({required this.ringtoneUrl});

  @override
  _RingtoneFromUrlState createState() => _RingtoneFromUrlState();
}

class _RingtoneFromUrlState extends State<RingtoneFromUrl> {
  bool _downloading = false;
  String? _localFilePath;

  Future<void> _downloadFile(String url) async {
    setState(() {
      _downloading = true;
    });
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/ringtone.mp3');
    await file.writeAsBytes(response.bodyBytes);
    setState(() {
      _downloading = false;
      _localFilePath = file.path;
    });
  }

  Future<void> _setRingtone() async {
    if (_localFilePath != null) {
      await FlutterRingtonePlayer.setRingtone(
          type: FlutterRingtonePlayerType.all,
          android: AndroidRingtoneManager(
              title: 'My Ringtone',
              uri: _localFilePath!,
              notification: true,
              alarm: true,
              ringtone: true),
          ios: IosRingtoneManager(
            soundName: _localFilePath!,
            vibration: true,
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    _downloadFile(widget.ringtoneUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Ringtone'),
      ),
      body: Center(
        child: _downloading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () => _setRingtone(),
                child: Text('Set Ringtone'),
              ),
      ),
    );
  }
}
 */