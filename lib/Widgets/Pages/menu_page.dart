import 'package:aktuel/Bloc/urun_bloc.dart';
import 'package:aktuel/Model/Kategoriler.dart';
import 'package:aktuel/Widgets/InnerPage/brosur_magaza.dart';
import 'package:aktuel/Widgets/Pages/feed_back.dart';
import 'package:aktuel/Widgets/menu_kategori.dart';
import 'package:aktuel/Widgets/menu_magaza.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../AdmobService.dart';
import '../InnerPage/brosur_page.dart';

class Menu extends StatefulWidget {

  @override
  _MenuState createState() => _MenuState();
}
class _MenuState extends State<Menu> {

  List<Kategoriler> _feature() {
    return [
      Kategoriler(
        Resim: 'assets/images/market.jpg',
        Kategori: 'Süpermarketler',
      ),
      Kategoriler(
        Resim: 'assets/images/ev&yapı.jpg',
        Kategori: 'Yapı Market',
      ),
      Kategoriler(
        Resim: 'assets/images/kozmetik.jpg',
        Kategori: 'Kozmetik',
      ),
      Kategoriler(
        Resim: 'assets/images/giyim.jpg',
        Kategori: 'Giyim',
      ),
      Kategoriler(
        Resim: 'assets/images/mobilya.jpg',
        Kategori: 'Mobilya',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            "Menü",
            style: TextStyle(fontSize: 20, color: Colors.black),
          )),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                    )
                  ]),
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => takipKategori(
                                kategori: _feature(),
                              )));
                    },
                    child: ListTile(
                      title: Text("Kategoriler", style: TextStyle(fontSize: 20)),
                      trailing: Icon(Icons.navigate_next),
                    ),
                  ),
                  Divider(height: 1, color: Colors.black),
                  Container(
                    height: 90,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(8.0),
                        children: _feature().map<Widget>((photo) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundColor: Color(0xffFDCF09),
                                child: InkWell(
                                  highlightColor: Colors.grey,
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => UrunBloc(),
                                          child: BrosurPage(
                                            KategoriAd: photo.Kategori, menu: true,
                                          ),
                                        ),
                                      )),
                                  child: CircleAvatar(
                                    radius: 52,
                                    backgroundImage: AssetImage(photo.Resim),
                                  ),
                                ),
                              ),
                            ),
                          ); //Feature(photo);
                        }).toList()),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                    )
                  ]),
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) => UrunBloc(),
                              child: MenuMagaza(),
                            ),
                          ));
                    },
                    child: ListTile(
                      title: Text("Mağazalar", style: TextStyle(fontSize: 20)),
                      trailing: Icon(Icons.navigate_next),
                    ),
                  ),
                  Divider(height: 1, color: Colors.black),
                  Container(
                    height: 90,
                    child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: EdgeInsets.all(8.0),
                        children: _magaza().map<Widget>((magaza) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                                icon: CachedNetworkImage(imageUrl: magaza.logo),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => BlocProvider(
                                        create: (context) => UrunBloc(),
                                        child: BrosurMagaza(
                                          markaAd: magaza.marka,menu: 1,
                                        ),
                                      ),
                                    ))),
                          ); //Feature(photo);
                        }).toList()),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              decoration: new BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                    )
                  ]),
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: FlatButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedBack(menu: 1,),
                      ));
                },
                child: ListTile(
                  leading: Icon(Icons.feedback),
                  title: Text("Geri Bildirim", style: TextStyle(fontSize: 20)),
                  trailing: Icon(Icons.navigate_next),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Magazalar> _magaza() {
    return [
      Magazalar(
          logo: "https://docs.google.com/uc?export=download&id=1WOWM60vwSYywC8YOvbwWa8YdlKS4Yx4x",
          marka: "A101"),
      Magazalar(
          logo: "https://docs.google.com/uc?export=download&id=1i_EGix7P1Hk6qrmNGF8BaHXxFIvOUNct",
          marka: "Avon"),
      Magazalar(
          logo: "https://docs.google.com/uc?export=download&id=10TMV24Rfh1gbAthS2x_ke_Z1Le2teNH9",
          marka: "BİM"),
      Magazalar(
          logo: "https://docs.google.com/uc?export=download&id=1MhjpE0m2LdKnqRFDeLU-Vy1xT2Kb1BWo",
          marka: "Carrefour"),
      Magazalar(
          logo: "https://docs.google.com/uc?export=download&id=1KjU8JuEBERKSlukMnLCqwuxSpEOOsgpN",
          marka: "Gratis"),
      Magazalar(
          logo:
              "https://docs.google.com/uc?export=download&id=1vvgb7EysQIC2xqOwq_lNUQ4lq_6Pm-zt",
          marka: "Metro"),
      Magazalar(logo: "https://docs.google.com/uc?export=download&id=1JO54UflbkfDTQe7nYQ3saePVrUt7J4kE",
          marka: "Migros"),
      Magazalar(
          logo: "https://docs.google.com/uc?export=download&id=1CyB54Keg2RG_tCH0_VLpx7UUfcP6B8Iq",
          marka: "Rossman"),
      Magazalar(
          logo: "https://docs.google.com/uc?export=download&id=1cMhOjDRIMTlJjpYgrb8JR3GyYOfxugBU",
          marka: "ŞOK"),
      Magazalar(
          logo: "https://docs.google.com/uc?export=download&id=163vebSaE-tlzRqsh6oQFbNpWkKYveE4F",
          marka: "Watsons"),
      Magazalar(
          logo: "https://docs.google.com/uc?export=download&id=1cUbtJM1a59ZeFqwLdOWU4roY7uZUWPbO",
          marka: "Zara"),
    ];
  }
}

class Magazalar {
  String logo;
  String marka;

  Magazalar({this.logo, this.marka});
}
