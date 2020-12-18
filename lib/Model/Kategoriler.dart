

import 'dart:ui';

class Kategoriler{
  String Resim;
  String Kategori;
  Color color;

  Kategoriler({
    this.Resim,
    this.Kategori,
    this.color
  });

  Map<String, dynamic> toMap() {
    return {
      'resim': Resim,
      'kategori':Kategori

    };
  }
  Kategoriler.fromMap(Map<String, dynamic> map)
      : Resim = map['resim'],
        Kategori = map['kategori'];

  @override
  String toString() {
    return 'Urunler{Resim: $Resim ,Kategori: $Kategori color: $color}';

  }
}