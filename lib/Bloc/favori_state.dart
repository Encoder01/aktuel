part of 'favori_bloc.dart';

abstract class FavoriState extends Equatable {
  const FavoriState();
}
class FavoriInitial extends FavoriState {
  @override
  List<Object> get props => [];
}
class FavoriLoadingState extends FavoriState {
  @override
  List<Object> get props => [];
}

class FavoriLoadedState extends FavoriState {
  List<Urunler> Favoriurun;
  FavoriLoadedState({@required this.Favoriurun});

  @override
  List<Object> get props => [Favoriurun];
}

class FavoriErrorState extends FavoriState {
  @override
  List<Object> get props => [];
}
