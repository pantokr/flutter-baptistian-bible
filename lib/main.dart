import 'package:bible/init/init.dart';
import 'package:bible/provider/provider.dart';
import 'package:bible/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/verse_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final Future _initFuture = Init.initialize();
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CurrentBible(),
        )
      ],
      child: MaterialApp(
        title: 'Bible',
        darkTheme: CustomThemeData.dark,
        theme: CustomThemeData.light,
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
      ),
    );
  }
}

class CustomThemeData {
  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.brown,
  );
  static final ThemeData light = ThemeData(
      colorScheme: CustomThemeData.colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: CustomThemeData.colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent),
      textTheme: const TextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
      shadowColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent);
  static final ThemeData dark = ThemeData(
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.brown,
    ),
    textTheme: const TextTheme(),
  );
}
