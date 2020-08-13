import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:burgernook/database/globle.dart';
import 'package:burgernook/models/sliderModel.dart';

class HomeSlider extends StatefulWidget {
  @override
  _SliderState createState() => _SliderState();
}

class _SliderState extends State<HomeSlider> {
  List<SliderModel> sliders = List();
  bool isLading = true;

  _getSlider() async {
    if (connected) {
      sliders = await fetchSliderData();
      isLading = false;
      if (this.mounted) {
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSlider();
  }

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return isLading
        ? _ladingWidget()
        : sliders.isEmpty
            ? Container(
                height: 200,
                alignment: Alignment.center,
                child: Text("فارغ"),
              )
            : Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                CarouselSlider(
                  onPageChanged: (index) {
                    setState(() {
                      _current = index;
                    });
                  },
                  items: sliders.map((SliderModel sliderModel) {
                    return InkWell(
                      onTap: () {
                        print(sliderModel.content);
                     /*   if (sliderModel.action.isNotEmpty) {
                          switch (sliderModel.action) {
                            case "link":
                              launchURL(sliderModel.content);
                              break;
                          }
                        }*/
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(bottom: 5.0, left: 5.0, right: 5.0),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(50),
                              bottomRight: Radius.circular(50)),
                          image: DecorationImage(
                            image: NetworkImage(
                              '$domain/slider/uploads/${sliderModel.name}',
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  height: 220,
                  // MediaQuery.of(context).size.height / 3.5,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.9,
                  initialPage: 0,
                  enableInfiniteScroll: true,
                  reverse: false,
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  pauseAutoPlayOnTouch: Duration(seconds: 10),
                  // enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: sliders.map((url) {
                    int index = sliders.indexOf(url);
                    return Container(
                      width: 8.0,
                      height: 8.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _current == index
                            ? mainColor//Color.fromRGBO(0, 0, 0, 0.9)
                            : Color(0xff2f3030)//Color.fromRGBO(0, 0, 0, 0.4),
                      ),
                    );
                  }).toList(),
                ),
              ]);
  }

  Widget _ladingWidget() {
    return CarouselSlider(
      items: [
        Container(
            color: Colors.grey.withOpacity(.3),
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: myCircularProgressIndicator()),
        Container(
            color: Colors.grey.withOpacity(.3),
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: myCircularProgressIndicator()),
        Container(
            color: Colors.grey.withOpacity(.3),
            margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: myCircularProgressIndicator()),
      ],
      height: 200,
      // MediaQuery.of(context).size.height / 3.5,
      aspectRatio: 16 / 9,
      viewportFraction: 0.8,
      initialPage: 0,
      enableInfiniteScroll: true,
      reverse: false,
      autoPlay: true,
      autoPlayInterval: Duration(seconds: 3),
      autoPlayAnimationDuration: Duration(milliseconds: 800),
      autoPlayCurve: Curves.fastOutSlowIn,
      pauseAutoPlayOnTouch: Duration(seconds: 10),
      enlargeCenterPage: true,
      scrollDirection: Axis.horizontal,
    );
  }
}
