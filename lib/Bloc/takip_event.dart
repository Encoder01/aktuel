part of 'takip_bloc.dart';

abstract class TakipEvent extends Equatable {
  const TakipEvent();
}
class FetchTakipEvent extends TakipEvent {

  FetchTakipEvent();
  @override
  List<Object> get props => throw UnimplementedError();
}
class RefreshTakipEvent extends TakipEvent {

  RefreshTakipEvent();
  @override
  List<Object> get props => throw UnimplementedError();
}
