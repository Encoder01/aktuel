import 'dart:async';

import 'package:aktuel/Model/Urunler.dart';
import 'package:aktuel/data/FavoriRepository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import '../locator.dart';

part 'favori_event.dart';
part 'favori_state.dart';

class FavoriBloc extends Bloc<FavoriEvent, FavoriState> {
  FavoriBloc() : super(FavoriInitial());
  final FAvoriRepository urunRepository = getIt<FAvoriRepository>();
  @override
  Stream<FavoriState> mapEventToState(
    FavoriEvent event,
  ) async* {
    if(event is FetchFavoriUrunEvent){
      try {
        final List<Urunler> getirilenUrun =
        await urunRepository.getUrun();
        yield FavoriLoadedState(Favoriurun: getirilenUrun);
      } catch (_) {
        yield      FavoriErrorState();
      }
    }


  }
}
