import 'package:fixit/auth/reset_password_screen.dart';
import 'package:fixit/utils/supabaseConfig.dart';
import 'package:fixit/controllers/auth_controller.dart';
import 'package:fixit/controllers/service_controller.dart';
import 'package:fixit/controllers/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'utils/app_theme.dart';
import 'screens/splash_screen.dart';
import 'dart:developer' as dev;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  dev.log('🚀 Initializing Fixit App', name: 'Main');

  // Initialize Supabase
  await Supabase.initialize(
    url: Supabaseconfig.supaBaseURL,
    anonKey: Supabaseconfig.supaBaseAnon,
  );

  dev.log('✅ Supabase initialized', name: 'Main');

  // Initialize GetX Controllers
  Get.put(AuthController());
  Get.put(ServiceController());
  Get.put(BookingController());

  dev.log('✅ GetX Controllers initialized', name: 'Main');

  // 🔥 PASSWORD RECOVERY LISTENER
  Supabase.instance.client.auth.onAuthStateChange.listen((data) {
    final event = data.event;

    dev.log('🔐 Auth Event: $event', name: 'Main');

    if (event == AuthChangeEvent.passwordRecovery) {
      Get.to(() => const ResetPasswordScreen());
    }
  });

  runApp(const FixitApp());
}

class FixitApp extends StatelessWidget {
  const FixitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Fixit',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
