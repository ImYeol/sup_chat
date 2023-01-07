import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sup_chat/bindings/add_friend_binding.dart';
import 'package:sup_chat/bindings/home_binding.dart';
import 'package:sup_chat/bindings/login_binding.dart';
import 'package:sup_chat/bindings/setting_binding.dart';
import 'package:sup_chat/constants/app_route.dart';
import 'package:sup_chat/constants/app_theme.dart';
import 'package:sup_chat/firebase_options.dart';
import 'package:sup_chat/middleware/auth_guard.dart';
import 'package:sup_chat/service/knock_service.dart';
import 'package:sup_chat/service/status_service.dart';
import 'package:sup_chat/service/theme_service.dart';
import 'package:sup_chat/service/user_service.dart';
import 'package:sup_chat/ui/friend/add_friend_page.dart';
import 'package:sup_chat/ui/home/home_page.dart';
import 'package:sup_chat/ui/login/login_page.dart';
import 'package:sup_chat/ui/setting/setting_page.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

// Change to false to use live database instance.
const USE_DATABASE_EMULATOR = true;
// The port we've set the Firebase Database emulator to run on via the
// `firebase.json` configuration file.
const emulatorPort = 9000;
// Android device emulators consider localhost of the host machine as 10.0.2.2
// so let's use that if running on Android.
final emulatorHost =
    (!kIsWeb && defaultTargetPlatform == TargetPlatform.android)
        ? '10.0.2.2'
        : 'localhost';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (USE_DATABASE_EMULATOR) {
    try {
      FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
      FirebaseDatabase.instance.useDatabaseEmulator(emulatorHost, 9000);
      await FirebaseAuth.instance.useAuthEmulator(emulatorHost, 9099);
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  await initServices();
  await Get.find<ThemeService>().initStorage();

  runApp(const MyApp());
}

Future<void> initServices() async {
  Get.put(UserService());
  Get.put(StatusService());
  Get.put(ThemeService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    //FlutterNativeSplash.remove();
    print("build theme: ${Get.find<ThemeService>().theme}");
    return GetMaterialApp(
      themeMode: Get.find<ThemeService>().theme,
      theme: AppLightTheme.theme,
      darkTheme: AppDarkTheme.theme,
      initialRoute: AppRoute.HOME,
      initialBinding: HomeBinding(),
      getPages: [
        GetPage(
            name: AppRoute.HOME,
            page: () => const HomePage(),
            binding: HomeBinding(),
            middlewares: [AuthGuard()]),
        GetPage(
            name: AppRoute.LOGIN,
            page: () => const LoginPage(),
            binding: LoginBinding()),
        GetPage(
            name: AppRoute.ADD_FRIEND,
            page: () => const AddFriendPage(),
            binding: AddFriendBinding()),
        GetPage(
            name: AppRoute.SETTING,
            page: () => SettingPage(),
            binding: SettingBinding(),
            transition: Transition.downToUp,
            transitionDuration: const Duration(milliseconds: 200)),
      ],
    );
  }
}
