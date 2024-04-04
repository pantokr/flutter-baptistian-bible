import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum Palette {
  black,
  white,
  grey,
  amber,
}

class TextStyles {
  static TextStyle getAppBarTextStyle() =>
      GoogleFonts.nanumGothicCoding(fontSize: 16, color: Colors.white);

  static TextStyle getSystemTextStyle() => const TextStyle(fontSize: 16);
}

class BoxStyles {
  static BoxDecoration getMenuBoxStyle(Color color) {
    return BoxDecoration(color: color, borderRadius: BorderRadius.circular(8));
  }
}

class ButtonStyles {
  static ButtonStyle getElevatedButtonStyle(
      double width, double height, Color color) {
    return ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        alignment: Alignment.center,
        elevation: 4,
        backgroundColor: color,
        padding: const EdgeInsets.all(0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)));
  }
}
