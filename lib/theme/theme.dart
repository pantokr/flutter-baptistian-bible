import 'package:flutter/material.dart';

class CustomThemeMode {
  static final CustomThemeMode instance = CustomThemeMode._internal();
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.light);
  static ValueNotifier<bool> current = ValueNotifier(false);
  factory CustomThemeMode() => instance;

  static void change() {
    switch (themeMode.value) {
      case ThemeMode.light:
        themeMode.value = ThemeMode.dark;
        current.value = true;
        print('Changed to Dark');

        break;
      case ThemeMode.dark:
        themeMode.value = ThemeMode.light;
        current.value = false;
        print('Changed to Light');

        break;
      default:
    }
  }

  CustomThemeMode._internal();
}

class CustomThemeData {
  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.brown,
  );
  static ThemeData get current => CustomThemeMode.current.value ? dark : light;
  static Color get backgroundColor => CustomThemeMode.current.value
      ? colorScheme.onBackground
      : colorScheme.background;
  static Color get textColor =>
      CustomThemeMode.current.value ? Colors.white : Colors.black;
  static Color get color1 => CustomThemeMode.current.value
      ? const Color.fromARGB(255, 64, 64, 64)
      : colorScheme.background;
  static Color get color2 => CustomThemeMode.current.value
      ? const Color.fromARGB(255, 128, 128, 128)
      : colorScheme.background;

  static Color get publicColor1 => const Color(0xffb0b6b7);
  static Color get publicColor2 => const Color(0xff262a2d);
  static Color get publicColor3 => const Color(0xff8088b2);
  static Color get publicColor4 => const Color(0xffc7b0c2);

  static final ThemeData light = ThemeData(
      colorScheme: CustomThemeData.colorScheme,
      scaffoldBackgroundColor: colorScheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent),
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
      colorScheme: CustomThemeData.colorScheme,
      scaffoldBackgroundColor: colorScheme.onBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: CustomThemeData.colorScheme.secondary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent),
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
      textTheme: const TextTheme(
              displayLarge: TextStyle(),
              displayMedium: TextStyle(),
              displaySmall: TextStyle(),
              titleLarge: TextStyle(),
              titleMedium: TextStyle(),
              titleSmall: TextStyle(),
              bodyLarge: TextStyle(),
              bodyMedium: TextStyle(),
              bodySmall: TextStyle())
          .apply(
        bodyColor: Colors.white,
      ),
      shadowColor: Colors.transparent,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent);
}
