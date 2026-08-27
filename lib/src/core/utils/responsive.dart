import 'package:flutter/widgets.dart';

import '../constants/app_constants.dart';

enum AppScreenSize { mobile, tablet, desktop }

class Responsive {
  Responsive._();

  static AppScreenSize screenSizeOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < AppConstants.mobileBreakpoint) {
      return AppScreenSize.mobile;
    }
    if (width < AppConstants.tabletBreakpoint) {
      return AppScreenSize.tablet;
    }
    return AppScreenSize.desktop;
  }

  static bool isMobile(BuildContext context) =>
      screenSizeOf(context) == AppScreenSize.mobile;

  static bool isTablet(BuildContext context) =>
      screenSizeOf(context) == AppScreenSize.tablet;

  static bool isDesktop(BuildContext context) =>
      screenSizeOf(context) == AppScreenSize.desktop;

  static bool useBottomNav(BuildContext context) => isMobile(context);

  static double horizontalPadding(BuildContext context) {
    switch (screenSizeOf(context)) {
      case AppScreenSize.mobile:
        return 16;
      case AppScreenSize.tablet:
        return 24;
      case AppScreenSize.desktop:
        return 32;
    }
  }

  static double contentMaxWidth(BuildContext context) {
    switch (screenSizeOf(context)) {
      case AppScreenSize.mobile:
        return double.infinity;
      case AppScreenSize.tablet:
        return 720;
      case AppScreenSize.desktop:
        return AppConstants.maxContentWidth;
    }
  }
}

class ResponsiveBuilder extends StatelessWidget {
  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  final WidgetBuilder mobile;
  final WidgetBuilder? tablet;
  final WidgetBuilder? desktop;

  @override
  Widget build(BuildContext context) {
    switch (Responsive.screenSizeOf(context)) {
      case AppScreenSize.desktop:
        return (desktop ?? tablet ?? mobile)(context);
      case AppScreenSize.tablet:
        return (tablet ?? mobile)(context);
      case AppScreenSize.mobile:
        return mobile(context);
    }
  }
}
