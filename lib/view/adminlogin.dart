import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart';
import 'package:registraron_screen/view/colors.dart';
import 'package:registraron_screen/view/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'admin_dashboard.dart';
import 'welcomescreen.dart';

class Adminlogin extends StatelessWidget {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('Admin Panel'),
          ),
        ),
        body: Container(
          height: _height,
          decoration: new BoxDecoration(
            color: projectBackGroundColor,
          ),
          child: Stack(
            children: [
              SingleChildScrollView(
                  child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0, left: 20),
                        child: Row(
                          children: [
                            Text(
                              'Welcome KMC!',
                              style: GoogleFonts.bitter(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 0.0, left: 20),
                        child: Row(
                          children: [
                            Text("We're happy to See you again",
                                style: GoogleFonts.bitter())
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: _height*0.02),
                    Container(
                       height: _height * 0.3,
                       width: _width,
                      child: Image.asset(
                        
                        'assets/kmc2.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(height: _height*0.04),
                    Container(
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            //color: Colors.white,
                          ),
                          margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                          
                          width: _width * 0.8,
                          child: Center(
                              child: Form(
                            key: _formKey,
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
                                              prefixIcon: Icon(Icons.email,
                                              color: projectPrimaryColor,),
                                              border: UnderlineInputBorder(),
                                              labelText: 'Email Address',
                                              labelStyle: TextStyle(
                                                color: Colors.black,
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
                                          prefixIcon: Icon(Icons.lock,
                                          color: projectPrimaryColor,),
                                          suffixIcon: Icon(
                                            Icons.remove_red_eye,
                                            size: 20,
                                            color: projectPrimaryColor,
                                          ),
                                          border: UnderlineInputBorder(),
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      style: TextStyle(
                                          fontStyle: FontStyle.normal),
                                      obscureText: true,
                                    ),
                                  ),
                                  
                                  SizedBox(height: _height * 0.09),

                                  Container(
                                    width: _width * 0.5,
                                    child: FlatButton(
                                      color: projectPrimaryColor,
                                      textColor: Colors.white,
                                      padding: const EdgeInsets.all(10),
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(50)),
                                      child: const Text('LOGIN',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 20)),
                                      onPressed: () async {
                                        if (_formKey.currentState.validate()) {
                                          _signInWithEmailAndPassword(context);

                                          

                                        }
                                      },
                                    ),
                                  ),
                                ]),
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
//      backgroundColor: Colors.white,
//      resizeToAvoidBottomPadding: false,
//      appBar: AppBar(
//        title: Center(
//          child: Text('Admin Panel'),
//        ),
//      ),
//      body: new SingleChildScrollView(
//        child: new Column(
//          children: [
//            Center(
//              child: Container(
//                child: Image.asset(
//                  'assets/KMC.jpg',
//                  scale: 1.2,
//                ),
//              ),
//            ),
//            Container(
//
//            child: TextFormField(
//            obscureText: true,
//            decoration: InputDecoration(
//            border: UnderlineInputBorder(),
//            labelText: 'Password',
//            labelStyle: TextStyle(
//            color: Colors.black,
//            fontWeight: FontWeight.w400,
//            )),
//            ),
//
////              child: Padding(
////                padding: const EdgeInsets.all(30.0),
////                child: Stack(
////                  children: [
////                    Container(
////                      child: TextFormField(
////                        decoration: InputDecoration(
////                            border: UnderlineInputBorder(),
////                            labelText: 'User name',
////                            labelStyle: TextStyle(
////                              color: Colors.black,
////                              fontWeight: FontWeight.w400,
////                            )),
////                      ),
////                    ),
////                    SizedBox(height: 40.0),
////
////                  ],
////                ),
////              ),
//            ),
//
//
//    Container(
//    child: TextFormField(
//    obscureText: true,
//    decoration: InputDecoration(
//    border: UnderlineInputBorder(),
//    labelText: 'Password',
//    labelStyle: TextStyle(
//    color: Colors.black,
//    fontWeight: FontWeight.w400,
//    )),
//    ),
//    )
//          ],
//        ),
//      ),
      ),
    );
  }

  void _signInWithEmailAndPassword(BuildContext context) async {
    User user;
    String errorMessage;

    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      // user = result.user;
      if (result.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', _emailController.text.trim());
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Updatescreen()));
//        Navigator.of(context).pop();
//        Navigator.push( context,
//             MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        print("Invalid email or password");
      }
    } catch (error) {
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
        case "account-exists-with-different-credential":
        case "email-already-in-use":
          print("Email already used. Go to login page.");
          break;
        case "ERROR_WRONG_PASSWORD":
        case "wrong-password":
          showDialog(
            builder: (context) => AlertDialog(
              title: Text("Warning"),
              content: Text("Incorrect Password."),
              actions: [
                FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            context: null,
          );

          print("Wrong email/password combination.");
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
          showDialog(
            builder: (context) => AlertDialog(
              title: Text("Warning"),
              content: Text("No user found with this email."),
              actions: [
                FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            context: null,
          );
          //Scaffold.of(context).showSnackBar(SnackBar(content: Text("No user found with this email.")));
          print("No user found with this email");
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          showDialog(
            builder: (context) => AlertDialog(
              title: Text("Warning"),
              content: Text("The Admin has Disabled your Account."),
              actions: [
                FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            context: null,
          );
          print("User disabled.");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
        case "operation-not-allowed":
          print("Too many requests to log into this account.");
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
        case "operation-not-allowed":
          print("Server error, please try again later.");
          break;
        case "ERROR_INVALID_EMAIL":
        case "invalid-email":
          showDialog(
            builder: (context) => AlertDialog(
              title: Text("Warning"),
              content: Text("Email Address badly formatted."),
              actions: [
                FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Colors.black,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  label: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            context: null,
          );
          print("Email address is invalid.");
          break;
        default:
          print("Login failed. Please try again.");
          break;
      }
    }

    if (errorMessage != null) {
      print(errorMessage);
    }
  }
}
