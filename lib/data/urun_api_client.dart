import 'package:aktuel/Model/Favorite.dart';
import 'package:aktuel/Model/Magazalar.dart';
import 'package:aktuel/Model/Urunler.dart';
import 'package:aktuel/Widgets/Pages/grid_urun.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UrunApiClient {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Urunler> foto = [];
  List<Urunler> fotoNew = [];
  List<Magazalar> magazalar = [];
  List<favoriler> marklar = [];
  List<Urunler> foto2 = [];
  List<Urunler> resArr=[];
  List<DocumentSnapshot> documentList;
  List<DocumentSnapshot> documentListTakip;
  List<DocumentSnapshot> documentListKategori;
  List<DocumentSnapshot> documentListMagaza;
  DocumentSnapshot _LastDocument;
  DocumentSnapshot _LastDocumentMagaza;



  Future<List<Urunler>> getUrun(bool isMore, int where, String kategoriAd) async {
    firestore.settings =
        Settings(persistenceEnabled: false);
    switch (where) {
      case 0:
        {
          if (isMore == false) {
            GridUrun.hasMore=true;
            foto = [];
            Query q = firestore.collection("urunler").limit(5);
            QuerySnapshot querySnapshot = await q.get();
            documentList = querySnapshot.docs;
            _LastDocument = documentList[documentList.length - 1];
            documentList.forEach((element) {
              element.data().forEach((key, value) {
                foto.add(Urunler.fromMap(value));
              });
            });
            return foto;
          }
          else {
            Query q = firestore
                .collection("urunler")
                .startAfterDocument(_LastDocument)
                .limit(2);
            QuerySnapshot querySnapshot = await q.get();
            List<DocumentSnapshot> newDocumentList = querySnapshot.docs;
                if(newDocumentList.isEmpty)
                    GridUrun.hasMore=false;
                else
                  GridUrun.hasMore=true;
            _LastDocument=newDocumentList.last;
            newDocumentList.forEach((element) {
              element.data().forEach((key, value) {
                foto.add(Urunler.fromMap(value));
              });
            });

            return foto;
          }
        }
        break;
      case 2:
        {
          fotoNew=[];
          DocumentReference q = firestore.collection("urunler").doc(kategoriAd);
          DocumentSnapshot querySnapshot = await q.get();
          querySnapshot.data().forEach((key, value) {
            fotoNew.add(Urunler.fromMap(value));
          });
          return fotoNew;
        }
        break;
      default:
        {
          print("Invalid choice");
        }
        break;
    }
  }

  Future<List<Urunler>> getTakipList(List<favoriler> favori) async{
    List<Urunler> output = [];
    List<String> kategori=[];
    resArr = [];
    for(favoriler fv in favori) {
      magaza().forEach((element) {
        if(fv.marka==element.logo)
          kategori.add(element.firma);
        });
      for(Magazalar mgz in magaza()){
        if(mgz.firma==fv.marka)
        {
          print(mgz.firma);
          DocumentReference q = firestore.collection("urunler").doc(mgz.firma);
          DocumentSnapshot dc = await q.get();
          if(dc.data()!=null){
            dc.data().forEach((key, value) {

              output.add(Urunler.fromMap(value));
            });
          }
        }
      }
      for(String katgr in kategori ){
          print(katgr);
          DocumentReference q = firestore.collection("urunler").doc(katgr);
          DocumentSnapshot dc = await q.get();
          if(dc.data()!=null){
            dc.data().forEach((key, value) {
              output.add(Urunler.fromMap(value));
            });
          }
      }
      output.forEach((item) {
        var i = resArr.indexWhere((x) => x.resimF[0] == item.resimF[0]);
        if (i <= -1) {
          resArr.add(item);
        }
      });
    }
    return resArr;
  }

  Future<List<Magazalar>> getMagazalar(bool hasMore) async {
    if(hasMore==false){
      magazalar = [];
      GridUrun.hasMore=true;
      Query q = firestore.collection("Magazalar");
      QuerySnapshot snapshot = await q.orderBy("0").limit(2).get();
      documentListMagaza = snapshot.docs;
      _LastDocumentMagaza=documentListMagaza[documentListMagaza.length-1];
      documentListMagaza.forEach((element) {
        element.data().forEach((key, value) {
          magazalar.add(Magazalar.fromMap(value));
        });
      });
      return magazalar;
    }else{
      Query q = firestore.collection("Magazalar");
      QuerySnapshot snapshot = await q.orderBy("0").limit(1).startAfterDocument(_LastDocumentMagaza).get();
      List<DocumentSnapshot> docs = snapshot.docs;
      if(docs.isEmpty)
        GridUrun.hasMore=false;
      else
        GridUrun.hasMore=true;
      _LastDocumentMagaza=docs.last;
      docs.forEach((element) {
        element.data().forEach((key, value) {
          magazalar.add(Magazalar.fromMap(value));
        });
      });
      return magazalar;
    }
  }

  Future<List<Urunler>> getKategori(bool refresh,String kategoriAd)async{
    foto2=[];
    GridUrun.hasMore=false;
    CollectionReference q = firestore.collection("kategoriler").doc(kategoriAd).collection("urunler");
    QuerySnapshot querySnapshot = await q.get();
    querySnapshot.docs.forEach((element) {
      if(element.data()!=null){element.data().forEach((key, value) {
        foto2.add(Urunler.fromMap(value));
      });}
    });
    return foto2;
  }


  List<Magazalar> magaza(){
    return[
      Magazalar(firma:"A101" ,logo:"Süpermarketler" ),
      Magazalar(firma:"BİM" ,logo:"Süpermarketler" ),
      Magazalar(firma: "Bizim Market",logo:"Süpermarketler" ),
      Magazalar(firma: "Carrefour",logo:"Süpermarketler" ),
      Magazalar(firma: "Hakmar Express",logo:"Süpermarketler" ),
      Magazalar(firma: "Hakmar",logo:"Süpermarketler" ),
      Magazalar(firma: "ŞOK",logo:"Süpermarketler" ),
      Magazalar(firma: "Migros",logo:"Süpermarketler" ),
      Magazalar(firma: "Metro",logo:"Süpermarketler" ),
      Magazalar(firma: "Avon",logo:"Kozmetik" ),
      Magazalar(firma: "Farmasi",logo:"Kozmetik" ),
      Magazalar(firma: "Gratis",logo:"Kozmetik" ),
      Magazalar(firma: "Rossman",logo:"Kozmetik" ),
      Magazalar(firma:"Watsons" ,logo:"Kozmetik" ),
      Magazalar(firma:"Boyner" ,logo:"Giyim" ),
      Magazalar(firma:"Çetinkaya" ,logo:"Giyim" ),
      Magazalar(firma:"LC Waikiki" ,logo:"Giyim" ),
      Magazalar(firma: "Mavi",logo:"Giyim" ),
      Magazalar(firma: "Koton",logo:"Giyim" ),
      Magazalar(firma:"Zara" ,logo:"Giyim" ),
      Magazalar(firma: "Doğtaş",logo:"Mobilya" ),
      Magazalar(firma: "Ikea",logo:"Mobilya" ),
      Magazalar(firma: "Kelebek",logo:"Mobilya" ),
      Magazalar(firma: "Yataş",logo:"Mobilya" ),
      Magazalar(firma:"Koçtaş" ,logo:"Yapı Market" ),
      Magazalar(firma: "Tekzen",logo:"Yapı Market" ),
    ];
  }
}
