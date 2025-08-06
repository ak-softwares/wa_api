import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:wa_api/services/notification/firebase_notification.dart';

import 'bindings/general_bindings.dart';
import 'common/navigation_bar/bottom_navigation_bar.dart';
import 'features/authentication/controllers/authentication_controller/authentication_controller.dart';
import 'features/authentication/screens/phone_otp_login/mobile_login_screen.dart';
import 'features/settings/app_settings.dart';
import 'firebase_options.dart';
import 'routes/external_routes.dart';
import 'routes/internal_routes.dart';
import 'services/app_update/app_update.dart';
import 'services/notification/local_notification.dart';
import 'utils/helpers/navigation_helper.dart';
import 'utils/theme/ThemeController.dart';
import 'utils/theme/theme.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase.initializeApp(); // Optional if you're using Firebase services here
  FirebaseNotification.handleMassage(message);
}


// Theme.of(context).colorScheme.outline
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize only Firebase here (required before runApp if used)
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);

  await dotenv.load(fileName: ".env");
  await GetStorage.init();
  await AppSettings.init();
  await FirebaseNotification.initNotification();
  await AppUpdate.checkForUpdate();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // ✅ Handle app launch via local notification (cold start)
  final details = await LocalNotificationServices
      .localNotificationsPlugin
      .getNotificationAppLaunchDetails();

  if (details?.didNotificationLaunchApp ?? false) {
    final payload = details!.notificationResponse?.payload;
    if (payload != null && payload.isNotEmpty) {
      InternalAppRoutes.handleInternalRoute(url: payload);
    }
  }

  // ✅ Initialize local notifications and handle taps
  LocalNotificationServices.localNotificationsPlugin.initialize(
    LocalNotificationServices.initializationSettings,

    // When app is open or in background
    onDidReceiveNotificationResponse: (response) {
      if (response.payload != null && response.payload!.isNotEmpty) {
        InternalAppRoutes.handleInternalRoute(url: response.payload!);
      }
    },

    // ❌ This line is **not needed** in most cases
    // `onDidReceiveNotificationResponse` already handles background taps

    // ✅ Only needed for Android 12+ if you want **separate** handling
    // ✅ Keep only if you have different logic — optional
    onDidReceiveBackgroundNotificationResponse: (response) {
      if (response.payload != null && response.payload!.isNotEmpty) {
        InternalAppRoutes.handleInternalRoute(url: response.payload!);
      }
    },
  );


  // await MongoDatabase.connect();
  // await UsersMongoDatabase.connect();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    // Initialize your auth controller
    final auth = Get.put(AuthenticationController());
    final isAdmin = auth.isAdminLogin.value;

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppSettings.appName,
      theme: AppAppTheme.lightTheme,
      darkTheme: AppAppTheme.darkTheme,
      themeMode: themeController.themeMode.value,
      initialBinding: GeneralBindings(),
      home: isAdmin ? const BottomNavigation() : const MobileLoginScreen(), // Splash/Initializer screen
      onGenerateRoute: (settings) {
        return ExternalAppRoutes.handleDeepLink(settings: settings)
            ?? MaterialPageRoute(builder: (_) => NavigationHelper.navigateToBottomNavigationWidget());
      },
    );
  }
}
