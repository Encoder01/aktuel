import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../AdmobService.dart';

class FeedBack extends StatefulWidget {
  int menu;
  FeedBack({this.menu});
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  TextEditingController _controller4 = TextEditingController();
  bool adsoyad = true;
  bool konu = true;
  bool email = true;
  bool mesaj = true;
  DateTime _currentTime;
  FocusNode focusNodemesaj = new FocusNode();
  CollectionReference users = FirebaseFirestore.instance.collection('geribildirim');

  @override
  void initState() {
    _controller3.text = "Geri Bildirim";
    _initPlatformState();
    AdmobService.removeBanner();
    super.initState();
  }

  _initPlatformState() async {
    NTP.now().then((value) {
      setState(() {
        _currentTime = value;
      });
      print(_currentTime);
    });
  }
  @override
  void dispose() {
   if(widget.menu==0){
     AdmobService.removeBanner();
   }else if(widget.menu==1){
     AdmobService.showBanner(50);
   }else if(widget.menu==2){
     AdmobService.showBanner(0);
   }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          FlatButton(
          onPressed: () {
            setState(() {
              if (_controller1.text.length < 5)
                adsoyad = false;
              else {
                adsoyad = true;
              }
              if (_controller3.text.length < 5)
                konu = false;
              else {
                konu = true;
              }
              if (_controller4.text.length < 15)
                mesaj = false;
              else {
                mesaj = true;
              }
              email = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(_controller2.text);
            });
            if (adsoyad && email && konu && mesaj)
              {addTarih();
              gonder();}
            else
              return null;
          },
          child: Text("Gönder", style: TextStyle(fontSize: 20)),
        )],
        backgroundColor: Colors.white70,
        iconTheme: IconThemeData(color: Colors.black),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Geri Bildirim",
            style: TextStyle(fontSize: 20, color: Colors.black),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 65,
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
                    color: Colors.blueAccent.withOpacity(0.2),
                  ),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text("İstek, Görüş ve Önerilerinize Açığız. Hep Birlikte Gelişelim.",style: TextStyle(color: Colors.black,fontSize: 16),textAlign: TextAlign.center,)),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new TextFormField(
                controller: _controller1,
                decoration: new InputDecoration(
                  errorText: adsoyad ? null : "En az 5 Karakter olmalıdır",
                  suffixIcon: adsoyad
                      ? null
                      : Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                  labelText: "Adınız Soyadınız",
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.name,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new TextFormField(
                controller: _controller2,
                decoration: new InputDecoration(
                  errorText: email ? null : "Bu alan uygun Formatta değildir",
                  suffixIcon: email
                      ? null
                      : Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                  labelText: "Email Adresiniz",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if (val.length == 0) {
                    return "Bu Alan Boş Bırakılamaz";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.emailAddress,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new TextFormField(
                controller: _controller3,
                decoration: new InputDecoration(
                  errorText: konu ? null : "En az 5 karakter olmalıdır",
                  suffixIcon: konu
                      ? null
                      : Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                  labelText: "Konu",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if (val.length == 0) {
                    return "Bu Alan Boş Bırakılamaz";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.text,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: new TextFormField(
                focusNode: focusNodemesaj,
                controller: _controller4,
                maxLines: 4,
                decoration: new InputDecoration(
                  errorText: mesaj ? null : "En az 15 karakter olmalıdır",
                  suffixIcon: mesaj
                      ? null
                      : Icon(
                          Icons.error_outline,
                          color: Colors.red,
                        ),
                  labelText: "Mesajınız",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(),
                  ),
                  //fillColor: Colors.green
                ),
                validator: (val) {
                  if (val.length == 0) {
                    return "Mesaj Boş Bırakılamaz";
                  } else {
                    return null;
                  }
                },
                keyboardType: TextInputType.multiline,
                style: new TextStyle(
                  fontFamily: "Poppins",
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  ShowAlerDialog(String title, String message, String ok) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(title: Text(title), content: Text(message), actions: <Widget>[
            FlatButton(
              child: Text(ok),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ]);
        });
  }

  Future<void> gonder() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String boolValue = prefs.getString('tarih');
    String day = _currentTime.year.toString()+ _currentTime.month.toString()+_currentTime.day.toString();
    if(boolValue == day)
       {
       ShowAlerDialog("Bu Günlük Yeter", "Günlük Bir Görüşünüz Bizim için Yeterlidir.", "Tamam");
       }
    else
      {
      users
          .doc(DateTime.now().year.toString() +
          DateTime.now().month.toString() +
          DateTime.now().day.toString())
          .set({
        _controller2.text: {
          'ad': _controller1.text,
          'konu': _controller3.text,
          'mesaj': _controller4.text
        }
      }, SetOptions(merge: true)).then((value) {
        focusNodemesaj.unfocus();
        _controller3.clear();
        _controller4.clear();
        ShowAlerDialog(
            "Bildiriminiz Bize Ulaştı", "Geri Bildiriminiz için Teşekkür Ederiz", "Rica Ederim");
      }).catchError((error) {
        focusNodemesaj.unfocus();
        ShowAlerDialog("Bir Sorun Oldu", "İnternet Bağlantınızı Kontrol Edebilirsiniz", "Tamam");
      });
      }
    return null;
  }
  addTarih() async {
    String day = _currentTime.year.toString()+ _currentTime.month.toString()+_currentTime.day.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("tarih", day);

  }
}
