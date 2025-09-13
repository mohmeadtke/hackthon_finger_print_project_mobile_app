import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackthon_app/Features/fingerPreant/presntation/stateMangmeant/bloc/finger_bloc.dart';
import 'package:hackthon_app/Features/fingerPreant/presntation/stateMangmeant/lang/lang_bloc.dart';
import 'package:hackthon_app/Features/fingerPreant/presntation/stateMangmeant/lang/app_strings.dart';
import 'package:hackthon_app/Features/fingerPreant/presntation/pasges/home_page.dart';
import 'package:hackthon_app/Features/fingerPreant/presntation/pasges/user_page.dart';
import 'package:hackthon_app/core/storage/local_storage.dart';

class StartupPage extends StatefulWidget {
  const StartupPage({super.key});

  @override
  State<StartupPage> createState() => _StartupPageState();
}

class _StartupPageState extends State<StartupPage> {
  final LocalStorageImpl _localStorage = LocalStorageImpl();

  @override
  void initState() {
    super.initState();
    _checkTokenAndNavigate();
  }

  Future<void> _checkTokenAndNavigate() async {
    try {
      final token = await _localStorage.getToken();

      if (token != null && token.isNotEmpty) {
        if (mounted) {
          context.read<FingerBloc>().add(
            CheckTheTokenEvent(fingerPrinttoken: token),
          );
        }
      } else {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LangBloc, LangState>(
      builder: (context, langState) {
        bool isEnglish = true;
        if (langState is LangChanged) {
          isEnglish = langState.isEnglish;
        }

        return BlocListener<FingerBloc, FingerState>(
          listener: (context, state) {
            if (state is HaveToken) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const UserPage()),
              );
            } else if (state is FingerFailure) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            }
          },
          child: Scaffold(
            backgroundColor: const Color(0xFF0F172A),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
                      ),
                      borderRadius: BorderRadius.circular(60),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.fingerprint,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 32),

                  Text(
                    AppStrings.fingerprintApp(isEnglish),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    AppStrings.checkingAuthentication(isEnglish),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),

                  const SizedBox(height: 32),

                  const CircularProgressIndicator(
                    color: Color(0xFF3B82F6),
                    strokeWidth: 3,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
