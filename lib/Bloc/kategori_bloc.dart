import 'dart:async';
import 'package:aktuel/data/SetKategori.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../locator.dart';

part 'kategori_event.dart';
part 'kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  KategoriBloc() : super(KategoriInitial());

 final KategoriClient kategoriClient =getIt<KategoriClient>();

  @override
  Stream<KategoriState> mapEventToState(
    KategoriEvent event,
  ) async* {
    if (event is SetKategoriEvent) {
      try {
          final getirilenKateogori=
          kategoriClient.setKategori(event.index);
          yield KategoriLoadedState(Kategori: getirilenKateogori);
      } catch (_) {
        yield state;
      }
    }
  }
}
