import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/sliderModel.dart';
import 'package:burgernook/screens/owner/sliders/addSlid.dart';

class SlidersScreen extends StatefulWidget {
  @override
  _SlidersScreenScreeState createState() => _SlidersScreenScreeState();
}

class _SlidersScreenScreeState extends State<SlidersScreen> {
  List<SliderModel> sliders = List();
  bool loading = true;

  _getSliderData() async {
    if (connected) {
      setState(() {
        loading = true;
      });
      sliders = await fetchSliderData();
      setState(() {
        loading = false;
      });
    }
  }

  _getDeleteSlidImage(SliderModel sliderModel) async {
    progress(context: context, isLoading: true);
    bool result = await sliderModel.deleteSlidImage();
    if (result) {
      sliders.remove(sliderModel);
      setState(() {});
    } else {}
    progress(context: context, isLoading: false);
  }

  @override
  void initState() {
    super.initState();
    _getSliderData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text("السليدر"),
      ),
      body: loading
          ? myCircularProgressIndicator()
          : ListView(
              children: sliders.map((SliderModel sliderModel) {
              return Card(
                  child: Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height / 4,
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          '$domain/slider/uploads/${sliderModel.name}',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _getDeleteSlidImage(sliderModel);
                        }),
                  )
                ],
              ));
            }).toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
                  context, MaterialPageRoute(builder: (context) => AddSlid()))
              .then((value) {
            if (value != null) {
              setState(() {
                sliders.insert(0, value);
              });
            }
          });
        },
        backgroundColor: accentColor,
        child: Icon(Icons.add),
      ),
    );
  }
}
