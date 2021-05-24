import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart' as add;
import 'package:mailer/smtp_server/gmail.dart';
import 'package:registraron_screen/view/homescreen.dart';
import 'package:registraron_screen/view/map.dart';
import 'package:registraron_screen/view/welcomescreen.dart';

import 'package:registraron_screen/constants/theme.dart';

class ReportApproval extends StatefulWidget {
  final String id;
  final double lat;
  final double long;
  final String image;
  final String email;
  final String address;
  

  const ReportApproval(
      {Key key,
      this.image,
      this.email,
      this.address,
      this.id,
      this.lat,
      this.long})
      : super(key: key);
  @override
  _ReportApprovalState createState() => _ReportApprovalState();
}

class _ReportApprovalState extends State<ReportApproval> {

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Complain Approval"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20,left:12.0,right: 12.0),
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
          SizedBox(
            height: 20,
          ),
          Image.network(
            widget.image,
            height: 200,
          ),
          SizedBox(
            height: 20,
          ),

          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FlatButton(
                  color: Colors.green,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapsScreen(
                            email: widget.email,
                            id: widget.id,
                            lat: widget.lat,
                            long: widget.long,
                            address: widget.address,
                            image: widget.image,
                            isMap: false,
                            isdetail: true,
                          ),
                        ));
                  },
                  child: Text(
                    "Approve",
                    style: TextStyle(color: Colors.white),
                  )),
              FlatButton(
                  color: Colors.red,
                  onPressed: () {
                    resolve(context);
                    sendMessage();
                  },
                  child: Text(
                    "Reject",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          )
        ],
      ),
    );
  }

  resolve(BuildContext context) {
    FirebaseFirestore.instance
        .collection("Trash")
        .doc(widget.id)
        .delete()
        .whenComplete(() {
      print("deleted");
    });
    FirebaseFirestore.instance.collection("Rejected").doc().set({
      "latitude": widget.lat,
      "longitude": widget.long,
      "address": widget.address,
      "email": widget.email,
      "image": widget.image
    }).whenComplete(() {
      sendMessage();
      print("Rejected");
      showDialog(
          builder: (context) => AlertDialog(
                title: Text("Rejected"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        });
                      },
                      child: Text('Ok'))
                ],
              ),
          context: context);
    });
  }

//send Email when Resolve
  sendMessage() async {
    String username = 'kmckarachiauth@gmail.com';
    String password = 'hasanyousufi123';

    final smtpServer = gmail(username, password);
    final message = add.Message()
      ..from = add.Address(username, 'Trash Detector')
      ..recipients.add(widget.email)
      ..subject = 'Your Complain is rejected'
      ..text =
          ('Thankyou for filing a complaint, We value your time and contribution in order to keep the city Clean. \n Complain Id: ' +
              widget.id +
              '\n' +
              'Your address: \n' +
              widget.address +
              '\n' +
              'your cordinates: \n' +
              'Latitude: ' +
              widget.lat.toString() +
              '\n' +
              'Longitude:  ' +
              widget.long.toString()) + 
              '\n' + 
              'Image :' + widget.image;
              

    try {
      final sendReport = await add.send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text("Alert"),
      //       content: Text("Email send successfully"),
      //     )
      // );
    } on add.MailerException catch (e) {
      print(e.toString());
    }
    var connection = add.PersistentConnection(smtpServer);
    await connection.send(message);
    await connection.close();
  }
}
