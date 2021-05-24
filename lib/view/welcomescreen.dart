import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/adminlogin.dart';
import 'package:registraron_screen/view/colors.dart';
import 'package:registraron_screen/view/loginscreen.dart';
import 'package:registraron_screen/view/signup.dart';
import 'package:registraron_screen/view/signupform.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: backgroundColor,

        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: new BoxDecoration(
          ),
          child: SingleChildScrollView(
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
                            EdgeInsets.only(top: 30.0, right: 20.0, left: 20.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              child: Image.asset(
                                'assets/trash.png',
                                scale: 0.3,
                              ),
                            ),
                            SizedBox(height: 90.0),
                            Container(
                              height: 50,
                              child: Material(
                                borderRadius: BorderRadius.circular(30),
                                shadowColor: Color.fromARGB(255, 24, 24, 24),
                                color: primary,
                                elevation: 7.0,
                                child: GestureDetector(
                                  onTap: () {
                                    //Navigator.of(context).pop();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Loginscreen(),
                                        ));
                                  },
                                  child: Center(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              height: 50,
                              child: Material(
                                  borderRadius: BorderRadius.circular(30),
                                  shadowColor: Color.fromARGB(255, 24, 24, 24),
                                  color: Colors.white,
                                  elevation: 7.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      //Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Signup(),
                                          ));
                                    },
                                    child: Center(
                                      child: Text(
                                        'Sign up',
                                        style: TextStyle(
                                          color: primary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )),
                            ),
                            SizedBox(height:25),
                           
                          ],
                        ),
                      ),
                     
                    ]),
                  )
                ]),
          ),
        ));
  }
}
