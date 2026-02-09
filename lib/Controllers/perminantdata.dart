import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';
import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class PerminantData extends GetxService {
  List<AudioSource> alboumPlayList = [];
  var playlist = ConcatenatingAudioSource(
    useLazyPreparation: true,
    shuffleOrder: DefaultShuffleOrder(),
    children: [],
  );
  ConcatenatingAudioSource buildPlayList(List<ItemData> data, bool fromurl) {
    playlist.clear();

    if (fromurl) {
      int i = 0;
      data.forEach((element) {
        Map<String, dynamic> data = element.toMap();
        alboumPlayList.add(
          AudioSource.uri(Uri.parse(element.songMP3Url),
              tag: MediaItem(
                  id: i.toString(),
                  title: data['name'],
                  album: data['alboumName'],
                  artist: data['songerName'],
                  displayDescription: data['songMP3Url'],
                  displayTitle: data['imageUrl'])),
        );
        i++;
      });
    } else {
      int i = 0;
      data.forEach((element) {
        Map<String, dynamic> data = element.toMap();
        alboumPlayList.add(
          AudioSource.file(element.songMP3Url,
              tag: MediaItem(
                id: i.toString(),
                title: data['name'],
                album: data['alboumName'],
              )),
        );
      });
    }
    playlist = ConcatenatingAudioSource(
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder(),
      children: alboumPlayList,
    );
    ;
    return playlist;
  }
}
