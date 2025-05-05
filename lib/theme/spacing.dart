import 'package:flutter/material.dart';

/// GlobalRemit Spacing - Following iOS Design Guidelines
/// This class defines spacing constants for consistent UI layout
class GlobalRemitSpacing {
  // Inset (padding/margin) values
  static const double insetXXS = 2.0;
  static const double insetXS = 4.0;
  static const double insetS = 8.0;
  static const double insetM = 16.0;
  static const double insetL = 24.0;
  static const double insetXL = 32.0;
  static const double insetXXL = 40.0;

  // Standard spacing between sections
  static const double sectionS = 8.0;
  static const double sectionM = 16.0;
  static const double sectionL = 24.0;
  static const double sectionXL = 32.0;
  static const double sectionXXL = 40.0;

  // Paddings
  static const EdgeInsets paddingXXS = EdgeInsets.all(insetXXS);
  static const EdgeInsets paddingXS = EdgeInsets.all(insetXS);
  static const EdgeInsets paddingS = EdgeInsets.all(insetS);
  static const EdgeInsets paddingM = EdgeInsets.all(insetM);
  static const EdgeInsets paddingL = EdgeInsets.all(insetL);
  static const EdgeInsets paddingXL = EdgeInsets.all(insetXL);
  static const EdgeInsets paddingXXL = EdgeInsets.all(insetXXL);

  // Horizontal paddings
  static const EdgeInsets paddingHorizontalXXS = EdgeInsets.symmetric(horizontal: insetXXS);
  static const EdgeInsets paddingHorizontalXS = EdgeInsets.symmetric(horizontal: insetXS);
  static const EdgeInsets paddingHorizontalS = EdgeInsets.symmetric(horizontal: insetS);
  static const EdgeInsets paddingHorizontalM = EdgeInsets.symmetric(horizontal: insetM);
  static const EdgeInsets paddingHorizontalL = EdgeInsets.symmetric(horizontal: insetL);
  static const EdgeInsets paddingHorizontalXL = EdgeInsets.symmetric(horizontal: insetXL);
  static const EdgeInsets paddingHorizontalXXL = EdgeInsets.symmetric(horizontal: insetXXL);

  // Vertical paddings
  static const EdgeInsets paddingVerticalXXS = EdgeInsets.symmetric(vertical: insetXXS);
  static const EdgeInsets paddingVerticalXS = EdgeInsets.symmetric(vertical: insetXS);
  static const EdgeInsets paddingVerticalS = EdgeInsets.symmetric(vertical: insetS);
  static const EdgeInsets paddingVerticalM = EdgeInsets.symmetric(vertical: insetM);
  static const EdgeInsets paddingVerticalL = EdgeInsets.symmetric(vertical: insetL);
  static const EdgeInsets paddingVerticalXL = EdgeInsets.symmetric(vertical: insetXL);
  static const EdgeInsets paddingVerticalXXL = EdgeInsets.symmetric(vertical: insetXXL);

  // Border radius values
  static const double borderRadiusXS = 4.0;
  static const double borderRadiusS = 8.0;
  static const double borderRadiusM = 12.0;
  static const double borderRadiusL = 16.0;
  static const double borderRadiusXL = 20.0;
  static const double borderRadiusXXL = 28.0;
  static const double cardBorderRadius = 10.0; // iOS standard card border radius
  static const double pillButtonRadius = 22.0; // iOS standard pill button radius

  // Card elevations
  static const double elevationNone = 0.0;
  static const double elevationXS = 1.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;

  // Standard icon sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 40.0;

  // Button sizing
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 44.0; // iOS standard button height
  static const double buttonHeightL = 56.0;
  static const double buttonIconSize = 24.0;
  static const double buttonBorderRadius = 8.0;
  
  // Standard heights
  static const double navigationBarHeight = 44.0;
  static const double navBarLargeHeight = 96.0;
  static const double tabBarHeight = 49.0;
  static const double toolbarHeight = 44.0;
  static const double inputHeight = 44.0; // iOS standard input field height
  
  // Standard element sizing
  static const double avatarSizeS = 32.0;
  static const double avatarSizeM = 40.0;
  static const double avatarSizeL = 56.0;
  static const double avatarSizeXL = 80.0;

  // Screen margin (safe area)
  static const double screenMargin = 16.0;
  
  // Standard paddings for different containers
  static EdgeInsets get screenPadding => const EdgeInsets.all(screenMargin);
  
  static EdgeInsets get cardPadding => const EdgeInsets.all(insetM);
  
  static EdgeInsets get listItemPadding => const EdgeInsets.symmetric(
    horizontal: insetM,
    vertical: insetS,
  );
  
  static EdgeInsets get formFieldPadding => const EdgeInsets.symmetric(
    horizontal: insetM,
    vertical: insetS,
  );
  
  // Helper methods for responsive spacing
  static double responsiveInsetM(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return insetL;
    } else {
      return insetM;
    }
  }
  
  static EdgeInsets responsiveScreenPadding(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    if (width > 600) {
      return const EdgeInsets.all(insetL);
    } else {
      return const EdgeInsets.all(screenMargin);
    }
  }
}
