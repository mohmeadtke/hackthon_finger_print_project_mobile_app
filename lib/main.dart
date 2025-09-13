import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackthon_app/Features/fingerPreant/presntation/stateMangmeant/bloc/finger_bloc.dart';
import 'package:hackthon_app/Features/fingerPreant/presntation/stateMangmeant/lang/lang_bloc.dart';
import 'package:hackthon_app/injceshon.dart' as di;
import 'Features/fingerPreant/presntation/pasges/home_page.dart';
import 'Features/fingerPreant/presntation/pasges/register_finger_page.dart';
import 'Features/fingerPreant/presntation/pasges/check_fingerprint_page.dart';
import 'Features/fingerPreant/presntation/pasges/startup_page.dart';
import 'Features/fingerPreant/presntation/pasges/user_page.dart';

void main() {
  di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<FingerBloc>()),
        BlocProvider(
          create: (_) => di.sl<LangBloc>()..add(LoadLanguageEvent()),
        ),
      ],
      child: MaterialApp(
        title: 'Fingerprint Scanner App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF667EEA),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          fontFamily: 'SF Pro Display',
        ),
        home: const StartupPage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/register': (context) => const FingerPage(),
          '/check': (context) => const CheckFingerprintPage(),
          '/user': (context) => const UserPage(),
        },
      ),
    );
  }
}
