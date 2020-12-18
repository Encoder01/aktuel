part of 'kategori_bloc.dart';

abstract class KategoriEvent extends Equatable {
  const KategoriEvent();
}
class SetKategoriEvent extends KategoriEvent {
  Color kategori;
  int index=0;
  SetKategoriEvent({ this.kategori,@required this.index});
  @override
  List<Object> get props => throw UnimplementedError();
}