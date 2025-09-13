part of 'finger_bloc.dart';

@immutable
sealed class FingerEvent {}

final class RegisterFingerEvent extends FingerEvent {
  final FingerPrintEntity fingerPrintEntity;
  RegisterFingerEvent({required this.fingerPrintEntity});
}

final class CheckFingerEvent extends FingerEvent {
  final FingerPrintEntity fingerPrintEntity;
  CheckFingerEvent({required this.fingerPrintEntity});
}

final class CheckTheTokenEvent extends FingerEvent {
  final String fingerPrinttoken;
  CheckTheTokenEvent({required this.fingerPrinttoken});
}
