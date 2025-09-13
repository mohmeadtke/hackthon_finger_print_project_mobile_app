import 'package:get_it/get_it.dart';
import 'package:hackthon_app/Features/fingerPreant/data/dataSource/check_the%20token_data_source.dart';
import 'package:hackthon_app/Features/fingerPreant/data/dataSource/register_finger_data_source.dart';
import 'package:hackthon_app/Features/fingerPreant/data/dataSource/match_finger.dart';
import 'package:hackthon_app/Features/fingerPreant/data/rempimpl/finger_repo_imp.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/repo/fingerprint_repo.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/usecase/check_finger_token_usecase.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/usecase/check_finger_usecas.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/usecase/finger_print_usecas.dart';
import 'package:hackthon_app/Features/fingerPreant/presntation/stateMangmeant/bloc/finger_bloc.dart';
import 'package:hackthon_app/Features/fingerPreant/presntation/stateMangmeant/lang/lang_bloc.dart';
import 'package:hackthon_app/core/network/netowrk_info.dart';
import 'package:hackthon_app/core/storage/local_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

final sl = GetIt.instance;

void init() {
  //! Features

  //? profile page
  //repo
  sl.registerLazySingleton<FingerprintRepo>(
    () => FingerprintRepoImpl(
      networkInfo: sl(),
      fingerDataSource: sl(),
      getTheToken: sl(),
      localStorage: sl(),
      checkTheTokendataSource: sl(),
    ),
  );
  //use case
  sl.registerLazySingleton(() => FingerPrintUsecas(fingerprintRepo: sl()));
  sl.registerLazySingleton(() => CheckFingerUsecas(fingerprintRepo: sl()));
  sl.registerLazySingleton(
    () => CheckFingerTokenUsecase(fingerprintRepo: sl()),
  );
  //data
  sl.registerFactory(() => FingerDataSource());
  sl.registerFactory(() => GetTheToken());
  sl.registerFactory(() => CheckTheTokenDataSource());
  //bloc
  sl.registerFactory(
    () => FingerBloc(
      fingerPrintUsecas: sl(),
      checkFingerUsecas: sl(),
      checkFingerTokenUsecase: sl(),
    ),
  );
  sl.registerFactory(() => LangBloc());

  //? core
  sl.registerLazySingleton<LocalStorage>(() => LocalStorageImpl());
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(connectionChecker: sl()),
  );
  sl.registerLazySingleton(() => InternetConnection());
}
