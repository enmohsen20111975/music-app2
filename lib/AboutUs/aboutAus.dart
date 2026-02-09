import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Aboutus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Card(
                child: AutoSizeText(
                  '''We are a group of programmers from Egypt.

working to increase Arab programming production.

We hope you will help us by increasing downloads and rating our applications.



Our link on Google Play is below.

 ''',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )),
          TextButton(
            onPressed: () {
              openMyAppsonGooglePlay();
            },
            child: Image.asset(
              'assets/MEDIA/googlePlay.png',
              height: 120,
              width: 140,
            ),
          ),
        ],
      ),
    );
  }

  void openMyAppsonGooglePlay() async {
    String allapp =
        'https://play.google.com/store/search?q=pub%3AM2Y%20Developer%27s&c=apps&hl=en_US&gl=US';
    if (!await launch(allapp)) throw 'Could not launch $allapp';
  }
}
