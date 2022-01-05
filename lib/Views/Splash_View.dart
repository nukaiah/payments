import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:payments/Auth_Screens/BackGround.dart';
import 'package:payments/Auth_Screens/LoginScreen.dart';
import 'package:payments/Views/Bottomnavigator.dart';
import 'package:payments/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((value){checkLogin();});
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BackGround(
        title: "",
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            width: size.width,
            height: size.height,
            child: Lottie.asset("assets/splash.json",repeat: true,reverse: true,fit: BoxFit.fill),
          ),
        ),
      ),

    );
  }

  checkLogin()async{
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    if(_prefs.getString("phone") == null){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>LoginScreen()));
    }
    else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>BottomnavigatorScreen()));
    }
  }
}
