import 'package:provider/provider.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/rejected.dart';
import 'package:registraron_screen/view/resolved_complains.dart';

import 'colors.dart';
import 'package:flutter/material.dart';
import 'package:registraron_screen/view/welcomescreen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'admin_dashboard.dart';

import 'package:path/path.dart';
bool isSun = true;
Drawer buildCustomDrawer(double _height, double _width, BuildContext context,Function setState,String name) {
  double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
  return Drawer(
    child: Column(
      children: [
        Container(
          height: _height / 4.5,
          decoration: BoxDecoration(color: primary),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              SizedBox(
                height: _height / 20,
              ),
              Container(
                height: _height*0.1,
                margin: EdgeInsets.only(left: 8),
                child: Row(
                  
                  children: [
                    Tab(
                      icon: Container(
                        height: _height*0.5,
                        child: Padding(
                          padding: const EdgeInsets.only(left:12.0),
                          child: Image(
                            
                            image: AssetImage(
                              'assets/kmc_user.png',
                            ),
                           
                           
                            //height: _height
                          ),
                        ),
                        
                      ),
                    ),
                    SizedBox(
                      width: _width*0.05,
                     
                    ),
                    Flexible(
                      child: Text(
                         name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20),
                      ),
                    ),
                    Consumer<ThemeNotifier>(
                          builder: (context,notifier,child) => notifier.darkTheme ? IconButton(icon:Icon(Icons.wb_sunny,color: Colors.yellow,),onPressed: (){
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
              SizedBox(
               height: 10,
              ),
              
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(top: 30, left: 50, right: 30),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ResolvedScreen()));
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 30,
                          //color: ProjectTheme.projectPrimaryColor,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            'Resolved Complains',
                            style: TextStyle(
                              fontSize: 16,
                              //color: ProjectTheme.projectPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: _width / 2.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.3),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => RejectedScreen()));
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 30,
                          //color: ProjectTheme.projectPrimaryColor,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            'Rejected Complains',
                            style: TextStyle(
                              fontSize: 16,
                              //color: ProjectTheme.projectPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: _width / 2.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.3),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => Updatescreen()));
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(
                          Icons.list,
                          size: 30,
                          //color: ProjectTheme.projectPrimaryColor,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(
                            'Unresolved Complains',
                            style: TextStyle(
                              fontSize: 16,
                              //color: ProjectTheme.projectPrimaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),


                Container(
                  width: _width / 2.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.3),
                  ),
                ),
                Container(
                  height: 50,
                  child: Row(
                    children: [
                      IconButton(
                         icon: Icon(Icons.logout),
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
                        
                        
                        //color: ProjectTheme.projectPrimaryColor,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 15),
                        child: Text(
                          'log out',
                          style: TextStyle(
                            fontSize: 16,
                            // color: ProjectTheme.projectPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: _width / 2.5,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 0.3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
