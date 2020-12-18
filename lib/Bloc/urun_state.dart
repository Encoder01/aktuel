part of 'urun_bloc.dart';

abstract class UrunState extends Equatable {
  const UrunState();
}

class UrunInitial extends UrunState {
  @override
  List<Object> get props => [];
}

class UrunLoadingState extends UrunState {
  @override
  List<Object> get props => [];
}

class UrunLoadedState extends UrunState {
  List<Urunler> urun;
  List<Magazalar> magaza;
  bool hasmore=false;
  UrunLoadedState({this.urun,this.hasmore,this.magaza});

  @override
  List<Object> get props => [urun];
}

class UrunErrorState extends UrunState {
  @override
  List<Object> get props => [];
}