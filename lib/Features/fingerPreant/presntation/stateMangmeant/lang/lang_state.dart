part of 'lang_bloc.dart';

@immutable
sealed class LangState {}

final class LangInitial extends LangState {}

final class LangChanged extends LangState {
  final bool isEnglish;
  LangChanged({required this.isEnglish});
}
