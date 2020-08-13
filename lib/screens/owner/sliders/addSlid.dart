import 'dart:io';

import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/sliderModel.dart';

class AddSlid extends StatefulWidget {
  @override
  _AddSlidScreeState createState() => _AddSlidScreeState();
}

class _AddSlidScreeState extends State<AddSlid> {
  var height;
  var width;
  SliderModel sliderModel = SliderModel();

  void _seSlider() async {
    progress(context: context, isLoading: true);
    bool result = await sliderModel.uploadSlidImage();
    progress(context: context, isLoading: false);
    if (result) {
      Navigator.pop(context, sliderModel);
      print(">>>>>>>>>>>> Done");
    } else {
      print("Not >>>>> Done");
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("اضافة سليد"),
      ),
      body: ListView(
        children: <Widget>[
          InkWell(
            onTap: () async {
              await chooseImage(context);
            },
            child: sliderModel.file == null
                ? Container(
                    height: MediaQuery.of(context).size.height / 3,
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
                    child: Image.asset("assets/frame.png"))
                : Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                            height: MediaQuery.of(context).size.height / 3,
                            margin: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 50,
                            ),
                            child: Image.file(sliderModel.file)),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                sliderModel.file = File('');
                              });
                            }),
                      )
                    ],
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(
              onPressed: _seSlider,
              color: accentColor,
              child: Text(
                'اضافة',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> chooseImage(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              FlatButton.icon(
                  label: Text('المعرض'),
                  icon: Icon(
                    Icons.image,
                    size: 35,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    File _file = await getImageGallery();
                    if (_file != null) {
                      sliderModel.file = _file;
                      print(sliderModel.file.path);
                      setState(() {});
                    }
                  }),
              FlatButton.icon(
                  label: Text('الكاميرة'),
                  icon: Icon(
                    Icons.camera_alt,
                    size: 35,
                  ),
                  onPressed: () async {
                    Navigator.pop(context);
                    File _file = await getImageCamera();
                    if (_file != null) {
                      sliderModel.file = _file;
                      print(sliderModel.file.path);
                      setState(() {});
                    }
                  }),
            ],
          ),
        );
      },
    );
  }
}
