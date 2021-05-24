import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/homescreen.dart';
import 'package:registraron_screen/view/signupform.dart';
import 'colors.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  String phoneNo, smssent, verificationId;

  get verifiedsuccess => null;

  Future<void> verifyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      this.verificationId = verId;
      smsCodeDialoge(context).then((value) {
        print("Code Sent");
      });
    };
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {};
    final PhoneVerificationFailed verifyFailed = (FirebaseAuthException e) {
      print('${e.message}');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      timeout: const Duration(seconds: 30),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future<bool> smsCodeDialoge(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter OTP',style: TextStyle(color: primary),),
            content: Padding(
              padding: const EdgeInsets.only(left:18.0,right: 18.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent)
                ),
                child: TextField(
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    this.smssent = value;
                  },
                ),
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              RaisedButton(
                onPressed: () async {
                  User user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupForm()),
                    );
                  } else {
                    Navigator.of(context).pop();
                    signIn(smssent);
                  }
                },
                color: Colors.blueAccent,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Done',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            
            ],
          );
        });
  }

  Future<void> signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SignupForm(),
        ),
      );
    }).catchError((e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("OTP",style: TextStyle(color: Colors.blueAccent),),
            content: Text("Wrong OTP!",style: TextStyle(color: Colors.blueAccent),),
            actions: [
              RaisedButton(
                color: Colors.blueAccent,
                  child: Text("done",style: TextStyle(color: Colors.white),),
                  onPressed: (){
                  Navigator.pop(context);
              })
            ],
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(

      resizeToAvoidBottomPadding: true,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Center(
          child: Text('Phone Number Verification'),
        ),
      ),
      body: Container(
        decoration: new BoxDecoration(color: projectBackGroundColor,

            ),
        child: SingleChildScrollView(
                  child: Column(

            children: <Widget>[
             


              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: _height * 0.25,
                  child: Image.asset(
                    'assets/otp.png',
                    //scale: 1,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
Container(
  child: Padding(
    padding: const EdgeInsets.only(left:50.0,right: 10),
    child: Text('We will send you a 6-Digit code on Your $phoneNo Number',
      style: GoogleFonts.bitter(
          fontWeight: FontWeight.bold
      )

    ),
  ),
),
SizedBox(height: 80,),


              Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 20),
                  child: IntlPhoneField(
                    decoration: InputDecoration(
                      focusColor: Colors.black,
                      hoverColor: Colors.black,
                      fillColor: Colors.black,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50)),
                      labelText: 'Enter your mobile number',
                    ),
                    initialCountryCode: 'PK',
                    onChanged: (phone) {
                      phoneNo = phone.completeNumber;
                      // print(phone.completeNumber);
                    },
                  )),
              SizedBox(
                height: 10.0,
              ),
              RaisedButton(
                color: primary,
                child: Text(
                  'Verify',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  if (phoneNo == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Ops"),
                            content:
                                Text('Please Enter your 11-Digit Phone Number'),
                            actions: [
                              FlatButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Colors.black,
                                icon: Icon(
                                  Icons.mood_bad,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  "Retry",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          );
                        });
                  } else {
                    verifyPhone();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
