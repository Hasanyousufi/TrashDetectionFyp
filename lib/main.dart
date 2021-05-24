import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/admin_dashboard.dart';
import 'package:registraron_screen/view/admin_newDashboard.dart';
import 'package:registraron_screen/view/adminlogin.dart';
import 'package:registraron_screen/view/colors.dart';
import 'package:registraron_screen/view/homescreen.dart';
import 'package:registraron_screen/view/loginscreen.dart';
import 'package:registraron_screen/view/map.dart';
import 'package:registraron_screen/view/signup.dart';
import 'package:registraron_screen/view/signupform.dart';
import 'package:registraron_screen/view/splashscreen.dart';
import 'package:registraron_screen/view/uploadpicture.dart';
import 'package:registraron_screen/view/welcomescreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context,notifier,child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Trash Detector',
            theme: notifier.darkTheme ? light : dark,
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final GlobalKey<FormState> _formkey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
