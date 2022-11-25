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
    FirebaseDatabase.instance.useDatabaseEmulator(emulatorHost, emulatorPort);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final isLoggedIn = FirebaseAuth.instance.currentUser != null;
    //FlutterNativeSplash.remove();
    return GetMaterialApp(
      theme: AppLightTheme.theme,
      darkTheme: AppDarkTheme.theme,
      initialRoute: isLoggedIn ? AppRoute.HOME : AppRoute.LOGIN,
      initialBinding: isLoggedIn ? HomeBinding() : LoginBinding(),
      getPages: [
        GetPage(
            name: AppRoute.HOME,
            page: () => const HomePage(),
            binding: HomeBinding()),
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
