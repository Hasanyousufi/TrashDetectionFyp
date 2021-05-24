import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/main.dart';
import 'package:registraron_screen/view/loginscreen.dart';
import 'package:registraron_screen/view/uploadpicture.dart';
import 'package:registraron_screen/view/welcomescreen.dart';

import 'colors.dart';

class SignupForm extends StatefulWidget {
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _displayName = TextEditingController();
  
  bool _isSuccess;
  bool _isHidden = true;
 

  void _togglePasswordView() {
    if (_isHidden == true) {
      _isHidden = false;
    } else {
      _isHidden = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      body: Container(
        height: _height,
        decoration: new BoxDecoration(
          // color: projectBackGroundColor,
        ),
        child: Stack(
          children: [
            SingleChildScrollView(
                child: ConstrainedBox(
              constraints: BoxConstraints(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                    child: Container(
                      child: Row(
                        children: [
                          Text("Create Account",
                              style: GoogleFonts.bitter(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      width: _width * 1,
                      child: Text(
                          'Please complete the form below for Registration',
                          style: GoogleFonts.bitter(
                              //fontWeight: FontWeight.bold,
                              fontSize: 14)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Image.asset(
                        'assets/form.png',
                        // scale: 1,
                      ),
                    ),
                  ),
                  Container(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          //color: Colors.white,
                        ),
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        height: _height * 0.7,
                        width: _width * 0.8,
                        child: Center(
                            child: Form(
                          key: _formKey,
                          child: SingleChildScrollView(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.zero,
                                            boxShadow: [
                                              // BoxShadow(color: Colors.white),
                                            ]),
                                        child: TextFormField(
                                          controller: _emailController,
                                          //key: _formKey,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                          decoration: InputDecoration(
                                              focusColor: Colors.black,
                                              prefixIcon: Icon(Icons.email),
                                              labelText: 'Email Address',
                                              labelStyle: TextStyle(
                                                fontWeight: FontWeight.w400,
                                              )),
                                          style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.zero,
                                        boxShadow: [
                                          //BoxShadow(color: Colors.white),
                                        ]),
                                    child: TextFormField(
                                      controller: _displayName,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon:
                                              Icon(Icons.supervised_user_circle),
                                          border: UnderlineInputBorder(),
                                          labelText: 'Full Name',
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          )),
                                      style:
                                          TextStyle(fontStyle: FontStyle.normal),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.zero,
                                        boxShadow: [
                                          // BoxShadow(color: Colors.white),
                                        ]),
                                    child: TextFormField(
                                      controller: _passwordController,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock),
                                          suffixIcon: InkWell(
                                            onTap: _togglePasswordView,
                                            child: Icon(
                                              _isHidden
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                          ),
                                          border: UnderlineInputBorder(),
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          )),
                                      style:
                                          TextStyle(fontStyle: FontStyle.normal),
                                      obscureText: _isHidden,
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.zero,
                                        boxShadow: [
                                          // BoxShadow(color: Colors.white),
                                        ]),
                                    child: TextFormField(
                                      controller: _confirmPasswordController,
                                      validator: (val) {
                                        if (val.isEmpty) return 'Empty';
                                        if (val != _passwordController.text)
                                          return 'Not Match';
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon:
                                              Icon(Icons.security_rounded),
                                          suffixIcon: InkWell(
                                            onTap: _togglePasswordView,
                                            child: Icon(
                                              _isHidden
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                            ),
                                          ),
                                          border: UnderlineInputBorder(),
                                          labelText: 'Confirm Password',
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                          )),
                                      style:
                                          TextStyle(fontStyle: FontStyle.normal),
                                      obscureText: _isHidden,
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    width: 250,
                                    child: RaisedButton(
                                      color: primary,
                                      textColor: Colors.white,
                                      padding: const EdgeInsets.all(10),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(50)),
                                      child: const Text('Sign Up',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20)),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          _registerAccount();

//                                          Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                  builder: (ctx) =>
//                                                      WelcomeScreen()));
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  GestureDetector(
                                      onTap: (){
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));
                                      },
                                      child: Text("Back to Login")),

                                ]),
                          ),
                        )),
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    ));
  }

  void _registerAccount() async {
    try {
      final User user = (await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ))
          .user;

      if (user != null) {
        FirebaseFirestore.instance.collection("Users").doc().set({
          "name": _displayName.text.trim(),
          "email": _emailController.text.trim(),
          "role": "User"
        }).whenComplete(() async {
          print("completed");
          if (!user.emailVerified) {
            await user.sendEmailVerification();
          }
          await user.updateProfile(displayName: _displayName.text);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
        });

        // final user1 = _auth.currentUser;

      } else {
        _isSuccess = false;
      }
    } catch (e) {
      print('Error: $e ');
      showDialog(context: context,
        builder: (context) => AlertDialog(
          title: Text("Alert"),
          content: Text(e.toString()),
        )
      );
    }
  }
}
