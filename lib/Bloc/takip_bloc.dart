import 'dart:async';

import 'package:aktuel/Model/Favorite.dart';
import 'package:aktuel/Model/Urunler.dart';
import 'package:aktuel/data/sqflite_db_service.dart';
import 'package:aktuel/data/urun_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../locator.dart';

part 'takip_event.dart';
part 'takip_state.dart';

class TakipBloc extends Bloc<TakipEvent, TakipState> {
  TakipBloc() : super(TakipInitial());
  final UrunRepository urunRepository = getIt<UrunRepository>();
  @override
  TakipState get initialState => TakipInitial();
  @override
  Stream<TakipState> mapEventToState(
    TakipEvent event,
  ) async* {
    if(event is FetchTakipEvent){
      try{
        yield TakipLoadingState();
        List<favoriler> fv = await DatabaseClient().favoriListesiGetir();
        final List<Urunler> getirilenUruns =
        await urunRepository.getTakipList(favori: fv);
        await  Future.delayed(Duration(milliseconds: 500));
        yield TakipLoadedState(urun: getirilenUruns);
      }catch(_){
        yield TakipErrorState();
      }
    }else if(event is RefreshTakipEvent){
      try{
        final List<Urunler> getirilenUruns =
        await urunRepository.getTakipList();
        await  DatabaseClient().favoriListesiGetir();
        yield TakipLoadedState(urun: getirilenUruns);
      }catch(_){
        yield state;
      }
    }

  }
}
