import 'package:dartz/dartz.dart';
import 'package:hackthon_app/Features/fingerPreant/domain/repo/fingerprint_repo.dart';
import '../../../../core/failure/failure.dart';
import '../entity/finger_print_entity.dart';

class FingerPrintUsecas {
  final FingerprintRepo fingerprintRepo;

  FingerPrintUsecas({required this.fingerprintRepo});

  Future<Either<Failure, String>> call(
    FingerPrintEntity fingerPrintEntity,
  ) async {
    return fingerprintRepo.registerFingerprint(fingerPrintEntity);
  }
}
