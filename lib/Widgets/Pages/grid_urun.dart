import 'package:aktuel/AdmobService.dart';
import 'package:aktuel/Bloc/urun_bloc.dart';
import 'package:aktuel/Model/Urunler.dart';
import 'package:aktuel/data/zaman_hesapla.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shimmer/shimmer.dart';
import '../InnerPage/detail_page.dart';
import 'feed_back.dart';

class GridUrun extends StatefulWidget {
  static bool kategori = false;
  static bool hasMore = true;
  static String kategoriAd = "Vitrin";

  GridUrun({
    Key GlobalKey,
  }) : super(key: GlobalKey);

  @override
  _GridUrunState createState() => _GridUrunState();
}

class _GridUrunState extends State<GridUrun> with SingleTickerProviderStateMixin {
  List<Urunler> foto = [];
  final _nativeAdController = NativeAdmobController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UrunBloc, UrunState>(builder: (context, stateu) {
      if (stateu is UrunLoadedState) {
        foto = stateu.urun;
        return foto.isEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: 100,
                  height: 100,
                  child: SvgPicture.asset("assets/images/brochure.svg")),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Bu Kategoriye Ait Broşür Bulunumadı", style: TextStyle(fontSize: 16)),
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
              physics: ScrollPhysics(),
              padding: const EdgeInsets.all(5),
              childAspectRatio: 3,
              shrinkWrap: true,
              children: List.generate(foto.length + 1, (index) {
                if (foto.length != index) {
                  if (index != 0 && foto[index].altBilgi == "reklam") {
                    return NativeAdmob(
                        numberAds: 3,
                        error: shimmerLoad(),
                        loading: shimmerLoad(),
                        adUnitID: AdmobService().getNativeAdUnitId(),
                        controller: _nativeAdController,
                        type: NativeAdmobType.banner);
                  } else
                    return ShowItems(foto: foto[index]);
                }
                else {
                  if (GridUrun.hasMore) {
                      return Center(child: CircularProgressIndicator());
                  }
                  else {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FeedBack(menu: 0,),
                                  ));
                            },
                            leading: Container(
                                width: 50, child: SvgPicture.asset("assets/images/shop.svg")),
                            title: Text("Aradığınız Ürünü Bulamadınız mı?",
                                textAlign: TextAlign.center),
                            trailing: Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      ),
                    );
                  }
                }
              }),
            ),
          ),
        );
      }
      else if (stateu is UrunLoadingState) {
        return Center(child: CircularProgressIndicator());
      }
      else {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/images/no-wifi.svg",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "Lütfen İnternet Bağlantınızı Kontrol Ediniz ", style: TextStyle(fontSize: 16)),
            )
          ],
        );
      }
    });
  }
}
class shimmerLoad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[350],
      highlightColor: Colors.grey[100],
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 95,

              color: Colors.white,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Container(
                    width: double.infinity,
                    height: 8.0,
                    color: Colors.white,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 2.0),
                  ),
                  Container(
                    width: 40.0,
                    height: 8.0,
                    color: Colors.white,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ShowItems extends StatelessWidget {
  Urunler foto = null;

  ShowItems({this.foto});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SecondPage(
                    urunler: foto,
                    nereden: false,
                  ),
            ));
      },
      child: GridTile(
        header: Padding(
          padding: EdgeInsets.all(5.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(5),
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(3.0), color: Colors.black,
                  //Color(0xff0F0F0F),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                    )
                  ]),
              child: Text(
                foto.Marka,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        child: Row(
          children: [
            Material(
              color: Colors.black.withOpacity(0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              clipBehavior: Clip.antiAlias,
              child: CachedNetworkImage(
                width: 105,
                height: double.infinity,
                fit: BoxFit.fill,
                imageUrl: foto.resimF[0],
                placeholder: (context, url) => Center(child: new CircularProgressIndicator()),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.white)]),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.all(5.0),
                      title: Text(
                        foto.Bilgi,
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 5.0),
                        child: Text(
                          foto.altBilgi,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
        footer: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Container(
                width: 105,
                padding: EdgeInsets.all(5),
                decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(3.0), color: Colors.yellow,
                    //Color(0xff0F0F0F),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                      )
                    ]),
                child: Text(
                  "${foto.resimF.length} Sayfa",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration:
              BoxDecoration(borderRadius: BorderRadius.circular(3.0), color: Colors.yellow,
                  //Color(0xff0F0F0F),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                    )
                  ]),
              child: Text(
                ZamanHesapla().timeCalculate(foto.tarihF.toDate()),
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
