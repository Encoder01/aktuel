import 'dart:async';
import 'dart:io';
import 'package:aktuel/AdmobService.dart';
import 'package:aktuel/Bloc/favori_bloc.dart';
import 'package:aktuel/Bloc/kategori_bloc.dart';
import 'package:aktuel/Bloc/takip_bloc.dart';
import 'package:aktuel/Bloc/urun_bloc.dart';
import 'package:aktuel/Widgets/Pages/favorite_page.dart';
import 'package:aktuel/Widgets/Pages/sayfaisaret_page.dart';
import 'package:aktuel/Widgets/Pages/grid_kategori.dart';
import 'package:aktuel/Widgets/Pages/grid_urun.dart';
import 'package:aktuel/Widgets/Pages/menu_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Pages/listem_page.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with AutomaticKeepAliveClientMixin {
  ScrollController _scrollController = new ScrollController();
  int _currentIndex = 0;
  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.grey, // status bar color
    ));
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
      if (_source.values.contains(false)) {
        FirebaseFirestore.instance.disableNetwork();
        showToast();
      } else {
        FirebaseFirestore.instance.enableNetwork();
      }
    });
    BlocProvider.of<KategoriBloc>(context).add(SetKategoriEvent(index: 0));
    BlocProvider.of<UrunBloc>(context).add(FetchUrunEvent(nereye: 0));
  }

  @override
  void dispose() {
    BlocProvider.of<KategoriBloc>(context).close();
    BlocProvider.of<UrunBloc>(context).close();
    BlocProvider.of<FavoriBloc>(context).close();
    _connectivity.disposeStream();
    super.dispose();
  }

  void onTabTapped(int index) {

    switch (index) {
      case 0:
        {
          AdmobService.removeBanner();
          BlocProvider.of<UrunBloc>(context).add(FetchUrunEvent(
            nereye: GridUrun.kategori ? 1 : 0,
            kategoriAd: GridUrun.kategoriAd,
          ));
        }
        break;
      case 1:
        {
          BlocProvider.of<FavoriBloc>(context).add(FetchFavoriUrunEvent());
         AdmobService.showBanner(50);
        }
        break;
      case 2:
        {
          AdmobService.removeBanner();
        }
        break;
      case 3:
        {
          AdmobService.removeBanner();
          BlocProvider.of<TakipBloc>(context).add(FetchTakipEvent());
        }
        break;
      case 4:
        {
          AdmobService.showBanner(50.0);
        }
    }
    setState(() { _currentIndex = index;});
  }

  Future<Null> getHandle(int index) async {
    if (_source.values.contains(false)) {
      await FirebaseFirestore.instance.disableNetwork();
      showToast();
      return null;
    } else {
      await FirebaseFirestore.instance.enableNetwork();
      onTabTapped(index);
      return null;
    }
  }

  showToast() {
    Fluttertoast.showToast(
        msg: "Lütfen internet bağlantınızı kontrol ediniz",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.1),
      floatingActionButton: _currentIndex!=0?null:FloatingActionButton(
        onPressed: () => _scrollController.animateTo(0.0,
            curve: Curves.linearToEaseOut, duration: Duration (milliseconds: 800)),
        heroTag: "GridUrun",
        backgroundColor: Colors.amber,
        child: Icon(Icons.arrow_circle_up,),
      ),
      body: Stack(
        children: <Widget>[
          Offstage(
            offstage: _currentIndex != 0,
            child: RefreshIndicator(
              onRefresh: () => getHandle(0),
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollState) {
                  if (scrollState is ScrollEndNotification &&
                      _scrollController.position.extentAfter == 0.0 &&
                      _scrollController.position.userScrollDirection == ScrollDirection.reverse) {
                    if (GridUrun.hasMore) {
                      BlocProvider.of<UrunBloc>(context).add(RefreshUrunEvent(
                        nereye: GridUrun.kategori ? 1 : 0,
                        kategori: GridUrun.kategoriAd,
                      ));
                      Future.delayed(Duration(milliseconds: 600)).then((value) {
                        setState(() {});
                      });
                    } else
                      return false;
                  }
                  return false;
                },
                child: ListView(
                  physics: ScrollPhysics(),
                  controller: _scrollController,
                  children: [
                    GridKategori(),
                    GridUrun(GlobalKey: PageStorageKey("GridUrun")),
                  ],
                ),
              ),
            ),
          ),
          Offstage(
            offstage: _currentIndex != 1,
            child: SayfaIsaretList(),
          ),
          Offstage(
            offstage: _currentIndex != 2,
            child: AlisverisListesi(),
          ),
          Offstage(
              offstage: _currentIndex != 3,
              child: RefreshIndicator(onRefresh: () => getHandle(3), child: Favoriler())),
          Offstage(
              offstage: _currentIndex != 4,
              child: BlocProvider<UrunBloc>(create: (context) => UrunBloc(), child: Menu())),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text("Anasayfa"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            title: new Text("Favorilerim", style: TextStyle(fontSize: 12)),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.format_list_bulleted),
            title: new Text(
              "Listem",
              style: TextStyle(fontSize: 13),
            ),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.star),
            title: new Text("Takiplerim"),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.dashboard),
            title: new Text("Menü"),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}
