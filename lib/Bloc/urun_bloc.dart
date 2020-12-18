import 'dart:async';
import 'package:aktuel/Model/Magazalar.dart';
import 'package:aktuel/Model/Urunler.dart';
import 'package:aktuel/data/urun_repository.dart';
import 'package:aktuel/locator.dart';
import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'urun_event.dart';
part 'urun_state.dart';

class UrunBloc extends Bloc<UrunEvent, UrunState> {
  UrunBloc() : super(UrunInitial());
  final UrunRepository urunRepository = getIt<UrunRepository>();
  @override
  UrunState get initialState => UrunInitial();

  @override
  Stream<UrunState> mapEventToState(
    UrunEvent event,
  ) async* {
    if (event is FetchUrunEvent) {
      try {
        if(event.nereye==0){
          yield UrunLoadingState();
          print("genel");
          final List<Urunler> getirilenUrun =
          await urunRepository.getUrun(isMore: false, where: 0,kategoriAd: "Anasayfa",);
          yield UrunLoadedState(urun: getirilenUrun,hasmore: false);
        }else if(event.nereye==1){
          yield UrunLoadingState();
          final List<Urunler> getirilenUrun =
          await urunRepository.getKategori(Kategori: event.kategoriAd,more: false);
          yield UrunLoadedState(urun: getirilenUrun,hasmore: false);
        }else if(event.nereye==2){
          yield UrunLoadingState();
          final List<Urunler> getirilenUrun =
          await urunRepository.getUrun(isMore: false,where: 2,kategoriAd: event.kategoriAd);
          yield UrunLoadedState(urun: getirilenUrun,hasmore: false);
        }
          else if(event.nereye==4){
          yield UrunLoadingState();
          final List<Magazalar> getirilenMagaza =
          await urunRepository.getMagaza(hasmore: false);
          yield UrunLoadedState(magaza: getirilenMagaza,hasmore: false);
        }
        
      } catch (_) {
        yield UrunErrorState();
      }
    } else if (event is RefreshUrunEvent) {
      try {
        if(event.nereye==0) {
          final List<Urunler> getirilenUrun =
          await urunRepository.getUrun(
               isMore: true, where: 0,kategoriAd: "Anasayfa");
          yield UrunLoadedState(urun: getirilenUrun,hasmore: true);
        }else if(event.nereye==1){
          final List<Urunler> getirilenKategori =
          await urunRepository.getKategori(more: true,Kategori: event.kategori);
          yield UrunLoadedState(urun: getirilenKategori,hasmore: true);
        }
        else if(event.nereye==4){
          final List<Magazalar> getirilenMagaza =
          await urunRepository.getMagaza(hasmore: true);
          yield UrunLoadedState(magaza: getirilenMagaza,hasmore: true);
        }
      } catch (_) {
        yield state;
      }
    }
  }
}
