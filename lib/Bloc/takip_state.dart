part of 'takip_bloc.dart';

abstract class TakipState extends Equatable {
  const TakipState();
}

class TakipInitial extends TakipState {
  @override
  List<Object> get props => [];
}
class TakipLoadingState extends TakipState {
  @override
  List<Object> get props => [];
}

class TakipLoadedState extends TakipState {
  List<Urunler> urun;
  TakipLoadedState({this.urun});

  @override
  List<Object> get props => [urun];
}
class TakipErrorState extends TakipState {
  @override
  List<Object> get props => [];
}