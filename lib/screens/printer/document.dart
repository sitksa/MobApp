import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart' as fw;
import 'package:burgernook/models/order.dart';
import 'package:burgernook/models/product.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';

import 'example_widgets.dart';

Future<Document> generateDocument(PdfPageFormat format) async {
  final Document pdf = Document(title: 'My Résumé', author: 'David PHAM-VAN');

  final PdfImage profileImage = kIsWeb
      ? null
      : await pdfImageFromImageProvider(
          pdf: pdf.document,
          image: const fw.NetworkImage(
              'https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&s=200'),
          onError: (dynamic exception, StackTrace stackTrace) {
            print('Unable to download image');
          });

  final PageTheme pageTheme = myPageTheme(format);

  pdf.addPage(Page(
    pageTheme: pageTheme,
    build: (Context context) => Row(children: <Widget>[
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
            Container(
                padding: const EdgeInsets.only(left: 30, bottom: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Parnella Charlesbois',
                          textScaleFactor: 2,
                          style: Theme.of(context)
                              .defaultTextStyle
                              .copyWith(fontWeight: FontWeight.bold)),
                      Padding(padding: const EdgeInsets.only(top: 10)),
                      Text('Electrotyper',
                          textScaleFactor: 1.2,
                          style: Theme.of(context).defaultTextStyle.copyWith(
                              fontWeight: FontWeight.bold, color: green)),
                      Padding(padding: const EdgeInsets.only(top: 20)),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('568 Port Washington Road'),
                                  Text('Nordegg, AB T0M 2H0'),
                                  Text('Canada, ON'),
                                ]),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('+1 403-721-6898'),
                                  UrlText('p.charlesbois@yahoo.com',
                                      'mailto:p.charlesbois@yahoo.com'),
                                  UrlText('wholeprices.ca',
                                      'https://wholeprices.ca'),
                                ]),
                            Padding(padding: EdgeInsets.zero)
                          ]),
                    ])),
            Category(title: 'Work Experience'),
            Block(title: 'Tour bus driver'),
            Block(title: 'Logging equipment operator'),
            Block(title: 'Foot doctor'),
            Category(title: 'Education'),
            Block(title: 'Bachelor Of Commerce'),
            Block(title: 'Bachelor Interior Design'),
          ])),
      Container(
        height: double.infinity,
        width: 2,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        color: green,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ClipOval(
              child: Container(
                  width: 100,
                  height: 100,
                  color: lightGreen,
                  child: profileImage == null
                      ? Container()
                      : Image(profileImage))),
          Column(children: <Widget>[
            Percent(size: 60, value: .7, title: Text('Word')),
            Percent(size: 60, value: .4, title: Text('Excel')),
          ]),
          QrCodeWidget(data: 'Parnella Charlesbois', size: 60),
        ],
      )
    ]),
  ));
  return pdf;
}

Future<Document> generateDocument2(PdfPageFormat format, Order order) async {
  TextStyle textStyle = TextStyle(
    color: black,
    fontSize: 10,
  );
  final Document pdf = Document(title: 'My Résumé', author: 'David PHAM-VAN');

  final PageTheme pageTheme = myPageTheme(format);
  final PdfImage profileImage = kIsWeb
      ? null
      : await pdfImageFromImageProvider(
          pdf: pdf.document,
          image: const fw.AssetImage("assets/logo1.png"),
          onError: (dynamic exception, StackTrace stackTrace) {
            print('Unable to download image');
          });
  pdf.addPage(MultiPage(
      pageFormat: //PdfPageFormat.roll80,
          PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
      crossAxisAlignment: CrossAxisAlignment.center,
      build: (Context context) => <Widget>[
            Container(
              //  color: green,
              width: 200,
              child: Column(children: <Widget>[
                ClipOval(
                    child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        height: 80,
                        alignment: Alignment.center,
                        color: lightT,
                        child: profileImage == null
                            ? Container()
                            : Container(
                                child: Image(
                                  profileImage,
                                ),
                              ))),
                Container(
                    alignment: Alignment.center,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Name',
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    )),
                                Text('Number',
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    )),
                                Text('Price',
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    )),
                              ]),
                          Container(
                            margin: EdgeInsets.only(bottom: 10, top: 5),
                            height: 1,
                            color: black,
                          ),
                          Column(
                            children: order.productsList.map((Product product) {
                              return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                        child: Text('${product.nameAr}',
                                            style: textStyle),
                                        width: 100),
                                    Expanded(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                          Text('${product.count}',
                                              style: textStyle),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text('${product.price}',
                                                    style: textStyle),
                                                Text(' x1',
                                                    style: TextStyle(
                                                      fontSize: 8,
                                                    )),
                                              ]),
                                        ])),
                                  ]);
                            }).toList(),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10, bottom: 5),
                            height: 1,
                            color: black,
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text('Total',
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    )),
                                Text('${order.p_invoice}',
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    )),
                              ]),
                          Container(
                            margin: EdgeInsets.only(top: 30, bottom: 10),
                            height: 1,
                            color: black,
                          ),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Date : ${order.date}',
                                    style: TextStyle(fontSize: 8)),
                                Text('Code : ${order.id}',
                                    style: TextStyle(fontSize: 8)),
                              ]),
                          Container(
                            height: 15,
                          ),
                          Text('Mansourah, Ad Daqahliyah, Egypt',
                              style: TextStyle(fontSize: 8)),
                          Text('050 2949020 / 01004301554',
                              style: TextStyle(fontSize: 8)),
                        ]))
              ]),
            )
          ]));
  return pdf;
}
