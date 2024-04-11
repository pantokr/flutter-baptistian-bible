import 'package:bible/init/init.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/screens/splash_screen.dart';
import 'package:bible/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/verse_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CurrentBible(),
        )
      ],
      child: ValueListenableBuilder(
        valueListenable: CustomThemeMode.themeMode,
        builder: (context, value, child) {
          return MaterialApp(
            title: 'Bible',
            darkTheme: CustomThemeData.dark,
            theme: CustomThemeData.light,
            themeMode: value,
            home: FutureBuilder(
              future: Init.initialize(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return const VerseScreen();
                } else {
                  return const SplashScreen();
                }
              },
            ),
          );
        },
      ),
    );
  }
}
