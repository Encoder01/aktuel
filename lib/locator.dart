import 'package:aktuel/data/SetKategori.dart';
import 'package:aktuel/data/sqflite_db_service.dart';
import 'package:get_it/get_it.dart';

import 'data/FavoriRepository.dart';
import 'data/urun_api_client.dart';
import 'data/urun_repository.dart';

final getIt = GetIt.instance;


void setupLocator() {
  getIt.registerLazySingleton(() => FAvoriRepository());
  getIt.registerLazySingleton(() => UrunRepository());
  getIt.registerLazySingleton(() => UrunApiClient());
  getIt.registerLazySingleton(() => DatabaseClient());
  getIt.registerLazySingleton(() => KategoriClient());
}