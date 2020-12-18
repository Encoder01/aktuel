import 'package:aktuel/AdmobService.dart';
import 'package:aktuel/Model/Alisveris.dart';
import 'package:aktuel/data/sqflite_db_service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';
class AlisverisListesi extends StatefulWidget {
  @override
  _AlisverisListesiState createState() => _AlisverisListesiState();
}

class _AlisverisListesiState extends State<AlisverisListesi> {
  List<alisveris> _list;
  bool isButtonActive;
  var uuid = Uuid();
  DatabaseClient db;
  ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    isButtonActive = true;
    _controller.addListener(() {
      if (_controller.positions.length > 0 &&
          _controller.position.extentAfter == 0.0) {
       if(isButtonActive){ setState(() {
          isButtonActive = false;
        });}
      } else {
        if(!isButtonActive){setState(() {
          isButtonActive = true;
        });}
      }
    });
    _list = List();
    DatabaseClient db = DatabaseClient();
    db.alisverisListesi().then((value) =>
        value.forEach((element) {
          _list.add(element);
        }));
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(backgroundColor: Colors.white70,
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: Text(
                  "Alışveriş Listem",
                  style: TextStyle(fontSize: 20,color: Colors.black),
                )),
          ),),
        floatingActionButton: !isButtonActive ? null : FloatingActionButton(
          heroTag: "alisveris",
          onPressed: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    content: Stack(
                      overflow: Overflow.visible,
                      children: <Widget>[
                        Positioned(
                          right: -40.0,
                          top: -40.0,
                          child: InkResponse(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.close),
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  autofocus: true,
                                  validator: (value) {
                                    if (value.isEmpty)
                                      return null;
                                    else {
                                      _urunEkle(new alisveris(
                                          item: value, id: uuid.v1()));
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RaisedButton(
                                  child: Text("Ekle"),
                                  onPressed: () {
                                    if (_formKey.currentState.validate()) {
                                      setState(() {
                                        _formKey.currentState.save();
                                      });
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Icon(Icons.add),
        ),
        body: Container(
          margin: EdgeInsets.all(5.0),
          padding: EdgeInsets.all(5.0),
          child: Container(
            child: _list.isEmpty?
            Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 150,
                      height: 150,
                      child: SvgPicture.asset("assets/images/to-do-list.svg")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Hemen Yeni Listenizi Oluşturun",style: TextStyle(fontSize: 20)),
                )
              ],
            )):
            ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _controller,
                itemCount: _list.length,
                itemBuilder: (context, index) {
                  return Container(
                    child: (Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              ListTile(
                                title: Text(_list[index].item),
                                leading: _list[index].check == 0?null:IconButton(
                                  icon: Icon(
                                    Icons.cancel,
                                    color: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    _urunSil(_list[index].id, index);
                                  },
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.done),
                                  color: Color(int.parse(
                                      _list[index].color1.replaceAll(
                                          '#', '0xff'))),
                                  onPressed: () {
                                    setState(() {
                                      if (_list[index].check == 0) {
                                        _list[index].color1 = "#22A7F0";
                                        _list[index].check = 1;
                                        _urunGuncelle(_list[index]);
                                      }
                                      else {
                                        _list[index].color1 = "#BFBFBF";
                                        _list[index].check = 0;
                                        _urunGuncelle(_list[index]);
                                      }
                                    });
                                  },
                                ),
                              ),
                              Divider(color: Colors.black)
                            ],
                          ),
                        )
                      ],
                    )),
                  );
                }),
          ),
        ),
      ),
    );
  }

  _urunEkle(alisveris item) {
    DatabaseClient().alisverisListesiEkle(item).then((eklenenitem) {
      if(eklenenitem%5==0){
      InterstitialAd(
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
      if (eklenenitem != 0) {
        setState(() {
          _list.add(item);
        });
      }
    });
  }

  void _urunGuncelle(alisveris item) {
    DatabaseClient().alisverisListesiGuncelle(item);
  }

  _urunSil(String kategoriID, int index) {
    if (_controller.positions.length > 0 &&
        _controller.position.extentBefore < 100.0) {
      if(!isButtonActive){
        setState(() {
        isButtonActive = true;
      });}
    }
      DatabaseClient().alisverisListesiSil(kategoriID);
      setState(() {
        _list.removeAt(index);
      });
    }
  }

