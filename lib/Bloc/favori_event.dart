part of 'favori_bloc.dart';

abstract class FavoriEvent extends Equatable {
  const FavoriEvent();
}
class FetchFavoriUrunEvent extends FavoriEvent {
  FetchFavoriUrunEvent();
  @override
  List<Object> get props => throw UnimplementedError();
}