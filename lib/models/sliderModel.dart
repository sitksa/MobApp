import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:burgernook/database/globle.dart';
import 'package:path/path.dart';

class SliderModel {
  String id;
  String name;
  File file = File('');
  String action;
  String content;

  SliderModel({this.id, this.name, this.file, this.action, this.content});

  factory SliderModel.fromJson(Map json) {
    return SliderModel(
      id: json['slider_id'],
      name: json['image_name'],
      action: json['action'],
      content: json['content'],
    );
  }

  Future<bool> deleteSlidImage() async {
    http.Response response =
        await http.post("$domain/slider/delete.php", body: {
      "slider_id": this.id,
    });
    var res = json.decode(response.body);
    // print(res);
    if (!res['error']) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> uploadSlidImage() async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(this.file.openRead()));
    var length = await this.file.length();
    var uri = Uri.parse("$domain/slider/create.php");

    var request = new http.MultipartRequest("POST", uri);

    var multipartFile = new http.MultipartFile("image", stream, length,
        filename: basename(this.file.path));
    request.fields['image_name'] = "image_name";
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      this.name = basename(this.file.path);
      print("Image Uploaded");
      return true;
    } else {
      print("Upload Failed");
      return false;
    }
  }
}

Future<List<SliderModel>> fetchSliderData() async {
  List<SliderModel> sliders = List();
  http.Response response =
      await http.post("$domain/slider/read.php", body: {"slider": "slider"});
  var res = json.decode(response.body);
  print(res);
  List data = res['slider'];
  for (var item in data) {
    sliders.insert(0, SliderModel.fromJson(item));
  }
  return sliders;
}
