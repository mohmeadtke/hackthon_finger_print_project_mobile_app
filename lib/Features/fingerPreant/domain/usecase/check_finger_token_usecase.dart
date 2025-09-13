import 'package:dartz/dartz.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/entity/user_entity.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/repo/fingerprint_repo.dart';
import '../../../../core/failure/failure.dart';

class CheckFingerTokenUsecase {
  final FingerprintRepo fingerprintRepo;

  CheckFingerTokenUsecase({required this.fingerprintRepo});

  Future<Either<Failure, UserEntity>> call(String fingerPrinttoken) async {
    return fingerprintRepo.checkTheToken(fingerPrinttoken);
  }
}
