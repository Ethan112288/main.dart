//palette.dart
import 'package:flutter/material.dart';
class Palette {

  // https://api.flutter.dev/flutter/material/Colors/pink-constant.html
  static const MaterialColor pink = MaterialColor(
    0xFFE91E63,
    <int, Color>{
      50: Color(0xFFFCE4EC),
      100: Color(0xFFF8BBD0),
      200: Color(0xFFF48FB1),
      300: Color(0xFFF06292),
      400: Color(0xFFEC407A),
      500: Color(0xFFE91E63),
      600: Color(0xFFD81B60),
      700: Color(0xFFC2185B),
      800: Color(0xFFAD1457),
      900: Color(0xFF880E4F),
    },
  );

  // https://api.flutter.dev/flutter/material/Colors/pink-constant.html
  static const MaterialColor red = MaterialColor(
    0xFFF44336,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFF44336),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );

  static const MaterialColor tiffanyBlue = const MaterialColor(
    0xff86FFFF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xffFFFFFF),//10%
      100: const Color(0xffFFFFFF),//20%
      200: const Color(0xffFFFFFF),//30%
      300: const Color(0xffE3FFFF),//40%
      400: const Color(0xffC4FFFF),//50%
      500: const Color(0xffA5FFFF),//60%
      600: const Color(0xff86FFFF),//70%
      700: const Color(0xff66F3ED),//80%
      800: const Color(0xff43D6D1),//90%
      900: const Color(0xff0ABAB5),//100%
    },
  );
  static const MaterialColor umBlue = const MaterialColor(
    0xff00274c, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff002344),//10%
      100: const Color(0xff001f3d),//20%
      200: const Color(0xff001b35),//30%
      300: const Color(0xff00172e),//40%
      400: const Color(0xff001426),//50%
      500: const Color(0xff00101e),//60%
      600: const Color(0xff000c17),//70%
      700: const Color(0xff00080f),//80%
      800: const Color(0xff000408),//90%
      900: const Color(0xff000000),//100%
    },
  );
  static const MaterialColor umMaize = const MaterialColor(
    0xffffcb05, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff6b705),//10%
      100: const Color(0xffca204),//20%
      200: const Color(0xff38e04),//30%
      300: const Color(0xff97a03),//40%
      400: const Color(0xff06603),//50%
      500: const Color(0xffc3d01),//60%
      600: const Color(0xffc3d01),//70%
      700: const Color(0xff32901),//80%
      800: const Color(0xff91400),//90%
      900: const Color(0xff000000),//100%
    },
  );
} // you can define define int 500 as the default shade and add your lighter tints above and darker tints below.
