import 'package:camera/new/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/colors.dart';
import 'package:registraron_screen/view/loginscreen.dart';
import 'package:registraron_screen/view/my_complains.dart';
import 'package:registraron_screen/view/uploadpicture.dart';
import 'package:registraron_screen/view/welcomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  
  var email;
  String name;
  bool isSun = true;
  Future<void> getUser() async{
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email');
      print(email);
    });
  }
  getUsers1(){
    FirebaseFirestore.instance.collection("Users").where("email",isEqualTo: FirebaseAuth.instance.currentUser.email).get().then((value){
      value.docs.forEach((element) {
        setState(() {
          name = element.data()["name"];
        });
        print(element.data()["name"]);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    getUsers1();
 }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          decoration: new BoxDecoration(

          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MyComplains(),
                                    ));
                              },
                              icon: Icon(
                                Icons.message_outlined,
                                color: primary,
                              )),
                          Consumer<ThemeNotifier>(
                              builder: (context,notifier,child) => notifier.darkTheme ? IconButton(icon:Icon(Icons.wb_sunny,color: Colors.yellow.shade700,),onPressed: (){
                                notifier.toggleTheme();
                                setState(() {
                                  isSun = !isSun;
                                });
                              }): IconButton(icon:Icon(Icons.nightlight_round,color: Colors.white,),onPressed: (){
                                notifier.toggleTheme();
                                setState(() {
                                  isSun = !isSun;
                                });
                              })
                          )
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left:12.0,right: 12.0),
                      child: Container(
                        height: _height*0.15,

                        decoration: BoxDecoration(
                          color: secondary,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                              bottomRight: Radius.circular(5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 8,
                              offset:
                              Offset(0, 0), // changes position of shadow
                            ),
                          ],
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: _width*0.05,
                                ),
                                CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage:
                                  AssetImage("assets/kmc_user.png"),
                                  backgroundColor: Colors.transparent,
                                ),
                                SizedBox(
                                  width: _width*0.05,
                                ),
                                Container(
                                  height: 100,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          'Welcome',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20),
                                        ),
                                      ),
                                      Flexible(
                                        child: Text(
                                          name == null ?"":name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20),
                                        ),

                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ],
                        )


                      ),
                    ),
                  SizedBox(height:_height * 0.1),
                  Container(
                     height: _height*0.3,
                    
                    child: Padding(
                      padding: const EdgeInsets.only(
                      
                        left: 30.0,
                        right: 20.0,
                        bottom: 0.0,
                      ),
                      child: Image.asset(
                        'assets/3.png',
                      ),
                    ),
                  ), //is container ke baad
                ]),
                Padding(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: _width / 1.85,
                            child: RaisedButton(
                              color: primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 20,
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UploadingImageToFirebaseStorage(email: email),
                                  ));
                              },
                              textColor: Colors.white,
                              
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.camera_alt_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width:5.0),
                                    Text(
                                      "Camera",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                            width: _width / 1.85,
                            child: RaisedButton(
                              color: primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  ),
                                  elevation: 10,

                              onPressed: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.remove('email');
                                prefs.remove('role');
                                FirebaseAuth.instance.signOut();
                                Navigator.of(context).pop();
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WelcomeScreen(),
                                  ));
                              },
                              textColor: Colors.white,
                              
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width:5.0),
                                    Text(
                                      "LOGOUT",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                      SizedBox(height: 10.0),


                    ],
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
