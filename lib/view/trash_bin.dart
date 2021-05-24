import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:registraron_screen/models/trash_bin_model.dart';
import 'package:registraron_screen/view/map.dart';

class TrashBin extends StatefulWidget {
  @override
  _TrashBinState createState() => _TrashBinState();
}

class _TrashBinState extends State<TrashBin> {
  List<TrashBinModel> trashBin = [];
  final databaseReference = FirebaseDatabase.instance.reference();
  FlutterLocalNotificationsPlugin fltrNotification = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var androidInitilize = new AndroidInitializationSettings('trash');
    var iOSinitilize = new IOSInitializationSettings();
    var initilizationsSettings = new InitializationSettings(android: androidInitilize,iOS: iOSinitilize),
        fltrNotification = new FlutterLocalNotificationsPlugin();
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
    //getTrashBin();
    trashBin.clear();
    readData();
  }

  Future notificationSelected(String payload) async {
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     content: Text("Notification : $payload"),
    //   ),
    // );
  }

  Future _showNotification(String data) async {
    var androidDetails = new AndroidNotificationDetails(
        "Channel ID", "Desi programmer", "This is my channel",
        importance: Importance.max);
    var iSODetails = new IOSNotificationDetails();
    var generalNotificationDetails =
    new NotificationDetails(android: androidDetails,iOS: iSODetails);

    await fltrNotification.show(1, "Trash Bin Status", "Trash bin is ${data}", generalNotificationDetails, payload: "Status: ${data}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Trash Bin",style: TextStyle(color: Colors.white),),
      ),
      body:trashBin.length <= 0? Center(child: CircularProgressIndicator()) : ListView.builder(
          itemCount: 1,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.delete,color: Colors.white,),
                  ),
                  title: Center(child: Text(trashBin[index].id)),
                  trailing: IconButton(
                    onPressed: (){
                      print(trashBin[index].location["longitude"].toString());
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MapsScreen(
                        isMap: false,
                        lat: trashBin[index].location["latitude"],
                        long: trashBin[index].location["longitude"],
                        address: trashBin[index].location["address"],
                        email: "",
                        id: "",
                        k: true,
                        image: "",
                        isdetail: true,
                      )));
                    },
                    icon: Icon(Icons.location_on,color: Colors.red,),),
                  subtitle: Column(
                    children: [
                      //Text("Distance: "+trashBin[index].distance),
                      //Text("Address: "+trashBin[index].address,textAlign: TextAlign.center,),
                      Text("Status: "+trashBin[index].status),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
  getTrashBin() async {
    var url = 'https://mobileauth-bf4e3.firebaseio.com/Trash Bin.json';
    try{
      final response = await http.get(url);
      print(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData == null){
        return;
      }
      extractedData.forEach((key, value) { 
        setState(() {
          trashBin.add(TrashBinModel(
              key,
              value["Distance"].toString(),
              value["status"],
              value["location"]
          ));
        });
      });
    }catch(error){
      throw error;
    }
  }
  void readData(){
    setState(() {
      trashBin.clear();
    });
    databaseReference.once().then((DataSnapshot snapshot) {
      print('Data : ${snapshot.value["Trash Bin"]}');
      snapshot.value["Trash Bin"].forEach((key, value){
        setState(() {
          trashBin.add(TrashBinModel(
              key,
              value["Distance"].toString(),
              value["status"],
              value["location"]
          ));
        });
      });
    });
    FirebaseDatabase.instance
        .reference()
        .child('Trash Bin')
        .onChildChanged
        .listen((event) {
          trashBin.clear();
          readData();
          print("Notification");
          _showNotification(event.snapshot.value["status"]);
        });
   // trashBin.clear();
  }
}
