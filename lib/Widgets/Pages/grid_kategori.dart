import 'package:aktuel/Bloc/kategori_bloc.dart';
import 'package:aktuel/Bloc/urun_bloc.dart';
import 'package:aktuel/Model/Kategoriler.dart';
import 'package:aktuel/Widgets/Pages/grid_urun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridKategori extends StatefulWidget {
  @override
  _GridKategoriState createState() => _GridKategoriState();
}

class _GridKategoriState extends State<GridKategori> {
  List<Kategoriler> _feature() {
    return [
      Kategoriler(
        Resim: 'assets/images/genel.jpg',
        Kategori: 'Anasayfa',
        color: Colors.black
      ),
      Kategoriler(
        Resim: 'assets/images/market.jpg',
        Kategori: 'Süpermarketler',
          color: Colors.black
      ),
      Kategoriler(
        Resim: 'assets/images/ev&yapı.jpg',
        Kategori: 'Yapı Market',
          color: Colors.black
      ),
      Kategoriler(
        Resim: 'assets/images/kozmetik.jpg',
        Kategori: 'Kozmetik',
          color: Colors.black
      ),
      Kategoriler(
        Resim: 'assets/images/giyim.jpg',
        Kategori: 'Giyim',
          color: Colors.black
      ),

      Kategoriler(
        Resim: 'assets/images/mobilya.jpg',
        Kategori: 'Mobilya',
          color: Colors.black
      )
    ];
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KategoriBloc,KategoriState>(
      builder: (context, snapshot) {
        return SizedBox(
          height: 110,
          child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(7.0),
              children: List.generate(_feature().length, (index) =>  Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                         BlocProvider.of<KategoriBloc>(context).add(SetKategoriEvent(index: index));
                        });
                        if(_feature()[index].Kategori == "Anasayfa")
                          {BlocProvider.of<UrunBloc>(context).add(FetchUrunEvent(nereye: 0));
                          GridUrun.kategori=false;
                          }
                        else
                          {BlocProvider.of<UrunBloc>(context).add(
                              FetchUrunEvent(nereye: 1, kategoriAd: _feature()[index].Kategori));
                            GridUrun.kategori=true;
                            GridUrun.kategoriAd=_feature()[index].Kategori;
                          }
                      },
                      child: Image.asset(_feature()[index].Resim,
                          width: 120, height: 160, fit: BoxFit.fill),
                    ),
                    Positioned(
                        top: 5,
                        right: 5,
                        child: Container(
                          height: 25,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3.0),
                              color: snapshot is KategoriLoadedState?snapshot.Kategori[index]:Colors.black, //Color(0xff0F0F0F),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                )
                              ]),
                          child: Center(
                            child: Text(
                              _feature()[index].Kategori,
                              style: TextStyle(fontSize: 12,color: snapshot is KategoriLoadedState?snapshot.Kategori[index]==Colors.yellow?Colors.black:Colors.white:Colors.white),
                            ),
                          ),
                        ))
                  ],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 5,
                margin: EdgeInsets.all(5),
              ))),
        );
      }
    );
  }
}
