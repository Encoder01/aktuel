import 'package:aktuel/Bloc/urun_bloc.dart';
import 'package:aktuel/Model/Kategoriler.dart';
import 'package:aktuel/Widgets/InnerPage/brosur_page.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../AdmobService.dart';

class takipKategori extends StatefulWidget {
  List<Kategoriler> kategori;
  takipKategori({@required this.kategori});
  @override
  _takipKategoriState createState() => _takipKategoriState(gelenKategori: kategori);
}
class _takipKategoriState extends State<takipKategori> {
  List<Kategoriler> gelenKategori;
  _takipKategoriState({@required this.gelenKategori});
  bool selected=false;
  @override
  void initState() {
    AdmobService.removeBanner();
    AdmobService.showBanner(0);
    super.initState();
  }
  @override
  void dispose() {
    AdmobService.removeBanner();
    AdmobService.showBanner(50);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color:  Colors.black,
        ),
        backgroundColor: Colors.white70,
        title: Text("Kategoriler",style: TextStyle(color: Colors.black),),
      ),
      body: GridView.count(
          primary: false,
          padding: EdgeInsets.all(8),
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          children: gelenKategori.map<Widget>((Kategoriler kategori){
           return InkWell(
             onTap: () {  Navigator.push(
                 context,
                 MaterialPageRoute(
                   builder: (context) => BlocProvider(create: (context) => UrunBloc(),child: BrosurPage(
                     KategoriAd: kategori.Kategori, menu: false,
                   ),),
                 ));},
             borderRadius: BorderRadius.circular(5.0),
             child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: CircleAvatar(
                          radius: 43,
                          backgroundColor: Color(0xffFDCF09),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage(kategori.Resim),
                          ),
                        ),
                      ),
                    ),
                    Text(kategori.Kategori,style: TextStyle(fontSize: 16),textAlign: TextAlign.center,)
                  ],
                ),

              ),
           );
          }).toList()

          ),
    );
  }
}
