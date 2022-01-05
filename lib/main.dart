import 'package:flutter/material.dart';
import 'package:payments/Auth_Screens/LoginScreen.dart';
import 'package:payments/Auth_Screens/Register_Screen.dart';
import 'package:payments/Views/Splash_View.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = SupabaseClient('https://funxrdssorkmysyiqfsg.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzOTQwMjE0NCwiZXhwIjoxOTU0OTc4MTQ0fQ.qlajvqRzaxn4AEH5ja6pH-3l8MJbzlPctHfgvxr_uRo');

Future<void> main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzOTQwMjE0NCwiZXhwIjoxOTU0OTc4MTQ0fQ.qlajvqRzaxn4AEH5ja6pH-3l8MJbzlPctHfgvxr_uRo",anonKey: "https://funxrdssorkmysyiqfsg.supabase.co");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: SplashScreen(),
    );
  }
}

