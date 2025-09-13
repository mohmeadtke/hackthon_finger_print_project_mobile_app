part of 'finger_bloc.dart';

@immutable
sealed class FingerState {}

final class FingerInitial extends FingerState {}

final class FingerLoading extends FingerState {}

final class FingerSuccess extends FingerState {
  final String message;
  FingerSuccess({required this.message});
}

final class FingerFailure extends FingerState {
  final String errorMessage;
  FingerFailure({required this.errorMessage});
}

final class HaveToken extends FingerState {}
