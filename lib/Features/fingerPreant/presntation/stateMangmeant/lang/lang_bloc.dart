import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'lang_event.dart';
part 'lang_state.dart';

class LangBloc extends Bloc<LangEvent, LangState> {
  static const String _languageKey = 'language_key';

  LangBloc() : super(LangInitial()) {
    on<LoadLanguageEvent>((event, emit) async {
      final isEnglish = await _getLanguageFromPrefs();
      emit(LangChanged(isEnglish: isEnglish));
    });

    on<ChangeLanguageEvent>((event, emit) async {
      await _saveLanguageToPrefs(event.isEnglish);
      emit(LangChanged(isEnglish: event.isEnglish));
    });
  }

  Future<bool> _getLanguageFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_languageKey) ?? true; // Default to English
  }

  Future<void> _saveLanguageToPrefs(bool isEnglish) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_languageKey, isEnglish);
  }
}
