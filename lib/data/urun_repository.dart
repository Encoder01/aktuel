import 'package:aktuel/Model/Favorite.dart';
import 'package:aktuel/Model/Urunler.dart';
import 'package:aktuel/Model/Magazalar.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';
import 'urun_api_client.dart';

class UrunRepository {
  UrunApiClient urunApiClient = getIt<UrunApiClient>();

  Future<List<Urunler>> getUrun(
      {@required bool isMore,
      @required int where,
      String kategoriAd,
      }) async {
    return await urunApiClient.getUrun(
        isMore,where,kategoriAd,);
  }
  Future<List<Magazalar>> getMagaza({bool hasmore}
     ) async {
    return await urunApiClient.getMagazalar(hasmore);
  }
  Future<List<Urunler>> getTakipList({List<favoriler> favori})async{
    return await urunApiClient.getTakipList(favori);
  }
  Future<List<Urunler>> getKategori({String Kategori,bool more}
      ) async {
    return await urunApiClient.getKategori(more,Kategori);
  }


}
