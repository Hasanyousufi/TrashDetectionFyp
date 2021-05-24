import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/admin_dashboard.dart';
import 'package:registraron_screen/view/admin_newDashboard.dart';
import 'package:registraron_screen/view/forgetPassord.dart';
import 'package:registraron_screen/view/homescreen.dart';
import 'package:registraron_screen/view/signupform.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'colors.dart';
import 'signup.dart';

class Loginscreen extends StatefulWidget {
  @override
  _LoginscreenState createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isHidden = true;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 50),
                      child: Row(
                        children: [
                          Text(
                            'Welcome Back!',
                            style: GoogleFonts.bitter(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15.0,
                      ),
                      child: Row(
                        children: [
                          Text("We're happy to See you again",
                              style: GoogleFonts.bitter())
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    //height: _height * 0.3,
                    width: _width * 0.6,
                    child: Image.asset(
                      'assets/login.png',
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
                        height: _height * 0.5,
                        width: _width * 0.8,
                        child: Center(
                            child: Form(
                          key: _formKey,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  children: [
                                    Container(),
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
                                            prefixIcon: Icon(
                                              Icons.email,
                                              color: primary,
                                            ),
                                            border: UnderlineInputBorder(),
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
                                      boxShadow: []),
                                  child: TextFormField(
                                    obscureText: _isHidden,
                                    controller: _passwordController,
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        prefixIcon:
                                            Icon(Icons.lock, color: primary),
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
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ForgetPassword()),
                                    );
                                  },
                                  child: Container(
                                    child: Text(
                                      'Forget password ?',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30),
                                loading ? Center(child: CircularProgressIndicator(backgroundColor: primary,)) : Container(
                                  width: _width * 0.5,
                                  child: FlatButton(
                                    color: primary,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(10),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(50)),
                                    child: Text('LOGIN',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20)),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        _signInWithEmailAndPassword();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Signup()));
                                    },
                                    child: Text("Back to Sign up")),
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
    ));
  }

  // Sign in funtion

  void _signInWithEmailAndPassword() async {
    setState(() {
      loading = true;
    });
    User user;
    String errorMessage;

    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
      // user = result.user;
      if (result.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        //DocumentReference documentReference = FirebaseFirestore.instance.collection("Users").where("email",isEqualTo: _emailController.text) as DocumentReference;
        FirebaseFirestore.instance
            .collection("Users")
            .where("email", isEqualTo: _emailController.text)
            .get()
            .then((datasnapshot) async {
          print(datasnapshot);
          print(datasnapshot.docs[0].data()["role"]);
          String role = datasnapshot.docs[0].data()["role"];
          String name;
          //print(name);
          if (role == "User") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', _emailController.text);
            prefs.setString('role', 'User');
            setState(() {
              loading = false;
            });
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (role == "Admin") {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.setString('email', _emailController.text);
            prefs.setString('role', 'Admin');
            setState(() {
              loading = false;
            });
            Navigator.pop(context);
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Newadmindashboard()));
          } else {
             setState(() {
               loading = false;
             });
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text("Warning"),
                      content: Text("Something went wrong"),
                    ));
          }
        });
        // prefs.setString('email', _emailController.text.trim());
        // Navigator.of(context).pop();
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
          setState(() {
            loading = false;
          });
          showDialog(
            context: context,
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
          );

          print("Wrong email/password combination.");
          break;
        case "ERROR_USER_NOT_FOUND":
        case "user-not-found":
        setState(() {
          loading = false;
        });
          showDialog(
            context: context,
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
          );

          print("No user found with this email");
          break;
        case "ERROR_USER_DISABLED":
        case "user-disabled":
          showDialog(
            context: context,
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
        setState(() {
          loading = false;
        });
          showDialog(
            context: context,
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
