import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/entity/finger_print_entity.dart';
import '../../../domain/usecase/check_finger_token_usecase.dart';
import '../../../domain/usecase/check_finger_usecas.dart';
import '../../../domain/usecase/finger_print_usecas.dart';

part 'finger_event.dart';
part 'finger_state.dart';

class FingerBloc extends Bloc<FingerEvent, FingerState> {
  final FingerPrintUsecas fingerPrintUsecas;
  final CheckFingerUsecas checkFingerUsecas;
  final CheckFingerTokenUsecase checkFingerTokenUsecase;

  FingerBloc({
    required this.fingerPrintUsecas,
    required this.checkFingerUsecas,
    required this.checkFingerTokenUsecase,
  }) : super(FingerInitial()) {
    on<RegisterFingerEvent>((event, emit) async {
      emit(FingerLoading());
      final result = await fingerPrintUsecas(event.fingerPrintEntity);
      result.fold(
        (failure) => emit(FingerFailure(errorMessage: failure.message)),
        (string) => emit(FingerSuccess(message: string)),
      );
    });

    on<CheckFingerEvent>((event, emit) async {
      emit(FingerLoading());
      final result = await checkFingerUsecas(event.fingerPrintEntity);
      result.fold(
        (failure) => emit(FingerFailure(errorMessage: failure.message)),
        (string) => emit(FingerSuccess(message: string)),
      );
    });
    on<CheckTheTokenEvent>((event, emit) async {
      emit(FingerLoading());
      final result = await checkFingerTokenUsecase(event.fingerPrinttoken);
      result.fold(
        (failure) => emit(FingerFailure(errorMessage: failure.message)),
        (unit) => emit(HaveToken()),
      );
    });
  }
}
