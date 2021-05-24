import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:animations/animations.dart';
import 'package:mailer/mailer.dart' as add;
import 'package:mailer/smtp_server/gmail.dart';
import 'package:registraron_screen/constants/theme.dart';

class MapsScreen extends StatefulWidget {
  bool isMap;
  bool isdetail;
  final bool k;
  final String email;
  final String id;
  final double lat;
  final double long;
  final String address;
  final String image;

  MapsScreen(
      {Key key, this.lat, this.long, this.address, this.id, this.email, this.k, this.image, this.isMap,this.isdetail})
      : super(key: key);
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  LatLng latLng;
  double pLat, pLong;
  // Map<MarkerId,Marker> markers = <MarkerId,Marker>{};
  //String API_KEY = apikey;

  String address;
  bool loading = true;
  CameraPosition _position;
  List<Marker> markers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    markers.add(Marker(
        draggable: true,
        markerId: MarkerId("Marker1"),
        onTap: () {
          print("Marker1");
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Address "),
                  content: Text(widget.address),
                );
              });
        },
        position: LatLng(widget.lat, widget.long)));
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Review Complain"),
        ),
        body: widget.isMap ?
        ListView(
          children: [
            SizedBox(height: 20,),
            //Center(child: Text(widget.email)),
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
            SizedBox(height: 25,),
            Image.network(widget.image,height: 200,),
            SizedBox(height: 25,),
            Padding(
              padding: const EdgeInsets.only(left:20,right: 20),
              child: FlatButton(
                  color: primary,
                  onPressed: (){
                    Navigator.pop(context);
                  }, child: Text("Done",style: TextStyle(color: Colors.white),)),
            ),
            Padding(
              padding: const EdgeInsets.only(left:20,right: 20),
              child: FlatButton(
                  color: primary,
                  onPressed: (){
                    setState(() {
                      widget.isMap = false;
                    });
                  }, child: Text("Map",style: TextStyle(color: Colors.white),)),
            )
          ],
        )
            : Stack(
          children: [
            // color: Colors.white,
            // height: double.infinity,
            GoogleMap(
              //onMapCreated: _onMapCreated,
              markers: Set.from(markers),
              initialCameraPosition: latLng == null
                  ? CameraPosition(
                      target: LatLng(widget.lat, widget.long), zoom: 20)
                  : CameraPosition(
                      target: LatLng(widget.lat, widget.long), zoom: 15),
              mapType: MapType.satellite,
              myLocationEnabled: true,
            ),
            widget.k == true
                ? Text("")
                : Positioned(
                    left: 30,
                    bottom: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RaisedButton(
                        color: Colors.red,
                        onPressed: () {
                          resolve(context);
                        },
                        child: Text(
                          "Resolve Complain",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),

             widget.isdetail? SizedBox() : Positioned(
              right: 100,
              bottom: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      widget.isMap = true;
                    });
                  },
                  child: Text(
                    "Details",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

//complain resolve function

  resolve(BuildContext context) {
    FirebaseFirestore.instance
        .collection("Trash")
        .doc(widget.id)
        .delete()
        .whenComplete(() {
      print("deleted");
    });
    FirebaseFirestore.instance.collection("Resolved").doc().set({
      "latitude": widget.lat,
      "longitude": widget.long,
      "address": widget.address,
      "email": widget.email,
      "image": widget.image
    }).whenComplete(() {
      sendMessage();
      print("Resolved");
      showDialog(
          builder: (context) => AlertDialog(
                title: Text("Resolved"),
                actions: [
                  FlatButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
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
      ..subject = 'Your Complain is resolved'
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
              widget.long.toString());

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

  // _onMapCreated(GoogleMapController controller) {
  //   setState(() {});
  // }
}
