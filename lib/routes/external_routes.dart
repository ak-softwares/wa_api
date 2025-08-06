import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';

import '../common/navigation_bar/bottom_navigation_bar.dart';
import 'routes.dart';

class ExternalAppRoutes {

  static Route<dynamic>? handleDeepLink({required RouteSettings settings}) {
    final route = AppRouter.normalizeRoute(settings.name ?? '/'); // this gives /product/product-name/?scr=google
    // if app closed then go to home first then go to target screen
    if (AppRouter.checkIsDomainContain(settings.name ?? '')) {
      return GetPageRoute(page: () => BottomNavigation(route: route));
    }
    // if app open then directly go to target screen
    return AppRouter.handleRoute(route: route);
  }

}