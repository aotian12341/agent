import 'dart:io';

import 'package:agent/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import 'controller/user_controller.dart';
import 'pages/login.dart';
import 'routes/Routes.dart';

class GlobalHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = GlobalHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // 强制竖屏
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  UserController();
  runApp(const App());
}

class App extends StatelessWidget with WidgetsBindingObserver {
  const App({Key? key}) : super(key: key);

  static RouteObserver<ModalRoute> routerObserver = RouteObserver<ModalRoute>();

  static List<String> routeList = ["HomePage"];

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: GetMaterialApp(
        title: "新盛",
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          routerObserver,
        ],
        getPages: appRoutes,
        theme: ThemeData(primaryColor: const Color(0xff5AA6FD)),
        home: const Home(),
      ),
    );
  }
}
