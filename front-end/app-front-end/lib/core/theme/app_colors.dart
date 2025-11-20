import 'package:flutter/material.dart';

/// App Color Palette - Modern, Sustainable, Clean
class AppColors {
  // Primary Colors - Green (Eco-Friendly & Fresh)
  static const Color primaryGreen = Color(0xff307A59); // Main Green
  static const Color primaryGreenLight = Color(0xFF81C784); // Light Green
  static const Color primaryGreenDark = Color(0xFF388E3C); // Dark Green
  
  // Secondary Colors - Orange (Energy & Action)
  static const Color secondaryOrange = Color(0xFFFF9800); // Main Orange
  static const Color secondaryOrangeLight = Color(0xFFFFB74D); // Light Orange
  static const Color secondaryOrangeDark = Color(0xFFF57C00); // Dark Orange
  
  // Neutral Colors - Professional & Clean
  static const Color neutralWhite = Color(0xFFFFFFFF); // Pure White
  static const Color neutralLightGray = Color(0xFFF5F5F5); // Light Gray (Backgrounds)
  static const Color neutralGray = Color(0xFF9E9E9E); // Gray (Borders & Secondary Text)
  static const Color neutralDarkGray = Color(0xFF616161); // Dark Gray (Text)
  static const Color neutralBlack = Color(0xFF212121); // Near Black (Primary Text)
  
  // Success & Alert Colors
  static const Color successGreen = Color(0xFF66BB6A); // Success Messages
  static const Color errorRed = Color(0xFFE53935); // Errors & Warnings
  static const Color warningYellow = Color(0xFFFFC107); // Warnings & Info
  static const Color infoBlue = Color(0xFF42A5F5); // Info Messages
  
  // Additional Semantic Colors
  static const Color background = neutralWhite;
  static const Color surface = neutralLightGray;
  static const Color onPrimary = neutralWhite;
  static const Color onSecondary = neutralWhite;
  static const Color onBackground = neutralBlack;
  static const Color onSurface = neutralDarkGray;
  
  // Disabled States
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color disabledText = Color(0xFF9E9E9E);
  
  // Shadow and Overlay
  static const Color shadow = Color(0x1A000000); // 10% opacity
  static const Color overlay = Color(0x80000000); // 50% opacity
  
  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGreen, primaryGreenDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [secondaryOrange, secondaryOrangeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
