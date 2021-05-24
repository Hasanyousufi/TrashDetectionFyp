import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:registraron_screen/view/admin_dashboard.dart';
import 'package:registraron_screen/view/admin_newDashboard.dart';
import 'package:registraron_screen/view/colors.dart';
import 'package:registraron_screen/view/homescreen.dart';
import 'package:registraron_screen/view/loginscreen.dart';
import 'package:registraron_screen/view/signup.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:registraron_screen/view/welcomescreen.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';




class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
 
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        Duration(seconds: 3),
            () => checkUser(),
    );
  }
  Future<void> checkUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    var sessionEmail = prefs.getString('email');
    var role = prefs.getString('role');
    if(sessionEmail == null){
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    }
    else{
      if(role == "Admin"){
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => Newadmindashboard()));
      }else{
        Navigator.of(context).pop();
        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }

    }
    //sessionEmail == null ?  Navigator.push(context, MaterialPageRoute(builder: (context) => Login())): Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }
  
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    
    return Scaffold(

        resizeToAvoidBottomPadding: false,
        body: Container(
          height: _height,
          width: _width,
         
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(100.0, 130, 0.0, 0.0),
                        child: Text(
                          'Finding',
                          style: GoogleFonts.bitter(
                              fontSize: 40.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(100.0, 175, 0.0, 0.0),
                        child: Text(
                          'Trash',
                          style: GoogleFonts.bitter(
                              fontSize: 38.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20.0,
                  ),
                  child: Column(children: [
                    Container(
                      padding:
                          EdgeInsets.only(top: 40.0, right: 20.0, left: 20.0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Image.asset(
                              'assets/trash.png',
                              scale: 0.3,
                            ),
                          ),
                          SizedBox(height: 90.0),
                                 SpinKitRipple(color: Colors.black,),

                       
                        ],
                      ),
                    ),
                    // SizedBox(height: 15.0),
                  ]),
                )
              ]),
        ));
  }
}
