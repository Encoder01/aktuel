
import 'package:aktuel/AdmobService.dart';
import 'package:aktuel/Bloc/urun_bloc.dart';
import 'package:aktuel/Widgets/Pages/feed_back.dart';
import 'package:aktuel/Widgets/Pages/grid_urun.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
class BrosurMagaza extends StatefulWidget {
  String markaAd;
  int menu;
  BrosurMagaza({this.markaAd,this.menu});
  @override
  _BrosurMagazaState createState() => _BrosurMagazaState(markaAd: this.markaAd);
}

class _BrosurMagazaState extends State<BrosurMagaza> {
  String markaAd;
  _BrosurMagazaState({this.markaAd});
  final _nativeAdController = NativeAdmobController();
  @override
  void initState() {
    super.initState();
    AdmobService.removeBanner();
    BlocProvider.of<UrunBloc>(context).add(FetchUrunEvent(nereye: 2, kategoriAd: markaAd,
    ));
  }
@override
  void dispose() {
  if(widget.menu==0){
    AdmobService.showBanner(0);
  }else if(widget.menu==1){
    AdmobService.showBanner(50);
  }else if(widget.menu==2){
    AdmobService.removeBanner();
  }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(markaAd, style: TextStyle(color: Colors.black,),textAlign: TextAlign.center,),
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: Colors.white70,
        ),
        body: BlocBuilder<UrunBloc, UrunState>(builder: (context, state) {
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
                    ),
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
    );
  }
}
