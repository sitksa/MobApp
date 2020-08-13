import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as Math;
import 'package:burgernook/lang/app_localizations.dart';
import 'package:burgernook/models/lockups.dart';
import 'package:burgernook/models/prices.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as Img;
import 'package:image_picker/image_picker.dart';
import 'package:burgernook/database/sharedPreferences.dart';
import 'package:burgernook/models/user/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';


//const domain = 'http://192.168.1.54/burger-nook/api';

const domain = 'http://ilc.ruu.mybluehost.me/burger-nook/api';

// const domain = 'http://ilc.ruu.mybluehost.me/burger-nook-v2/api';

const packageName = 'com.burgernook';

Color accentColor1 = Color(0xff0e1a34);
Color mainColor = Color(0xfff8ca0b);
Color accentColor = Color(0xfff23434);
Color accentColor4 = Color(0xff000000);
Color accentColor5 = Color(0xff2f3030);
Color accentColor6 = Color(0xff455a64);
Color accentW = Color(0xffededed);
Color colorG = Color(0xff8ac33f);

List<Lockups> globalLockups = List();
Lockups  globalLockup = Lockups();

bool isLogin = false;
bool isEmployee = false;
bool isOwner = false;
bool isDelivery = false;
bool isUser = false;
bool connected = false;
List basketItem = List();
User globalUser = User();
File gFile = File('');

List<User> deliveries = List();
User delivery = User();
List<User> employees = List();

getAllDeliveries() async {
  if (connected) {
    deliveries = await User().getAllUsersByJobID(jobID: '4');
    delivery = deliveries[0];
    print(deliveries.toList().toString());
  }
}

getAllEmployees() async {
  if (connected) {
    employees = await User().getAllUsersByJobID(jobID: '2');
  }
}

check() async {
  isLogin = await MySharedPreferences().isLogin();
  isEmployee = await MySharedPreferences().isEmployee();
  isOwner = await MySharedPreferences().isOwner();
  isDelivery = await MySharedPreferences().isDelivery();
  isUser = await MySharedPreferences().isUser();
  if (isLogin) {
    print('isLogin : $isLogin');
    globalUser = await MySharedPreferences().getUser();
  }
  // print(isLogin);
}

Widget emptyWidget() {
  return Container(
      child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Center(
        child: Image.asset(
          "assets/basket3.png",
          height: 200,
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  ));
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
                  gFile = _file;
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
                  gFile = _file;
                }),
          ],
        ),
      );
    },
  );
}

Future<File> getImageGallery() async {
  try {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 500, height: 500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    return compressImg;
  } catch (e) {
    return null;
  }
}

Future<File> getImageCamera() async {
  try {
    var imageFile = await ImagePicker.pickImage(source: ImageSource.camera);

    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;

    int rand = new Math.Random().nextInt(100000);

    Img.Image image = Img.decodeImage(imageFile.readAsBytesSync());
    Img.Image smallerImg = Img.copyResize(image, width: 500, height: 500);

    var compressImg = new File("$path/image_$rand.jpg")
      ..writeAsBytesSync(Img.encodeJpg(smallerImg, quality: 85));

    return compressImg;
  } catch (e) {
    return null;
  }
}

Future<String> findAddresses({double latitude, double longitude}) async {
  try {
    final coordinates = new Coordinates(latitude, longitude);
    List<Address> addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print("${first.featureName} : ${first.addressLine}");
    //print("${addresses[0].addressLine}");

    /*for (var item in addresses) {
    print("${item.addressLine}");
  }*/
    return addresses[0].addressLine;
  } catch (e) {
    return '';
  }
}

Future<void> ackAlert(
    {BuildContext context,
    String title,
    String content,
    bool antherButton = false,
    String textButton,
    String textButton1,
    Function fun}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("$title",style: TextStyle(fontFamily: ""),),
        content: Text("$content",style: TextStyle(fontFamily: ""),),
        actions: <Widget>[
          FlatButton(
            child: Text("$textButton",style: TextStyle(fontFamily: ""),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          antherButton
              ? FlatButton(
                  child: Text(textButton1,style: TextStyle(fontFamily: ""),),
                  onPressed: fun,
                )
              : Container(),
        ],
      );
    },
  );
}

Future<void> notConnected({BuildContext context}) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('الانترنت'),
            Icon(
              Icons.signal_wifi_off,
            ),
          ],
        ),
        content: Text('لا يوجد اتصال بالانترنت'),
        actions: <Widget>[
          FlatButton(
            child: Text('الغاء'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> done({BuildContext context}) {
  return showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 100,
              width: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: mainColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.done,
                color: Colors.white,
                size: 70,
              ),
            ),
            Text(
              AppLocalizations.of(context).translate('Thanks for registering'),
              textAlign: TextAlign.center,
              style: TextStyle(color: mainColor, fontSize: 25),
            ),
            Text(
              AppLocalizations.of(context).translate('You can now login'),
              textAlign: TextAlign.center,
              style: TextStyle(color: mainColor),
            ),
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(  AppLocalizations.of(context).translate('ok')),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

shareApp() async {
  var appUrl = '';
  if (Platform.isAndroid) {
    appUrl = "https://play.google.com/store/apps/details?id=$packageName";
  } else if (Platform.isIOS) {
    appUrl = "https://apps.apple.com/us/app/zoom-cloud-meetings/id546505307";
  }
  Share.share(appUrl);
}

launchMaps({latitude, longitude}) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
//  String googleUrl = 'comgooglemaps://?center=$latitude,$longitude';
  String appleUrl = 'https://maps.apple.com/?sll=$latitude,$longitude';
  if (await canLaunch("comgooglemaps://")) {
    print('launching com googleUrl');
    await launch(googleUrl);
  } else if (await canLaunch(appleUrl)) {
    print('launching apple url');
    await launch(googleUrl);
  } else {
    throw 'Could not launch url';
  }
}

launchURL(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    //throw 'Could not launch $url';
  }
}

progress({BuildContext context, bool isLoading}) {
  if (isLoading) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          content: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            ),
          ),
        );
      },
    );
  } else {
    Navigator.pop(context);
  }
}

Widget myCircularProgressIndicator() {
  return Center(
      child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
  ));
}

Widget notConnectedWidget({context, Function fun}) {
  return InkWell(
    onTap: fun,
    child: Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/not_connected.png'),
          Text('Internet connection was interrupted'),
          Container(
            margin: EdgeInsets.symmetric(vertical: 30, horizontal: 50),
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xffFF6969),
              borderRadius: BorderRadius.circular(100),
            ),
            child: InkWell(
              onTap: () async {
                // connected =await isConnected();
              },
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        'try again',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Future<bool> setTokenMSG({
  String parentId,
  String token,
}) async {
  http.Response response =
      await http.post('$domain/app/student/token_msg_update.php', body: {
    "parent_id": parentId,
    "token_msg": token,
  });
  var utf = utf8.decode(response.bodyBytes);
  var data = json.decode(utf);
  print('........setTokenMSG');
  print(data);
  if (data['status']) {
    return true;
  }
  return false;
}
