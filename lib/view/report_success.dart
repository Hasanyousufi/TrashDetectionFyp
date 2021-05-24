import 'dart:io';

import 'package:flutter/material.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/homescreen.dart';
import 'package:registraron_screen/view/welcomescreen.dart';

class ReportSuccess extends StatefulWidget {
  final File image;
  final String email;
  final String address;

  const ReportSuccess({Key key, this.image, this.email, this.address}) : super(key: key);
  @override
  _ReportSuccessState createState() => _ReportSuccessState();
}

class _ReportSuccessState extends State<ReportSuccess> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Report Success"),
      ),
      body: ListView(
        children: [
          Container(
            child: SizedBox(height: 20,),
          ),
          Padding(
            padding: const EdgeInsets.only(left:12.0,right: 12.0),
            child: Container(
                height: _height*0.2,

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
                          height: _height * 0.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.email,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20),
                                ),
                              ),
                              Flexible(
                                child: Container(
                                  width: _width * 0.5,
                                  child: Text(
                                    widget.address,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                ),

                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                )

              // child: Row(
              //   children: [
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.only(left:8.0),
              //         child: Text(
              //           email == null ? "" : email,
              //           style: TextStyle(),
              //         ),

              //       ),
              //     ),

              //   ],


              // ),

              // child: Text(email == null ?"":email,style: TextStyle(),),
            ),
          ),
          SizedBox(height: 20,),
          Image.file(widget.image,height: 200,),
          SizedBox(height: 20,),
          Center(child: Text("Report send successfully")),
          SizedBox(height: 20,),
          Padding(
            padding: const EdgeInsets.only(left:20,right: 20),
            child: FlatButton(
                color: primary,
                onPressed: (){
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
            }, child: Text("Done",style: TextStyle(color: Colors.white),)),
          )
        ],
      ),
    );
  }
}
