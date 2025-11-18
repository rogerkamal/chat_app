import 'dart:async';

import 'package:chat_app/domain/utils/app_constants.dart';
import 'package:chat_app/domain/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      String nextPageName = AppRoutes.signin;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString(AppConstants.prefUserIdKey) ?? "";

      if(userId.isNotEmpty){
        nextPageName = AppRoutes.home;
      }

      Navigator.pushReplacementNamed(context, nextPageName);    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,

            child:ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Colors.purple,
                Colors.white,
                Colors.green
              ],
            ).createShader(bounds),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/app_image/logo.png",height: 30,fit: BoxFit.cover,color: Colors.deepOrange),
                Text(
                  'Chat App',
                  style: TextStyle(color: Colors.white, fontSize: 40,fontWeight: FontWeight.bold),
                ),
              ]

            ),
          ),

            decoration: BoxDecoration(
              color: Colors.black
                /*gradient: LinearGradient(
                    stops: [0.0, 0.3, 0.7],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xffff9a01),
                      Color(0xfffad100),
                      Color(0xff009dff)
                    ])*/
            ),
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black
                  ),
                  child: Center(
                    child: Text(
                      "Splash Page",
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
