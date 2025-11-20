import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';

/// App Theme - Main Theme Configuration
class AppTheme {
  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color Scheme
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryGreen,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryGreenLight,
      onPrimaryContainer: AppColors.neutralBlack,
      
      secondary: AppColors.secondaryOrange,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryOrangeLight,
      onSecondaryContainer: AppColors.neutralBlack,
      
      error: AppColors.errorRed,
      onError: AppColors.neutralWhite,
      errorContainer: Color(0xFFFFCDD2),
      onErrorContainer: AppColors.neutralBlack,
      
      background: AppColors.background,
      onBackground: AppColors.onBackground,
      
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      
      surfaceVariant: AppColors.neutralLightGray,
      onSurfaceVariant: AppColors.neutralDarkGray,
      
      outline: AppColors.neutralGray,
      shadow: AppColors.shadow,
    ),
    
    // Scaffold
    scaffoldBackgroundColor: AppColors.background,
    
    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.neutralWhite,
      foregroundColor: AppColors.neutralBlack,
      elevation: AppSpacing.elevationNone,
      centerTitle: true,
      titleTextStyle: AppTypography.h5.copyWith(
        color: AppColors.neutralBlack,
        fontWeight: AppTypography.semiBold,
      ),
      iconTheme: const IconThemeData(
        color: AppColors.neutralBlack,
        size: AppSpacing.iconMD,
      ),
    ),
    
    // Card Theme
    cardTheme: CardThemeData(
      color: AppColors.neutralWhite,
      elevation: AppSpacing.elevationLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMD),
      ),
      margin: const EdgeInsets.all(AppSpacing.marginSM),
    ),
    
    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.neutralWhite,
        elevation: AppSpacing.elevationLow,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingLG,
          vertical: AppSpacing.paddingMD,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        ),
        textStyle: AppTypography.button,
        minimumSize: const Size(0, AppSpacing.buttonHeightMD),
      ),
    ),
    
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        side: const BorderSide(color: AppColors.primaryGreen, width: 1.5),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingLG,
          vertical: AppSpacing.paddingMD,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        ),
        textStyle: AppTypography.button,
        minimumSize: const Size(0, AppSpacing.buttonHeightMD),
      ),
    ),
    
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryGreen,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.paddingMD,
          vertical: AppSpacing.paddingSM,
        ),
        textStyle: AppTypography.button,
      ),
    ),
    
    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.neutralLightGray,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingMD,
        vertical: AppSpacing.paddingMD,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.neutralGray),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.neutralGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.primaryGreen, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.errorRed),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSM),
        borderSide: const BorderSide(color: AppColors.errorRed, width: 2),
      ),
      labelStyle: AppTypography.bodyMedium,
      hintStyle: AppTypography.bodyMedium.copyWith(
        color: AppColors.neutralGray,
      ),
      errorStyle: AppTypography.bodySmall.copyWith(
        color: AppColors.errorRed,
      ),
    ),
    
    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.neutralDarkGray,
      size: AppSpacing.iconMD,
    ),
    
    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: AppColors.neutralWhite,
      elevation: AppSpacing.elevationMedium,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLG),
      ),
    ),
    
    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.neutralWhite,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: AppColors.neutralGray,
      type: BottomNavigationBarType.fixed,
      elevation: AppSpacing.elevationMedium,
      selectedLabelStyle: TextStyle(
        fontSize: AppTypography.bodySmallSize,
        fontWeight: AppTypography.medium,
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: AppTypography.bodySmallSize,
        fontWeight: AppTypography.regular,
      ),
    ),
    
    // Divider Theme
    dividerTheme: const DividerThemeData(
      color: AppColors.neutralGray,
      thickness: 1,
      space: AppSpacing.md,
    ),
    
    // Chip Theme
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.neutralLightGray,
      deleteIconColor: AppColors.neutralDarkGray,
      labelStyle: AppTypography.bodySmall,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.paddingSM,
        vertical: AppSpacing.paddingXS,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusRound),
      ),
    ),
    
    // Text Theme
    textTheme: TextTheme(
      displayLarge: AppTypography.h1,
      displayMedium: AppTypography.h2,
      displaySmall: AppTypography.h3,
      headlineMedium: AppTypography.h4,
      headlineSmall: AppTypography.h5,
      titleLarge: AppTypography.h6,
      bodyLarge: AppTypography.bodyLarge,
      bodyMedium: AppTypography.bodyMedium,
      bodySmall: AppTypography.bodySmall,
      labelLarge: AppTypography.button,
      labelMedium: AppTypography.label,
      labelSmall: AppTypography.caption,
    ),
  );
  
  // Dark Theme (for future implementation)
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    // TODO: Implement dark theme
  );
}
