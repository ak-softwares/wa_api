import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';

import '../features/chat/screens/messages/messages.dart';
import '../utils/constants/api_constants.dart';

class RoutesPath {
  static const home = '/';
  static const product = '/product/';
}


class AppRouter {

  static Route<dynamic>? handleRoute({required String route}) {

    // Chat
    final result = extractWhatsAppParams(route);
    final phone = result['phone'];
    final text = result['text'];
    if (phone != null) {
      return GetPageRoute(
          settings: RouteSettings(name: route), // important to uniquely identify route
          page: () => Messages(sessionId: phone, text: text)
      );
    }

    return null;
  }

  // Extracts slug from URL (e.g., '/918265849298?text=Hello+Aramarket,+I+have+a+question+about' → )
  static Map<String, String> extractWhatsAppParams(String route) {
    final uri = Uri.parse(route);

    final phone = uri.pathSegments.isNotEmpty ? uri.pathSegments[0] : '';
    final text = uri.queryParameters['text'] ?? '';

    return {
      'phone': phone,
      'text': Uri.decodeComponent(text), // Decodes + and %20
    };
  }


  // Normalizes deep links (e.g., "https://example.com/product/slug" → "/product/slug")
  static String normalizeRoute(String route) {
    final domain = APIConstant.domain;
    final baseUrls = ['https://$domain', 'http://$domain', domain, 'www.$domain'];
    for (final baseUrl in baseUrls) {
      if (route.startsWith(baseUrl)) {
        return route.substring(baseUrl.length);
      }
    }
    return route;
  }

  static bool checkIsDomainContain(String route) {
    final domain = APIConstant.domain;
    return route.contains(domain);
  }

}