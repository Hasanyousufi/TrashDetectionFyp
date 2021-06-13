import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants/theme.dart';
import 'map.dart';
import 'report_approval.dart';

class MyComplains extends StatefulWidget {
  const MyComplains({Key key}) : super(key: key);

  @override
  _MyComplainsState createState() => _MyComplainsState();
}

class _MyComplainsState extends State<MyComplains> {
  delete(String id) {
    FirebaseFirestore.instance.collection('Trash').doc(id).delete().then((value){
      print("deleted");
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Complains"),
      ),
      body:StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Trash').where("email",isEqualTo: FirebaseAuth.instance.currentUser.email).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: Text("Complains are loading..."));
          if(snapshot.data.docs.length <= 0)
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                    child: Image.asset('assets/nocomplains.png',height: 150,width: 150,)
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("No Complains",style: TextStyle(color: primary,fontSize: 20,fontWeight: FontWeight.bold),)
                  ],
                )
              ],
            );

          return new ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) => Dismissible(
                key: UniqueKey(),
                onDismissed: (direction) {
                  // Remove the item from the data source.
                  setState(() {
                    delete(snapshot.data.docs[index].id);
                  });
                  // Then show a snackbar.
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text("Complain dismissed")));
                },
                // Show a red background as the item is swiped away.
                background: Padding(
                  padding: const EdgeInsets.only(top:5.0,bottom: 5.0),
                  child: Container(
                    color: Colors.red,
                    child: Icon(Icons.delete,color: Colors.white,),
                  ),
                ),
                child: ListTile(
                    leading: Icon(
                      Icons.location_on,
                      size: 30,
                      color:primary,

                    ),
                    title: Text("Complain No: " +snapshot.data.docs[index].id,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        )),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: primary,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MapsScreen(
                                      image:snapshot.data.docs[index]["url"],
                                      k: true,
                                      email: snapshot.data.docs[index]["email"],
                                      id: snapshot.data.docs[index].id,
                                      lat: snapshot.data.docs[index]["latitude"],
                                      long: snapshot.data.docs[index]["longitude"],
                                      address: snapshot.data.docs[index]["address"],
                                      isMap: true,
                                      isdetail: false,
                                    ),
                              ));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => ReportApproval(
                          //   id: snapshot.data.docs[index].id,
                          //   lat: snapshot.data.docs[index]["latitude"],
                          //   long: snapshot.data.docs[index]["longitude"],
                          //   image: snapshot.data.docs[index]["url"],
                          //   email: snapshot.data.docs[index]["email"],
                          //   address: snapshot.data.docs[index]["address"],
                          // )));
                        }),
                    subtitle:Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text( 'Email:  ' +
                                snapshot.data.docs[index]["email"],
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          snapshot.data.docs[index]["address"],
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        Divider(height:30),

                      ],
                    )
                ),
              )
          );
        },
      ),
    );
  }
}
