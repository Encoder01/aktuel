part of 'urun_bloc.dart';
abstract class UrunEvent extends Equatable {
  const UrunEvent();
}
class FetchUrunEvent extends UrunEvent {
  String kategoriAd;
  bool isKategori;
  bool isMarka;
  bool isFavori;
  int nereye = 0;
  FetchUrunEvent({@required this.nereye,this.kategoriAd,});
  @override
  List<Object> get props => throw UnimplementedError();
}
class RefreshUrunEvent extends UrunEvent {
  String kategori;
  int nereye;
  RefreshUrunEvent({@required this.nereye,this.kategori});
  @override
  List<Object> get props => throw UnimplementedError();
}


