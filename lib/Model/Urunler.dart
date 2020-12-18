import 'package:cloud_firestore/cloud_firestore.dart';

class Urunler{
  List<String> resimF;
  String resimS;
  String Marka;
  String Bilgi;
  String altBilgi;
  String Kategori;
  Timestamp tarihF;
  String tarihY;
  String logo;

  Urunler({
    this.resimF,
    this.resimS,
    this.Marka,
    this.Bilgi,
    this.altBilgi,
    this.Kategori,
    this.tarihF,
    this.tarihY,
    this.logo,
  });

  Map<String, dynamic> toMap() {
    return {
      'resim': resimS,
      'marka': Marka,
      'bilgi':Bilgi,
      'altbilgi':altBilgi,
      'kategori':Kategori,
      'tarih':tarihF.toDate().toString(),
    };
  }
  Urunler.fromMap(Map<String, dynamic> data)
      : this(
    Marka: data['marka'],
    Kategori: data['kategori'],
    resimF: new List<String>.from(data['resim']),
    Bilgi: data['bilgi'],
    altBilgi: data['altbilgi'],
    tarihF: data['tarih'],
    logo: data['logo'],
  );
  Urunler.fromMapFavor(Map<String, dynamic> data)
      : this(
    Marka: data['marka'],
    Kategori: data['kategori'],
    resimS: data['resim'],
    Bilgi: data['bilgi'],
    altBilgi: data['altbilgi'],
    tarihY: data['tarih'],
  );
  @override
  String toString() {
    return 'Urunler{Resim: $resimF, tarih:$tarihF}';
  }
}