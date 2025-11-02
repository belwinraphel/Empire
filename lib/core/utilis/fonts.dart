import 'package:flutter/material.dart';

class Fonts {
  Fonts();
  static const String raleway = 'Raleway';
  static const String ralewaySemibold = 'Raleway-Semibold';
  static const String ralewayBold = ' Raleway-Bold';
  static const String ralewayExtraBold = 'Raleway-ExtraBold';
  static const String celiasbold = 'celias-bold';
  static const String celiasregular = 'celias-regular';
  static const String celiasmediumbold = 'celias-medium';
    static const String momoSignature = 'MomoSignature-regular';
}

double responsiveWidth(BuildContext context, double designWidth) {
  double screenWidth = MediaQuery.of(context).size.width;
  return (designWidth / 403) * screenWidth;
}
  