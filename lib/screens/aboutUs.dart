import 'package:burgernook/lang/app_localizations.dart';
import 'package:flutter/material.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      AppLocalizations.of(context).locale.languageCode == "en"
                          ? "assets/abouts-en.jpeg"
                          : "assets/abouts-ar.jpeg"),
                  fit: BoxFit.fill)),
        ),
        Align(
          alignment: AppLocalizations.of(context).locale.languageCode == "en"
              ? Alignment.topLeft
              : Alignment.topRight,
          child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
              child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  })),
        )
      ],
    ));
  }
}
