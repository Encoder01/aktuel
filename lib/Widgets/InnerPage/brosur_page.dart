import 'package:aktuel/AdmobService.dart';
import 'package:aktuel/Bloc/urun_bloc.dart';
import 'package:aktuel/Model/Favorite.dart';
import 'package:aktuel/Widgets/InnerPage/brosur_magaza.dart';
import 'package:aktuel/data/sqflite_db_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../Pages/feed_back.dart';
import '../Pages/grid_urun.dart';

class BrosurPage extends StatefulWidget {
  String KategoriAd;
  bool menu;
  BrosurPage({@required this.KategoriAd,@required this.menu});

  @override
  _BrosurPageState createState() => _BrosurPageState(kategori_ad: this.KategoriAd);
}

class _BrosurPageState extends State<BrosurPage> {
  String kategori_ad;

  _BrosurPageState({@required this.kategori_ad});

  static List<favoriler> markalar;
  List<bool> aktif = [];
  final _nativeAdController = NativeAdmobController();
  @override
  void initState() {
    AdmobService.removeBanner();
    initializeDateFormatting();
    markalar = [];
    DatabaseClient().favoriListesiGetir().then((value) => value.forEach((element) {
          markalar.add(element);
        }));
    BlocProvider.of<UrunBloc>(context).add(FetchUrunEvent(nereye: 1, kategoriAd: kategori_ad,
    ));
  }
  @override
  void dispose() {
  if(widget.menu==true)
    AdmobService.showBanner(50);
  else{
    AdmobService.showBanner(0);
  }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white70,
          title: Text(
            kategori_ad,
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            tabs: [
              Tab(child: Text("Broşürler", style: TextStyle(color: Colors.black))),
              Tab(child: Text("Mağazalar", style: TextStyle(color: Colors.black))),
            ],
          ),
        ),
        body: Container(
          color: Colors.blueGrey.withOpacity(0.2),
          child: TabBarView(
            children: [
              NotificationListener<ScrollNotification>(
                onNotification: (scrollState) {
                  if (scrollState is ScrollEndNotification &&
                      scrollState.metrics.extentAfter == 0.0) {
                    if(GridUrun.hasMore){
                      {BlocProvider.of<UrunBloc>(context).add(RefreshUrunEvent(
                        nereye: 1,
                        kategori: GridUrun.kategoriAd, ));
                      Future.delayed(Duration(milliseconds: 500)).then((value) => setState(() {}));
                      }
                    }else{
                      return false;
                    }
                  }
                  return false;
                },
                child: BlocBuilder<UrunBloc, UrunState>(builder: (context, state) {
                  if (state is UrunLoadedState) {
                    return state.urun.isEmpty
                        ?  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                              width: 150,
                              height: 150,
                              child: SvgPicture.asset("assets/images/brochure.svg")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Bu Kategoriye Ait Broşür Bulunumadı",style: TextStyle(fontSize: 20,wordSpacing: 5),textAlign: TextAlign.center),
                        )
                      ],
                    )
                        : Container(
                            child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.count(
                              crossAxisCount: 1,
                              mainAxisSpacing: 9,
                              crossAxisSpacing: 5,
                              padding: const EdgeInsets.all(5),
                              childAspectRatio: 3,
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              children: List.generate(state.urun.length+1, (index) {
                                if(state.urun.length!=index){
                                  if (index != 0 && state.urun[index].altBilgi == "reklam") {
                                    return NativeAdmob(
                                        numberAds: 3,
                                        error: shimmerLoad(),
                                        loading: shimmerLoad(),
                                        adUnitID: AdmobService().getNativeAdUnitId(),
                                        controller: _nativeAdController,
                                        type: NativeAdmobType.banner);
                                  } else
                                    return ShowItems(foto: state.urun[index],);
                                }
                                else{
                                  if(GridUrun.hasMore){
                                    if(state.urun.length<7){
                                      BlocProvider.of<UrunBloc>(context).add(RefreshUrunEvent(
                                        nereye: 1,
                                        kategori: GridUrun.kategoriAd, ));
                                      Future.delayed(Duration(milliseconds: 500)).then((value) => setState(() {}));
                                    return Center(child: CircularProgressIndicator());
                                    }else{
                                      return Center(child: CircularProgressIndicator());
                                    }
                                  }else{
                                    return Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ListTile(
                                        onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                create: (context) => UrunBloc(),
                                child: FeedBack(menu: 0,),
                                ),
                                )),
                                leading: Container(width:50,child: SvgPicture.asset("assets/images/shop.svg")),
                                title: Text("Aradığınız Ürünü Bulamadınız mı?",
                                textAlign: TextAlign.center),
                                trailing: Icon(Icons.arrow_forward_ios),),
                                      ),
                                ));
                                  }
                                }
                              }),
                            ),
                          ));
                  }
                  else if(state is UrunLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  else {
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
                          child: Text("Lütfen İnternet Bağlantınızı Kontrol Ediniz",style: TextStyle(fontSize: 20,wordSpacing: 5),textAlign: TextAlign.center),
                        )
                      ],
                    );
                  }
                }),
              ),
              BlocBuilder<UrunBloc, UrunState>(builder: (context, state) {
                if (state is UrunLoadedState) {
                  var newELement = [];
                  state.urun.forEach((element) {
                    newELement.add(element.Marka);
                  });
                  var distinc = newELement.toSet().toList();
                  if (state.urun.isEmpty) {
                    return  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Container(
                              width: 150,
                              height: 150,
                              child: SvgPicture.asset("assets/images/brochure.svg")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Bu Kategoriye Ait Broşür Bulunumadı",style: TextStyle(fontSize: 20,wordSpacing: 5),textAlign: TextAlign.center),
                        )
                      ],
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.count(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 5,
                          childAspectRatio: 5,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          children: List.generate(distinc.length, (index) {
                            int brosur = 0;
                            String Logo;
                            state.urun.forEach((element) {
                              if (element.Marka == distinc[index]) {
                                if(element.logo!="reklam")
                                {  Logo = element.logo;
                                  brosur++;}
                              }
                            });
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
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BlocProvider(
                                          create: (context) => UrunBloc(),
                                          child: BrosurMagaza(
                                            markaAd: distinc[index],menu:2 ,
                                          ),
                                        ),
                                      ));
                                },
                                leading: CachedNetworkImage(
                                  height: 50,
                                  width: 60,
                                  imageUrl: Logo,
                                ),
                                title: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    distinc[index],
                                    style: TextStyle(color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(brosur.toString() + " Aktif Broşür",
                                      style: TextStyle(fontSize: 15)),
                                ),
                                trailing: IconButton(
                                  color:
                                      _icon(distinc[index]) == true ? Colors.yellow : Colors.black,
                                  onPressed: () {
                                    setState(() {
                                      if (_icon(distinc[index]) == true) {
                                        _favoriSil(distinc[index], index);
                                      } else {
                                        _favoriEkle(favoriler(marka: distinc[index]));
                                      }
                                    });
                                  },
                                  icon: _icon(distinc[index]) == true
                                      ? Icon(Icons.star)
                                      : Icon(Icons.star_border),
                                ),
                              ),
                            );
                          })),
                    );
                  }
                }
                else if(state is UrunLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                else {
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
                        child: Text("Lütfen İnternet Bağlantınızı Kontrol Ediniz",style: TextStyle(fontSize: 20,wordSpacing: 5),textAlign: TextAlign.center),
                      )
                    ],
                  );
                }
              })
            ],
          ),
        ),
      ),
    );
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
