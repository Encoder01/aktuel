import 'dart:io';
import 'dart:typed_data';
import 'package:aktuel/AdmobService.dart';
import 'package:aktuel/Model/Urunler.dart';
import 'package:aktuel/data/sqflite_db_service.dart';
import 'package:animate_do/animate_do.dart';
import 'package:connectivity/connectivity.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:photo_view/photo_view.dart';

class SecondPage extends StatefulWidget {
  final Urunler urunler;
  bool nereden = false;

  SecondPage({
    Key key,
    @required this.urunler,
    @required this.nereden,
  }) : super(key: key);

  @override
  _SecondPageState createState() =>
      _SecondPageState(this.urunler, this.nereden);
}

class _SecondPageState extends State<SecondPage> {
  _SecondPageState(this._gelenUrunler, this._nereden);

  PageController controller = PageController(initialPage: 0, keepPage: true);
  int selected_item = 0;
  Urunler _gelenUrunler;
  bool _nereden;
  bool _favori = false;
  Color color;

  @override
  void initState() {
    if (!_nereden) {
      setState(() {
        _favori = false;
        color = Colors.grey;
      });
      DatabaseClient()
          .sayfaisaretleriniGetir()
          .then((value) => value.forEach((element) {
                if (element.resimS == _gelenUrunler.resimF[selected_item]) {
                  setState(() {
                    _favori = true;
                    color = Colors.red;
                  });
                }
              }));
    } else {
      setState(() {
        color = Colors.red;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _buildItemPicker() {
    return CupertinoPicker(
      itemExtent: 40.0,
      backgroundColor: CupertinoColors.white,
      onSelectedItemChanged: (index) {
        controller.jumpToPage(index);
      },
      children: new List<Widget>.generate(
          _nereden == true ? 1 : _gelenUrunler.resimF.length, (index) {
        return new Center(
          child: Text(
            "Sayfa ${index + 1}",
            style: TextStyle(fontSize: 22.0),
          ),
        );
      }),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white70,
        actions: [
          Padding(
              padding: EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: () {
                  setState(() {
                    if (_nereden) {
                      DatabaseClient().sayfaisaretiSil(_gelenUrunler.resimS);
                      color = Colors.grey;
                      Navigator.pop(context, true);
                    } else if (!_nereden && !_favori) {
                      Urunler urunekle = new Urunler(
                          altBilgi: _gelenUrunler.altBilgi,
                          Bilgi: _gelenUrunler.Bilgi,
                          Kategori: _gelenUrunler.Kategori,
                          Marka: _gelenUrunler.Marka,
                          tarihF: _gelenUrunler.tarihF,
                          resimS: _gelenUrunler.resimF[selected_item],);
                      DatabaseClient().sayfaisaretiEkle(urunekle).then((value) {
                        if(value%3==0){
                          InterstitialAd(
                            // Replace the testAdUnitId with an ad unit id from the AdMob dash.
                            // https://developers.google.com/admob/android/test-ads
                            // https://developers.google.com/admob/ios/test-ads
                            adUnitId: AdmobService().getinterstitialAdUnitId(),
                            listener: (MobileAdEvent event) {
                              print("InterstitialAd event is $event");
                            },
                          )..load()
                            ..show(
                              anchorType: AnchorType.bottom,
                              anchorOffset: 0.0,
                              horizontalCenterOffset: 0.0,
                            );
                        }
                      });

                      color = Colors.red;
                      _favori = true;

                    } else if (!_nereden && _favori) {
                      DatabaseClient()
                          .sayfaisaretiSil(_gelenUrunler.resimF[selected_item]);

                      setState(() {
                        color = Colors.grey;
                        _favori = false;
                      });
                    }
                  });
                },
                color: color,
                icon: Icon(
                  Icons.favorite,
                ),
              ))
        ],
        title: Text(
          _gelenUrunler.altBilgi,
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Bounce(
                    child: PageView.custom(
                      physics: BouncingScrollPhysics(),
                      controller: controller,
                      onPageChanged: (page) {
                        setState(() {
                          _favori = false;
                          color = Colors.grey;
                        });
                        DatabaseClient()
                            .sayfaisaretleriniGetir()
                            .then((value) => value.forEach((element) {
                                  if (element.resimS ==
                                      _gelenUrunler.resimF[selected_item]) {
                                    setState(() {
                                      _favori = true;
                                      color = Colors.red;
                                    });
                                  }
                                }));

                        int previousPage = page;
                        if (page != 0)
                          previousPage--;
                        else
                          previousPage = 2;
                        setState(() {
                          selected_item = page;
                        });
                      },
                      childrenDelegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return PhotoView(
                            imageProvider: NetworkImage(
                              _nereden
                                  ? _gelenUrunler.resimS
                                  : _gelenUrunler.resimF[index],
                            ),
                            minScale: PhotoViewComputedScale.contained * 1,
                            maxScale: PhotoViewComputedScale.covered * 2,
                            enableRotation: false,
                            backgroundDecoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,
                            ),
                          );
                        },
                        childCount: _nereden ? 1 : _gelenUrunler.resimF.length,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Sayfa ${selected_item + 1}/${_nereden?1:_gelenUrunler.resimF.length}",
                  style: TextStyle(
                    fontSize: 24,
                  ),
                )
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 50,
            child: Padding(
              padding: EdgeInsets.all(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !_nereden,
                    child: FlatButton(
                        child: Text(
                          "Başa Git",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () => controller.jumpToPage(0)),
                  ),
                  Visibility(
                    visible: !_nereden,
                    child: FlatButton(
                        child: Text("Son'a Git",
                            style: TextStyle(color: Colors.white)),
                        onPressed: () => controller.jumpToPage(
                            _nereden ? 1 : _gelenUrunler.resimF.length)),
                  ),
                  Visibility(
                    visible: !_nereden,
                    child: FlatButton(
                      child: Text("Sayfa seç",
                          style: TextStyle(color: Colors.white)),
                      //color: CupertinoColors.activeBlue,
                      onPressed: () async {
                        await showModalBottomSheet<int>(
                          context: context,
                          builder: (BuildContext context) {
                            return SizedBox(
                                height: 250,
                                child: _buildItemPicker());
                          },
                        );
                      },
                    ),
                  ),
                  FlatButton(
                      child: Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        var connectivityResult =
                        await (Connectivity().checkConnectivity());
                        if (connectivityResult == ConnectivityResult.none) {
                          Fluttertoast.showToast(
                              msg:
                              "Lütfen internet bağlantınızı kontrol ediniz",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        } else {
                          var request = await HttpClient().getUrl(Uri.parse(
                              _nereden
                                  ? _gelenUrunler.resimS
                                  : _gelenUrunler.resimF[selected_item]));
                          var response = await request.close();
                          Uint8List bytes =
                          await consolidateHttpClientResponseBytes(
                              response);
                          await Share.file(
                              'ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg',
                              text:
                              "E-Aktuel uygulaması ile paylaşıldı. Ücretsiz indir ve kullan. http://www.huzeyfedinc.com");
                        }
                      }),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.black, //Color(0xff0F0F0F),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                  )
                ]),
          ),
        ],
      ),
    );
  }
}
