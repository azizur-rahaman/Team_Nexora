import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography System - Clean, Modern & Readable
class AppTypography {
  // Font Family
  static const String primaryFont = 'Roboto';
  static const String secondaryFont = 'Poppins';
  
  // Font Sizes
  static const double h1Size = 32.0;
  static const double h2Size = 28.0;
  static const double h3Size = 24.0;
  static const double h4Size = 20.0;
  static const double h5Size = 18.0;
  static const double h6Size = 16.0;
  static const double bodyLargeSize = 16.0;
  static const double bodyMediumSize = 14.0;
  static const double bodySmallSize = 12.0;
  static const double captionSize = 10.0;
  
  // Font Weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  
  // Letter Spacing
  static const double tightSpacing = -0.5;
  static const double normalSpacing = 0.0;
  static const double wideSpacing = 0.5;
  static const double extraWideSpacing = 1.0;
  
  // Line Height
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightLoose = 1.8;
  
  // Headline Styles
  static TextStyle h1 = const TextStyle(
    fontSize: h1Size,
    fontWeight: bold,
    fontFamily: primaryFont,
    color: AppColors.neutralBlack,
    letterSpacing: tightSpacing,
    height: lineHeightTight,
  );
  
  static TextStyle h2 = const TextStyle(
    fontSize: h2Size,
    fontWeight: bold,
    fontFamily: primaryFont,
    color: AppColors.neutralBlack,
    letterSpacing: tightSpacing,
    height: lineHeightTight,
  );
  
  static TextStyle h3 = const TextStyle(
    fontSize: h3Size,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    color: AppColors.neutralBlack,
    letterSpacing: normalSpacing,
    height: lineHeightTight,
  );
  
  static TextStyle h4 = const TextStyle(
    fontSize: h4Size,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    color: AppColors.neutralBlack,
    letterSpacing: normalSpacing,
    height: lineHeightNormal,
  );
  
  static TextStyle h5 = const TextStyle(
    fontSize: h5Size,
    fontWeight: medium,
    fontFamily: primaryFont,
    color: AppColors.neutralBlack,
    letterSpacing: normalSpacing,
    height: lineHeightNormal,
  );
  
  static TextStyle h6 = const TextStyle(
    fontSize: h6Size,
    fontWeight: medium,
    fontFamily: primaryFont,
    color: AppColors.neutralBlack,
    letterSpacing: wideSpacing,
    height: lineHeightNormal,
  );
  
  // Body Styles
  static TextStyle bodyLarge = const TextStyle(
    fontSize: bodyLargeSize,
    fontWeight: regular,
    fontFamily: primaryFont,
    color: AppColors.neutralDarkGray,
    letterSpacing: wideSpacing,
    height: lineHeightNormal,
  );
  
  static TextStyle bodyMedium = const TextStyle(
    fontSize: bodyMediumSize,
    fontWeight: regular,
    fontFamily: primaryFont,
    color: AppColors.neutralDarkGray,
    letterSpacing: normalSpacing,
    height: lineHeightNormal,
  );
  
  static TextStyle bodySmall = const TextStyle(
    fontSize: bodySmallSize,
    fontWeight: regular,
    fontFamily: primaryFont,
    color: AppColors.neutralGray,
    letterSpacing: normalSpacing,
    height: lineHeightNormal,
  );
  
  // Button Styles
  static TextStyle button = const TextStyle(
    fontSize: bodyMediumSize,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    color: AppColors.neutralWhite,
    letterSpacing: wideSpacing,
  );
  
  static TextStyle buttonLarge = const TextStyle(
    fontSize: bodyLargeSize,
    fontWeight: semiBold,
    fontFamily: primaryFont,
    color: AppColors.neutralWhite,
    letterSpacing: wideSpacing,
  );
  
  // Caption & Label Styles
  static TextStyle caption = const TextStyle(
    fontSize: captionSize,
    fontWeight: regular,
    fontFamily: primaryFont,
    color: AppColors.neutralGray,
    letterSpacing: wideSpacing,
    height: lineHeightNormal,
  );
  
  static TextStyle label = const TextStyle(
    fontSize: bodySmallSize,
    fontWeight: medium,
    fontFamily: primaryFont,
    color: AppColors.neutralDarkGray,
    letterSpacing: wideSpacing,
  );
  
  // Link Style
  static TextStyle link = const TextStyle(
    fontSize: bodyMediumSize,
    fontWeight: medium,
    fontFamily: primaryFont,
    color: AppColors.primaryGreen,
    letterSpacing: normalSpacing,
    decoration: TextDecoration.underline,
  );
}
