import 'package:chat_app/ui/home/home_page.dart';
import 'package:chat_app/ui/login/login_page.dart';
import 'package:chat_app/ui/signup/sign_up_page.dart';
import 'package:chat_app/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';


class AppRoutes{
  static const String splash = '/splash';
  static const String home = '/home';
  static const String signin = '/login';
  static const String signup = '/register';

  static Map<String, WidgetBuilder> getRoutes() => {
    splash: (context) => SplashPage(),
    signin: (context) => LoginPage(),
    signup: (context) => SignUpPage(),
    home: (context) => HomePage(),
  };

}