part of 'kategori_bloc.dart';

abstract class KategoriState extends Equatable {
  const KategoriState();
}

class KategoriInitial extends KategoriState {
  @override
  List<Object> get props => [];
}
class KategoriLoadedState extends KategoriState {
  List<Color> Kategori;
  KategoriLoadedState({@required this.Kategori});

  @override
  List<Object> get props => [Kategori];
}
class KategoriErrorState extends KategoriState {
  @override
  List<Object> get props => [];
}