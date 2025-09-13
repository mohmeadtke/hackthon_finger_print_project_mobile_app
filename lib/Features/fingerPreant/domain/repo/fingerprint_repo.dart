import 'package:dartz/dartz.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/entity/finger_print_entity.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/entity/user_entity.dart';
import 'package:hackthon_app/core/failure/failure.dart';

abstract class FingerprintRepo {
  Future<Either<Failure, String>> registerFingerprint(
    FingerPrintEntity fingerPrintEntity,
  );
  Future<Either<Failure, String>> checkFingerprint(
    FingerPrintEntity fingerPrintEntity,
  );
  Future<Either<Failure, UserEntity>> checkTheToken(String fingerPrinttoken);
}
