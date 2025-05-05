import 'package:flutter/material.dart';

/// Spacing constants for the Global Remit iOS-style design system
class GlobalRemitSpacing {
  /// Private constructor to prevent instantiation
  GlobalRemitSpacing._();
  
  /// Insets
  static const double insetXS = 4.0;
  static const double insetS = 8.0;
  static const double insetM = 16.0;
  static const double insetL = 24.0;
  static const double insetXL = 32.0;
  static const double insetXXL = 40.0;
  
  /// Standard padding for screen content
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: insetL,
    vertical: insetM,
  );
  
  /// Standard padding for cards
  static const EdgeInsets cardPadding = EdgeInsets.all(insetM);
  
  /// Standard padding for list items
  static const EdgeInsets listItemPadding = EdgeInsets.symmetric(
    horizontal: insetM,
    vertical: insetL,
  );
  
  /// Standard padding for form fields
  static const EdgeInsets formFieldPadding = EdgeInsets.symmetric(
    horizontal: insetM,
    vertical: insetS,
  );
  
  /// Standard gap between form fields
  static const double formFieldGap = insetL;
  
  /// Standard gap between sections
  static const double sectionGap = insetXL;
  
  /// Standard gap between related items
  static const double relatedItemGap = insetM;
  
  /// Standard gap between unrelated items
  static const double unrelatedItemGap = insetL;
  
  /// Standard border radius for cards
  static const double cardBorderRadius = 13.0;
  
  /// Standard border radius for buttons
  static const double buttonBorderRadius = 24.0;
  
  /// Standard border radius for text fields
  static const double textFieldBorderRadius = 10.0;
  
  /// Standard border radius for modals
  static const double modalBorderRadius = 13.0;
  
  /// Standard elevation for cards
  static const double cardElevation = 1.0;
  
  /// Standard elevation for modals
  static const double modalElevation = 8.0;
  
  /// Standard icon sizes
  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
  
  /// Standard avatar sizes
  static const double avatarSizeSmall = 32.0;
  static const double avatarSizeMedium = 48.0;
  static const double avatarSizeLarge = 64.0;
  
  /// Returns a SizedBox with the specified height
  static SizedBox verticalSpace(double height) => SizedBox(height: height);
  
  /// Returns a SizedBox with the specified width
  static SizedBox horizontalSpace(double width) => SizedBox(width: width);
  
  /// Returns a responsive horizontal padding based on screen width
  static EdgeInsets responsiveHorizontalPadding(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    
    if (width < 375) {
      return const EdgeInsets.symmetric(horizontal: insetM);
    } else if (width < 768) {
      return const EdgeInsets.symmetric(horizontal: insetL);
    } else {
      return const EdgeInsets.symmetric(horizontal: insetXL);
    }
  }
}

/// Extension to easily access spacing constants from context
extension GlobalRemitSpacingExtension on BuildContext {
  /// Extra small inset (4.0)
  double get insetXS => GlobalRemitSpacing.insetXS;
  
  /// Small inset (8.0)
  double get insetS => GlobalRemitSpacing.insetS;
  
  /// Medium inset (16.0)
  double get insetM => GlobalRemitSpacing.insetM;
  
  /// Large inset (24.0)
  double get insetL => GlobalRemitSpacing.insetL;
  
  /// Extra large inset (32.0)
  double get insetXL => GlobalRemitSpacing.insetXL;
  
  /// Extra extra large inset (40.0)
  double get insetXXL => GlobalRemitSpacing.insetXXL;
  
  /// Standard padding for screen content
  EdgeInsets get screenPadding => GlobalRemitSpacing.screenPadding;
  
  /// Standard padding for cards
  EdgeInsets get cardPadding => GlobalRemitSpacing.cardPadding;
  
  /// Standard padding for list items
  EdgeInsets get listItemPadding => GlobalRemitSpacing.listItemPadding;
  
  /// Standard padding for form fields
  EdgeInsets get formFieldPadding => GlobalRemitSpacing.formFieldPadding;
  
  /// Standard gap between form fields
  double get formFieldGap => GlobalRemitSpacing.formFieldGap;
  
  /// Standard gap between sections
  double get sectionGap => GlobalRemitSpacing.sectionGap;
  
  /// Standard gap between related items
  double get relatedItemGap => GlobalRemitSpacing.relatedItemGap;
  
  /// Standard gap between unrelated items
  double get unrelatedItemGap => GlobalRemitSpacing.unrelatedItemGap;
  
  /// Standard border radius for cards
  double get cardBorderRadius => GlobalRemitSpacing.cardBorderRadius;
  
  /// Standard border radius for buttons
  double get buttonBorderRadius => GlobalRemitSpacing.buttonBorderRadius;
  
  /// Standard border radius for text fields
  double get textFieldBorderRadius => GlobalRemitSpacing.textFieldBorderRadius;
  
  /// Standard border radius for modals
  double get modalBorderRadius => GlobalRemitSpacing.modalBorderRadius;
  
  /// Standard elevation for cards
  double get cardElevation => GlobalRemitSpacing.cardElevation;
  
  /// Standard elevation for modals
  double get modalElevation => GlobalRemitSpacing.modalElevation;
  
  /// Standard icon sizes - small
  double get iconSizeSmall => GlobalRemitSpacing.iconSizeSmall;
  
  /// Standard icon sizes - medium
  double get iconSizeMedium => GlobalRemitSpacing.iconSizeMedium;
  
  /// Standard icon sizes - large
  double get iconSizeLarge => GlobalRemitSpacing.iconSizeLarge;
  
  /// Standard avatar sizes - small
  double get avatarSizeSmall => GlobalRemitSpacing.avatarSizeSmall;
  
  /// Standard avatar sizes - medium
  double get avatarSizeMedium => GlobalRemitSpacing.avatarSizeMedium;
  
  /// Standard avatar sizes - large
  double get avatarSizeLarge => GlobalRemitSpacing.avatarSizeLarge;
  
  /// Returns a responsive horizontal padding based on screen width
  EdgeInsets get responsiveHorizontalPadding => 
      GlobalRemitSpacing.responsiveHorizontalPadding(this);
      
  /// Returns a SizedBox with the specified height
  SizedBox verticalSpace(double height) => SizedBox(height: height);
  
  /// Returns a SizedBox with the specified width
  SizedBox horizontalSpace(double width) => SizedBox(width: width);
}