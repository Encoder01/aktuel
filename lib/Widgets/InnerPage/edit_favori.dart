import 'package:aktuel/AdmobService.dart';
import 'package:aktuel/Bloc/urun_bloc.dart';
import 'package:aktuel/Model/Favorite.dart';
import 'package:aktuel/Model/Kategoriler.dart';
import 'package:aktuel/Widgets/Pages/feed_back.dart';
import 'package:aktuel/data/sqflite_db_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../Pages/grid_urun.dart';

class EditFavori extends StatefulWidget {
  @override
  _EditFavoriState createState() => _EditFavoriState();
}

class _EditFavoriState extends State<EditFavori> {
  static List<favoriler> markalar;
  @override
  void initState() {
    super.initState();
    AdmobService.removeBanner();
    AdmobService.showBanner(0);
    markalar = [];
    DatabaseClient().favoriListesiGetir().then((value) => value.forEach((element) {
          markalar.add(element);
        }));
    BlocProvider.of<UrunBloc>(context).add(FetchUrunEvent(nereye: 4));
  }
@override
  void dispose() {
  AdmobService.removeBanner();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: Icon(Icons.arrow_back_ios)),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white70,
          title: Text(
            "Favorileri Düzenle",
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            tabs: [
              Tab(child: Text("Mağazalar", style: TextStyle(color: Colors.black),)),
              Tab(child: Text("Kategoriler", style: TextStyle(color: Colors.black)))
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (scrollState) {
                  if (scrollState is ScrollEndNotification &&
                      scrollState.metrics.extentAfter == 0.0) {
                    if (GridUrun.hasMore) {
                      {
                        BlocProvider.of<UrunBloc>(context).add(RefreshUrunEvent(
                          nereye: 4,
                        ));
                        Future.delayed(Duration(seconds: 1, milliseconds: 300)).then((value) {
                          setState(() {});
                        });
                      }
                    } else {
                      return false;
                    }
                  }
                  return false;
                },
                child: BlocBuilder<UrunBloc, UrunState>(builder: (context, state) {
                  if (state is UrunLoadedState) {
                    return state.magaza.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                    width: 150,
                                    height: 150,
                                    child: SvgPicture.asset("assets/images/shop.svg")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Herhangi Bir Mağaza Bulunamadı",
                                    style: TextStyle(fontSize: 20, wordSpacing: 5),
                                    textAlign: TextAlign.center),
                              )
                            ],
                          )
                        : Padding(
                            padding: EdgeInsets.all(8.0),
                            child: GridView.count(
                              crossAxisCount: 1,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 5,
                              childAspectRatio: 3,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              children: List.generate(state.magaza.length + 1, (index) {
                                if (state.magaza.length != index)
                                  return Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(3.0),
                                        color: Colors.white, //Color(0xff0F0F0F),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.3),
                                          )
                                        ]),
                                    child: ListTile(
                                      leading: CachedNetworkImage(
                                        height: 50,
                                        width: 60,
                                        imageUrl: state.magaza[index].logo,
                                      ),
                                      title: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          state.magaza[index].firma,
                                          style: TextStyle(color: Colors.black, fontSize: 18),
                                        ),
                                      ),
                                      trailing: IconButton(
                                        color: _icon(state.magaza[index].firma) == true
                                            ? Colors.yellow
                                            : Colors.black,
                                        onPressed: () {
                                          setState(() {
                                            if (_icon(state.magaza[index].firma) == true) {
                                              _favoriSil(state.magaza[index].firma, index);
                                            } else {
                                              _favoriEkle(
                                                  favoriler(marka: state.magaza[index].firma));
                                            }
                                          });
                                        },
                                        icon: _icon(state.magaza[index].firma) == true
                                            ? Icon(Icons.star)
                                            : Icon(Icons.star_border),
                                      ),
                                    ),
                                  );
                                else {
                                  if (GridUrun.hasMore)
                                    return Center(child: CircularProgressIndicator());
                                  else {
                                    return Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BlocProvider(
                                                  create: (context) => UrunBloc(),
                                                  child: FeedBack(menu: 2,),
                                                ),
                                              )),
                                          leading: Container(
                                              width: 50,
                                              child: SvgPicture.asset("assets/images/shop.svg")),
                                          title: Text("Aradığınız Mağazayı Bulamadınız mı?",
                                              textAlign: TextAlign.center),
                                          trailing: Icon(Icons.arrow_forward_ios),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }),
                            ),
                          );
                  } else if (state is UrunLoadingState) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                              width: 150,
                              height: 150,
                              child: SvgPicture.asset("assets/images/no-wifi.svg")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Lütfen İnternet Bağlantınızı Kontrol Ediniz",
                              style: TextStyle(fontSize: 20, wordSpacing: 5),
                              textAlign: TextAlign.center),
                        )
                      ],
                    );
                  }
                }),
              ),
              BlocBuilder<UrunBloc, UrunState>(builder: (context, snapshot) {
                return GridView.count(
                  crossAxisCount: 1,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 5,
                  childAspectRatio: 5,
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  children: List.generate(_feature().length, (index) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3.0),
                          color: Colors.white, //Color(0xff0F0F0F),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                            )
                          ]),
                      child: ListTile(
                        leading: Image(
                            width: 80,
                            fit: BoxFit.fill,
                            image: AssetImage(_feature()[index].Resim)),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            _feature()[index].Kategori,
                            style: TextStyle(color: Colors.black, fontSize: 18),
                          ),
                        ),
                        trailing: IconButton(
                          color: _icon(_feature()[index].Kategori) == true
                              ? Colors.yellow
                              : Colors.black,
                          onPressed: () {
                            setState(() {
                              if (_icon(_feature()[index].Kategori) == true) {
                                _favoriSil(_feature()[index].Kategori, index);
                              } else {
                                _favoriEkle(favoriler(marka: _feature()[index].Kategori));
                              }
                            });
                          },
                          icon: _icon(_feature()[index].Kategori) == true
                              ? Icon(Icons.star)
                              : Icon(Icons.star_border),
                        ),
                      ),
                    );
                  }),
                );
              })
            ],
          ),
        ),
      ),
    );
  }

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
        Resim: 'assets/images/ev&yapı.jpg',
        Kategori: 'Mobilya',
      ),
    ];
  }

  _favoriEkle(favoriler item) {
    DatabaseClient().favoriEkle(item).then((eklenenitem) {
      if (eklenenitem != 0) {
        setState(() {
          markalar.add(item);
        });
      }
    });
  }

  _favoriSil(String item, int index) {
    DatabaseClient().favoriSil(item);

    setState(() {
      markalar.removeWhere((element) => element.marka == item);
    });
  }

  _icon(String distinc) {
    var icon = false;
    if (markalar.isNotEmpty) {
      for (var i in markalar) {
        if (i.marka == distinc) {
          icon = true;
        }
      }
    } else {
      icon = false;
    }
    return icon;
  }
}
