import 'package:dartz/dartz.dart';
import 'package:hackthon_app/Features/fingerPreant/data/dataSource/check_the%20token_data_source.dart';
import 'package:hackthon_app/Features/fingerPreant/data/dataSource/register_finger_data_source.dart';
import 'package:hackthon_app/Features/fingerPreant/data/dataSource/match_finger.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/entity/finger_print_entity.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/entity/user_entity.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/repo/fingerprint_repo.dart';
import 'package:hackthon_app/core/failure/failure.dart';
import 'package:hackthon_app/core/storage/local_storage.dart';
import '../../../../core/network/netowrk_info.dart';

class FingerprintRepoImpl implements FingerprintRepo {
  final NetworkInfo networkInfo;
  final FingerDataSource fingerDataSource;
  final GetTheToken getTheToken;
  final LocalStorage localStorage;
  final CheckTheTokenDataSource checkTheTokendataSource;

  FingerprintRepoImpl({
    required this.networkInfo,
    required this.fingerDataSource,
    required this.getTheToken,
    required this.localStorage,
    required this.checkTheTokendataSource,
  });
  @override
  Future<Either<Failure, String>> registerFingerprint(
    FingerPrintEntity fingerPrintEntity,
  ) async {
    if (await networkInfo.isConnected) {
      // try {
      final result = await fingerDataSource.sendFingerprint(fingerPrintEntity);
      return result;
      // return Right(result);
      // } catch (e) {
      //   return Left(Failure(message: e.toString()));
      // }
    } else {
      return Left(Failure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, String>> checkFingerprint(
    FingerPrintEntity fingerPrintEntity,
  ) async {
    if (await networkInfo.isConnected) {
      final result = await getTheToken.call(fingerPrintEntity.fingerPrintImage);

      result.fold(
        (failure) => null, // Do nothing on failure
        (token) async {
          // Save the token in shared preferences
          await localStorage.saveToken(token);
        },
      );

      return result;
    } else {
      return Left(Failure(message: "No Internet Connection"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> checkTheToken(
    String fingerPrinttoken,
  ) async {
    if (await networkInfo.isConnected) {
      final result = await checkTheTokendataSource.getMe(fingerPrinttoken);
      return result;
    } else {
      return Left(Failure(message: "No Internet Connection"));
    }
  }
}
