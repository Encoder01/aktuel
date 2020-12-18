import 'package:aktuel/Bloc/favori_bloc.dart';
import 'package:aktuel/data/zaman_hesapla.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../InnerPage/detail_page.dart';
class SayfaIsaretList extends StatefulWidget {
  @override
  _SayfaIsaretListState createState() => _SayfaIsaretListState();
}

class _SayfaIsaretListState extends State<SayfaIsaretList> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
           backgroundColor: Colors.white70,
           title: Padding(
             padding: const EdgeInsets.all(8.0),
             child: Center(
                 child: Text(
                   "Favorilerim",
                   style: TextStyle(fontSize: 20,color: Colors.black),
                 )),
           ),
         ),
       body: BlocBuilder<FavoriBloc,FavoriState>(builder: (context,  FavoriState state) {
           if(state is FavoriLoadedState){
             return state.Favoriurun.isEmpty?
             Center(
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Container(
                         width: 200,
                         height: 200,
                         child: SvgPicture.asset("assets/images/favourite.svg")),
                   ),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text("Favoriler Listeniz Boş",style: TextStyle(fontSize: 21)),
                   )
                 ],
               ),
             ):
             Container(
               height: MediaQuery.of(context).size.height * 0.73,
               child: Padding(
                 padding: const EdgeInsets.only(left:8.0,right: 8.0),
                 child: GridView.count(
                     crossAxisCount: 1,
                     mainAxisSpacing: 7,
                     crossAxisSpacing: 4,
                     padding: const EdgeInsets.all(5),
                     childAspectRatio: 3,
                     physics: BouncingScrollPhysics(),
                     shrinkWrap: true,
                     reverse: true,
                     children: List.generate(state.Favoriurun.length, (index) => GestureDetector(
                       onTap: () {
                         Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) =>
                                     SecondPage(
                                       urunler: state.Favoriurun[index],nereden: true,)
                             )).then((value) => BlocProvider.of<FavoriBloc>(context).add(FetchFavoriUrunEvent()));
                       },
                       child: GridTile(
                           header: Padding(
                             padding: EdgeInsets.all(5.0),
                             child: Align(
                               alignment: Alignment.topRight,
                               child: Container(
                                 padding: EdgeInsets.all(5),
                                 decoration: BoxDecoration(
                                     borderRadius:
                                     BorderRadius.circular(3.0),
                                     color: Colors.black,
                                     //Color(0xff0F0F0F),
                                     boxShadow: [
                                       BoxShadow(
                                         color: Colors.black
                                             .withOpacity(0.3),
                                       )
                                     ]),
                                 child: Text(
                                   state.Favoriurun[index].Marka,
                                   style: TextStyle(color: Colors.white),
                                 ),
                               ),
                             ),
                           ),
                           child: Row(
                             children: [
                               Material(
                                 shape: RoundedRectangleBorder(
                                     borderRadius:
                                     BorderRadius.circular(4)),
                                 clipBehavior: Clip.antiAlias,
                                 child: CachedNetworkImage(
                                   width: 110,
                                   fit: BoxFit.scaleDown,
                                   imageUrl: state.Favoriurun[index].resimS,
                                   placeholder: (context, url) =>
                                   Center(child: new CircularProgressIndicator()),
                                   errorWidget: (context, url, error) =>
                                   new Icon(Icons.error),
                                 ),
                               ),
                               Expanded(
                                 child: Container(
                                   decoration: BoxDecoration(boxShadow: [
                                     BoxShadow(color: Colors.white)
                                   ]),
                                   child: Column(
                                     mainAxisAlignment:
                                     MainAxisAlignment.center,
                                     children: <Widget>[
                                       ListTile(
                                         contentPadding: EdgeInsets.all(
                                             5.0),
                                         title: Text(
                                           state.Favoriurun[index].Bilgi,
                                         ),
                                         subtitle: Padding(
                                           padding: EdgeInsets.only(
                                               top: 5.0),
                                           child: Text(
                                             state.Favoriurun[index].altBilgi,
                                           ),
                                         ),
                                       ),
                                     ],
                                   ),
                                 ),
                               )
                             ],
                           ),
                           footer: Align(
                             alignment: Alignment.bottomRight,
                             child: Container(
                               padding: EdgeInsets.all(5),
                               decoration: BoxDecoration(
                                   borderRadius:
                                   BorderRadius.circular(3.0),
                                   color: Colors.yellow,
                                   //Color(0xff0F0F0F),
                                   boxShadow: [
                                     BoxShadow(
                                       color: Colors.black
                                           .withOpacity(0.3),
                                     )
                                   ]),
                               child: Text(ZamanHesapla().timeCalculate(DateTime.parse(state.Favoriurun[index].tarihY)),
                                 style: TextStyle(
                                   color: Colors.black,
                                 ),
                               ),
                             ),
                           )
                       ),
                     ))),
               ),
             );
           }
           else{
             return Center(child: CircularProgressIndicator());
           }
         },
       ),
     );

  }
}
