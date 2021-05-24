import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/loginscreen.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
   FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  
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
                padding: const EdgeInsets.only(left:15.0,top:50),
                child: Row(
                  children: [Text('Forget Passowrd!',
                  style: GoogleFonts.bitter(
                    fontSize: 30,
                    fontWeight: FontWeight.bold
                ),)]
                  ,
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left:15.0,),
                child: Row(
                  children: [Text("Don't Worry! You're Just one Step Away",
                      style: GoogleFonts.bitter(

                      ))],
                ),
              ),
            ),
            SizedBox(height:20),
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
                        height: _height * 0.4,
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
                                            prefixIcon: Icon(Icons.email,
                                            color: primary,),
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

                                // Container(
                                //   margin: EdgeInsets.all(10),
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.zero,
                                //       boxShadow: [
                                       
                                //       ]),
                                //   child: TextFormField(
                                //     obscureText: _isHidden,
                                //     controller: _passwordController,
                                //     validator: (String value) {
                                //       if (value.isEmpty) {
                                //         return 'Please enter some text';
                                //       }
                                //       return null;
                                //     },
                                //     decoration: InputDecoration(
                                //         prefixIcon: Icon(Icons.lock,
                                //         color: primary),
                                //         suffixIcon: InkWell(
                                //           onTap: _togglePasswordView,
                                //           child: Icon(
                                //             _isHidden
                                //             ? Icons.visibility_off
                                //             : Icons.visibility,
                                            
                                //           ),
                                //         ),
                                //         border: UnderlineInputBorder(),
                                //         labelText: 'Password',
                                //         labelStyle: TextStyle(
                                //           fontWeight: FontWeight.w400,
                                //         )),
                                //     style:
                                //         TextStyle(fontStyle: FontStyle.normal),
                                    
                                //   ),
                                // ),
                                SizedBox(height: 30),

                                Container(
                                  width: _width * 0.5,
                                  child: FlatButton(
                                    color: primary,
                                    textColor: Colors.white,
                                    padding: const EdgeInsets.all(10),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(50)),
                                    child: const Text('Send Email',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20)),
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        resetPassword();
                                      }
                                    },
                                  ),
                                ),
                                SizedBox(height: 30,),
                                GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));
                                    },
                                    child: Text("Back to Sign In")),

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
    Future<void> resetPassword() async {
      try {
    await _auth.sendPasswordResetEmail(email: _emailController.text.trim(),);
       showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text("Email sent"),
              content: Text("Please Check your Email."),
              actions: [
                FlatButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Loginscreen()));

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

      }
      
      catch(error)
      {

      }
}
  
}