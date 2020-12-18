import 'dart:ui';
import 'package:aktuel/AdmobService.dart';
import 'package:aktuel/Bloc/takip_bloc.dart';
import 'package:aktuel/Bloc/urun_bloc.dart';
import 'package:aktuel/Widgets/InnerPage/edit_favori.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';
import 'grid_urun.dart';

class Favoriler extends StatefulWidget {
  @override
  _FavorilerState createState() => _FavorilerState();
}

class _FavorilerState extends State<Favoriler> {
  bool isButtonActive;
  ScrollController _controller = ScrollController();
  final _nativeAdController = NativeAdmobController();
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
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blueGrey.withOpacity(0.1),
      floatingActionButton:  !isButtonActive ? null : FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(create: (context) => UrunBloc(),child: EditFavori(),)
              )).then((value) => BlocProvider.of<TakipBloc>(context).add(FetchTakipEvent()));

      },),
    appBar: AppBar(
      backgroundColor: Colors.white70,
      title: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
              "Takip Ettiklerim",
              style: TextStyle(fontSize: 20,color: Colors.black),
            )),
      ),
    ),
      body: BlocBuilder<TakipBloc, TakipState>(builder: (context, state){
        if (state is TakipLoadedState) {
          return state.urun.isEmpty?Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                      width: 150,
                      height: 150,
                      child: SvgPicture.asset("assets/images/wish-list.svg")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Hemen Takip Listenizi Oluşturun",style: TextStyle(fontSize: 20,wordSpacing: 5),textAlign: TextAlign.center),
                )
              ],
            ),
          ):Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 1,
                mainAxisSpacing: 9,
                crossAxisSpacing: 5,
                physics: ScrollPhysics(),
                controller: _controller,
                padding: const EdgeInsets.all(5),
                childAspectRatio: 3,
                shrinkWrap: true,
                children: List.generate(state.urun.length+1, (index) {
                  if(state.urun.length!=index) {
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
                  }else {
                      return  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Container(width:50,child: SvgPicture.asset("assets/images/wish-list.svg")),
                              title: Text("Takip listenizi artırın.",
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      );
                    }
                }),
              ),
            ),
          );
        }
        else if(state is TakipLoadingState){
          return Center(child: CircularProgressIndicator(),);
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
    );
  }
}
