/* 
 * Palettes:
 * Primary: #FA5C5C
 * Secondary: #FD8A6B
 * Tertiary Light: #FFF3EB
 * Tertiary: #FEC288
 * Dark: #334155
 */

import 'package:flutter/material.dart';

class AppPalette {
  // * Hex Code to Color Converter
  static Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  // * Color Palette
  static final primary = hexToColor("#FA5C5C");
  static final secondary = hexToColor("#FD8A6B");
  static final tertiaryLight = hexToColor("#FFF3EB");
  static final tertiary = hexToColor("#FEC288");
  static final dark = hexToColor("#334155");

  // * Gradients
  static final primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment(0.8, 1),
    colors: <Color>[secondary, primary],
    tileMode: TileMode.mirror,
  );
}
