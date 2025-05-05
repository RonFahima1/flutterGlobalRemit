import 'package:flutter/material.dart';

// Light theme color scheme
const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF0A84FF),       // iOS blue
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFD1E4FF),
  onPrimaryContainer: Color(0xFF001D36),
  secondary: Color(0xFF5856D6),     // iOS purple
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFE5E1FF),
  onSecondaryContainer: Color(0xFF120F68),
  tertiary: Color(0xFF34C759),      // iOS green
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFABF5BE),
  onTertiaryContainer: Color(0xFF002113),
  error: Color(0xFFFF3B30),         // iOS red
  onError: Colors.white,
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF410002),
  background: Colors.white,
  onBackground: Colors.black,
  surface: Colors.white,
  onSurface: Colors.black,
  surfaceVariant: Color(0xFFF2F2F7), // iOS system gray 6
  onSurfaceVariant: Color(0xFF757575),
  outline: Color(0xFFE5E5EA),        // iOS system gray 5
  outlineVariant: Color(0xFFD1D1D6), // iOS system gray 4
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Color(0xFF121212),
  onInverseSurface: Colors.white,
  inversePrimary: Color(0xFF9ECAFF),
  surfaceTint: Color(0xFF0A84FF),
);

// Dark theme color scheme
const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF0A84FF),       // iOS blue
  onPrimary: Colors.white,
  primaryContainer: Color(0xFF00325A),
  onPrimaryContainer: Color(0xFFD1E4FF),
  secondary: Color(0xFF5856D6),     // iOS purple
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF373583),
  onSecondaryContainer: Color(0xFFE5E1FF),
  tertiary: Color(0xFF34C759),      // iOS green
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFF00592F),
  onTertiaryContainer: Color(0xFFABF5BE),
  error: Color(0xFFFF3B30),         // iOS red
  onError: Colors.white,
  errorContainer: Color(0xFF8C0009),
  onErrorContainer: Color(0xFFFFDAD6),
  background: Color(0xFF121212),
  onBackground: Colors.white,
  surface: Color(0xFF1C1C1E),       // iOS dark gray
  onSurface: Colors.white,
  surfaceVariant: Color(0xFF2C2C2E), // iOS system gray 6 (dark)
  onSurfaceVariant: Color(0xFFAEAEAE),
  outline: Color(0xFF3A3A3C),        // iOS system gray 5 (dark)
  outlineVariant: Color(0xFF48484A), // iOS system gray 4 (dark)
  shadow: Colors.black,
  scrim: Colors.black,
  inverseSurface: Colors.white,
  onInverseSurface: Color(0xFF121212),
  inversePrimary: Color(0xFF0A84FF),
  surfaceTint: Color(0xFF0A84FF),
);
