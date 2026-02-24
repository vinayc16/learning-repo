import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

class AppFonts {
  // Font family names as constants
  static final String roboto = 'Roboto';
  static final String montserrat = 'Montserrat';
  static final String openSans = 'Open Sans';
  static final String poppins = 'Poppins';
  static final String lato = 'Lato';
  static final String nunito = 'Nunito';
  static final String raleway = 'Raleway';
  static final String quicksand = 'Quicksand';
  static final String merriweather = 'Merriweather';
  static final String playfairDisplay = 'Playfair Display';
  static final String ubuntu = 'Ubuntu';
  static final String dancingScript = 'Dancing Script';
  static final String indieFlower = 'Indie Flower';
  static final String josefinSans = 'Josefin Sans';
  static final String oswald = 'Oswald';
  static final String pacifico = 'Pacifico';
  static final String rubik = 'Rubik';
  static final String comfortaa = 'Comfortaa';
  static final String exo = 'Exo';
  static final String baloo = 'Baloo';
  static final String playfair = 'Playfair';
  // static final String quicksand = 'quicksand';

  // Optional: Method to get TextStyle using these constants
  static TextStyle getFont({
    required String fontFamily,
    double? fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
  }) {
    return GoogleFonts.getFont(
      fontFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}