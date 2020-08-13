/*
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessagingWidget extends StatefulWidget {
  @override
  _MessagingWidgetState createState() => _MessagingWidgetState();
}

class _MessagingWidgetState extends State<MessagingWidget> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String data = '';
  SharedPreferences _SharedPreferences;

  _getToken() async {
    String token = await _firebaseMessaging.getToken();
    print(token);
  }

  setS(value) async {
    _SharedPreferences = await SharedPreferences.getInstance();
    _SharedPreferences.setString("data", value);
    setState(() {});
  }

  getD() async {
    _SharedPreferences = await SharedPreferences.getInstance();
    String _data = await _SharedPreferences.get("data");
    if (_data != null) {
      data = _data;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _getToken();
    message();
    initializeNotifications();
    getD();
  }

  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initializeNotifications() async {
    var initializeAndroid = AndroidInitializationSettings('ic_launcher');

    var initializeIOS = IOSInitializationSettings();
    var initSettings = InitializationSettings(initializeAndroid, initializeIOS);
    await localNotificationsPlugin.initialize(initSettings);
    localNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
  }

  Future singleNotification(
      DateTime datetime, String message, String subtext, int hashcode,
      {String sound}) async {
    var androidChannel = AndroidNotificationDetails(
      'channel-id',
      'channel-name',
      'channel-description',
      importance: Importance.Max,
      priority: Priority.Max,
    );

    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    localNotificationsPlugin.schedule(
        hashcode, message, subtext, datetime, platformChannel,
        payload: hashcode.toString());
  }

  _pushNotification({title, body, id}) async {
    DateTime now = DateTime.now().toUtc().add(
          Duration(seconds: 1),
        );

    await singleNotification(
      now,
      title,
      body,
      id,
    );
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  message() {
    _firebaseMessaging.configure(
      //onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        data += "\n";
        data += "\n";
        data += "\n";
        data += "\n";
        data += "onMessage: $message";
        setS("\n onMessage: $message");
        // int d = Random().nextInt(9999);
        _pushNotification(title: "adsfadsfa", body: "dsfdsafa", id: 1);
        setState(() {});
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        data += "\n";
        data += "\n";
        data += "\n";
        data += "onLaunch: $message";
        setS("\n onLaunch: $message");
        int d = Random().nextInt(9999);
        _pushNotification(title: "adsfadsfa", body: "dsfdsafa", id: d);
        setState(() {});
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        data += "\n";
        data += "\n";
        data += "\n";
        data += "onResume: $message";
        setS("\n onResume: $message");
        int d = Random().nextInt(9999);
        _pushNotification(title: "adsfadsfa", body: "dsfdsafa", id: d);
        setState(() {});
      },
    );

    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging
        .requestNotificationPermissions(const IosNotificationSettings(
      sound: true,
      badge: true,
      alert: true,
    ));
  }

  @override
  Widget build(BuildContext context) => Container(
        child: SingleChildScrollView(child: Text("$data")),
      );
}
*/
