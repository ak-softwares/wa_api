import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import 'routes.dart';

class InternalAppRoutes {

  static void handleInternalRoute({required String url}) {
    final normalizeRoute = AppRouter.normalizeRoute(url);
    if (!AppRouter.checkIsDomainContain(url)) return;
    final route = AppRouter.handleRoute(route: normalizeRoute);
    // if (route != null) Get.to(route);
    if(route != null) Navigator.push(Get.context!, route);
  }
}
