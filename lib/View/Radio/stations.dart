import 'package:Khotab_Encyclopedia/Controllers/DataProvider.dart';
import 'package:Khotab_Encyclopedia/DataModel/Tables.dart';

class StationsData {
  static List<ItemData> loadstations() {
    List<ItemData> output = [];
    stations.forEach((country) {
      String countryName = country['country'];
      List countryData = country['data'];
      countryData.forEach((element) {
        ItemData data = ItemData();
        data.alboumName = countryName;
        data.imageUrl = element['logo'];
        data.songMP3Url = element['url'];
        data.name = element['name'];
        output.add(data);
      });
    });
    DataProvider.alboum = output;
    return output;
  }

  static List<Map<String, dynamic>> stations = [
    {
      'country': 'Algria',
      'data': [
        {
          "url": "http://dedi.radio-coran.net:8000/live.mp3",
          "name": "Radio Coran",
          "logo": "http://cdn-radiotime-logos.tunein.com/s0q.png"
        },
        {
          "url":
              "http://tiaret.ice.infomaniak.ch/14.aac?type=.flv&ua=Infomaniak%20Flash%20Player%20v2&",
          "name": "Radio Tiaret",
          "logo": "http://cdn-radiotime-logos.tunein.com/s122491q.png"
        },
        {
          "name": "JIL FM",
          "url": "http://jil-fm.ice.infomaniak.ch/jilfm.aac",
          "logo": "http://cdn-radiotime-logos.tunein.com/s154053q.png"
        },
        {
          "name": "Alger Ch 3",
          "url": "http://ch3.ice.infomaniak.ch/ch3-64.aac",
          "logo": "http://cdn-radiotime-logos.tunein.com/s25411q.png"
        },
        {
          "name": "Radio Tlemcen",
          "logo": "http://cdn-radiotime-logos.tunein.com/s16039q.png",
          "url": "http://tlemcen.ice.infomaniak.ch/13.aac"
        },
        {
          "url": "http://ch1.ice.infomaniak.ch/ch1-64.aac",
          "name": "Alger Chaine 1",
          "logo": "http://cdn-radiotime-logos.tunein.com/s16034q.png"
        }
      ]
    },
    {
      'country': 'Bahrin',
      'data': [
        {
          "name": "104.2 YOUR FM",
          "logo": "http://cdn-radiotime-logos.tunein.com/s178828q.png",
          "url": "http://s9.voscast.com:8464/;"
        }
      ]
    },
    {
      'country': 'Egypt',
      'data': [
        {
          "name": "Al-Aghani",
          "logo": "http://cdn-radiotime-logos.tunein.com/s138838q.png",
          "url": "http://s5.myradiostream.com:12004/;"
        },
        {
          "name": "Radio 9090",
          "url": "http://9090streaming.mobtada.com/9090FMEGYPT",
          "logo": "http://cdn-radiotime-logos.tunein.com/s210036q.png"
        },
        {
          "url": "http://37.187.79.93:9230/;",
          "name": "Nagham FM",
          "logo": "http://cdn-radiotime-logos.tunein.com/s0q.png"
        },
        {
          "url": "http://live.radiomasr.net:8060/RADIOMASR",
          "name": "Radio Masr",
          "logo": "http://cdn-radiotime-logos.tunein.com/s245277q.png"
        },
        {
          "url":
              "http://ice31.securenetsystems.net/NILE?&playSessionID=4AF0EE2A-0FA9-A1AE-D84BD2CD8AD93BDD",
          "name": "Nile FM",
          "logo": "http://cdn-radiotime-logos.tunein.com/s50447q.png"
        },
        {
          "name": "Nogoum FM",
          "logo": "http://cdn-radiotime-logos.tunein.com/s65628q.png",
          "url":
              "http://ice31.securenetsystems.net/NOGOUM?&playSessionID=4A7D635A-A743-19B6-2767AF2EB034FD70"
        },
        {
          "name": "El Gouna Radio",
          "logo": "http://cdn-radiotime-logos.tunein.com/s110270q.png",
          "url": "http://82.201.132.237:8000/;"
        },
        {
          "name": "Sound of Sakia Radio",
          "logo": "http://cdn-radiotime-logos.tunein.com/s134908q.png",
          "url": "http://38.96.148.18:4896/live"
        },
        {
          "logo": "http://cdn-radiotime-logos.tunein.com/s141807q.png",
          "name": "Radio Vision Egypt",
          "url": "http://streaming.radionomy.com/RADIORANCHERASCRISTIANAS"
        },
        {
          "logo": "http://cdn-radiotime-logos.tunein.com/s130692q.png",
          "name": "Radio Hits",
          "url": "http://rhstrm8.twesto.com:6365/stream2.nsv"
        },
        {
          "logo": "http://cdn-radiotime-logos.tunein.com/s143123q.png",
          "name": "Mega FM 92.7",
          "url":
              "http://mgstrm9.twesto.com:7281/megafmtw.flv?file=livestream.flv&start=0&id=mpl&client=FLASH%20LNX%2016,0,0,305&version=4.2.90&width=181"
        }
      ]
    }
  ];
}
