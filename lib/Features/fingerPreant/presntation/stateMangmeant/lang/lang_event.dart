part of 'lang_bloc.dart';

@immutable
sealed class LangEvent {}

final class ChangeLanguageEvent extends LangEvent {
  final bool isEnglish;
  ChangeLanguageEvent({required this.isEnglish});
}

final class LoadLanguageEvent extends LangEvent {}
