import 'package:flutter/material.dart';

const defaultFontFamily = '';

class AppLightTheme {
  static const Color primary = Color(0xFF4b39ef);
  static const Color secondary = Color(0xFFF2F1F1);
  static const Color tertiary = Color(0xFF39D2C0);
  static const Color alternate = Color(0xFF4b39ef);

  static const Color primaryBG = Color(0xFFF1F4F8);
  static const Color secondaryBG = Colors.white;

  static const Color primaryText = Color(0xFF1A1F24);
  static const Color secondaryText = Color(0xFF8B97A2);

  static const ColorScheme colorScheme = ColorScheme.light(
      primary: Color(0xFF4b39ef),
      secondary: Color(0xFFF2F1F1),
      tertiary: Color(0xFF39D2C0),
      background: Color(0xFFF1F4F8),
      surface: Color(0xFFFFFFFF),
      outline: primaryText);

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
        color: primaryText, fontSize: 57, fontWeight: FontWeight.w700),
    displayMedium: TextStyle(
        color: primaryText, fontSize: 45, fontWeight: FontWeight.w700),
    displaySmall: TextStyle(
        color: primaryText, fontSize: 36, fontWeight: FontWeight.w700),
    headlineLarge: TextStyle(
        color: primaryText, fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(
        color: primaryText, fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(
        color: primaryText, fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(
        color: primaryText, fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(
        color: primaryText, fontSize: 20, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(
        color: secondaryText, fontSize: 18, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(
        color: primaryText, fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(
        color: primaryText, fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
        color: secondaryText, fontSize: 12, fontWeight: FontWeight.w400),
    // button
    labelLarge: TextStyle(
        color: primaryText, fontSize: 18, fontWeight: FontWeight.w500),
    // caption
    labelMedium: TextStyle(
        color: primaryText, fontSize: 14, fontWeight: FontWeight.w500),
    // overline
    labelSmall: TextStyle(
        color: secondaryText, fontSize: 12, fontWeight: FontWeight.w500),
  );

  static final theme = ThemeData(
    scaffoldBackgroundColor: primaryBG,
    backgroundColor: secondaryBG,
    brightness: Brightness.light,
    primaryColor: primary,
    secondaryHeaderColor: secondary,
    // 사용할 폰트
    fontFamily: 'Poppins',
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: secondaryBG),
    buttonTheme:
        const ButtonThemeData(buttonColor: primary, colorScheme: colorScheme),
    cardTheme: const CardTheme(color: secondaryBG, elevation: 1),
    iconTheme: const IconThemeData(color: primaryText, size: 30),
    // 텍스트 테마 설정
    // https://api.flutter.dev/flutter/material/TextTheme-class.html
    // https://material.io/design/typography/the-type-system.html#applying-the-type-scale
    textTheme: textTheme,
    colorScheme: colorScheme,
    disabledColor: const Color.fromARGB(255, 190, 190, 190),
    focusColor: const Color.fromARGB(255, 44, 62, 80),
  );
}

class AppDarkTheme {
  static const Color primary = Color(0xFF4b39ef);
  static const Color secondary = Color(0xff313030);
  static const Color tertiary = Color(0xff39D2C0);
  static const Color alternate = Colors.white;

  static const Color primaryBG = Color(0xFF1A1F24);
  static const Color secondaryBG = Color(0xFF111417);

  static const Color primaryText = Colors.white;
  static const Color secondaryText = Color(0xFF8b97A2);

  static const ColorScheme colorScheme = ColorScheme.dark(
      primary: Color(0xff4b39ef),
      secondary: Color(0xff313030),
      tertiary: Color(0xff39D2C0),
      background: Color(0xFF1A1F24),
      surface: Color(0xFF111417));

  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(
        color: primaryText, fontSize: 57, fontWeight: FontWeight.w700),
    displayMedium: TextStyle(
        color: primaryText, fontSize: 45, fontWeight: FontWeight.w700),
    displaySmall: TextStyle(
        color: primaryText, fontSize: 36, fontWeight: FontWeight.w700),
    headlineLarge: TextStyle(
        color: primaryText, fontSize: 32, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(
        color: primaryText, fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(
        color: primaryText, fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(
        color: primaryText, fontSize: 22, fontWeight: FontWeight.w500),
    titleMedium: TextStyle(
        color: primaryText, fontSize: 20, fontWeight: FontWeight.w500),
    titleSmall: TextStyle(
        color: secondaryText, fontSize: 18, fontWeight: FontWeight.w500),
    bodyLarge: TextStyle(
        color: primaryText, fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: TextStyle(
        color: primaryText, fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(
        color: secondaryText, fontSize: 12, fontWeight: FontWeight.w400),
    // button
    labelLarge: TextStyle(
        color: primaryText, fontSize: 18, fontWeight: FontWeight.w500),
    // caption
    labelMedium: TextStyle(
        color: primaryText, fontSize: 14, fontWeight: FontWeight.w500),
    // overline
    labelSmall: TextStyle(
        color: secondaryText, fontSize: 12, fontWeight: FontWeight.w500),
  );

  static final theme = ThemeData(
    scaffoldBackgroundColor: primaryBG,
    backgroundColor: secondaryBG,
    brightness: Brightness.dark,
    primaryColor: primary,
    secondaryHeaderColor: secondary,
    // 사용할 폰트
    fontFamily: 'Poppins',
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: secondaryBG),
    buttonTheme:
        const ButtonThemeData(buttonColor: primary, colorScheme: colorScheme),
    cardTheme: const CardTheme(color: secondaryBG, elevation: 1),
    iconTheme: const IconThemeData(color: primaryText, size: 30),
    // 텍스트 테마 설정
    // https://api.flutter.dev/flutter/material/TextTheme-class.html
    // https://material.io/design/typography/the-type-system.html#applying-the-type-scale
    textTheme: textTheme,
    colorScheme: colorScheme,
    disabledColor: const Color.fromARGB(255, 190, 190, 190),
    focusColor: const Color.fromARGB(255, 44, 62, 80),
  );
}
