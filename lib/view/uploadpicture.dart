import 'dart:io';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:registraron_screen/constants/theme.dart';
import 'package:registraron_screen/view/colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:registraron_screen/view/my_complains.dart';
import 'package:registraron_screen/view/report_success.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:animations/animations.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mailer/mailer.dart' as add;
import 'package:mailer/smtp_server/gmail.dart';
import 'package:registraron_screen/view/homescreen.dart';

import 'welcomescreen.dart';

// import 'package:latlng/latlng.dart';

class UploadingImageToFirebaseStorage extends StatefulWidget {
  final String email;
  final String id;
  final double lat;
  final double long;
  final String address;

  const UploadingImageToFirebaseStorage(
      {Key key, this.email, this.id, this.address, this.lat, this.long})
      : super(key: key);
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // Geoflutterfire geo = Geoflutterfire();

  File _imageFile;
  LatLng latLng;
  double pLat, pLong;
  String address;
  bool loading = true;

  String url = "";

  bool isLoading = false;

  final picker = ImagePicker();

  Future pickImage(BuildContext context) {
    try {
      picker.getImage(source: ImageSource.camera).then((value) {});
    } catch (e) {
      showDialog(
        //context: context,
        builder: (context) => AlertDialog(
          title: Text("Warning"),
          content: Text('Please capture an Image'),
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
    }
  }

  onImageButtonPressed(ImageSource source,
      {BuildContext context, capturedImageFile}) async {
    final ImagePicker _picker = ImagePicker();
    File val;

    final pickedFile = await _picker.getImage(
      source: source,
    );

    val = await ImageCropper.cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      compressQuality: 100,
      maxHeight: 700,
      maxWidth: 700,
      compressFormat: ImageCompressFormat.jpg,
      androidUiSettings: AndroidUiSettings(
        toolbarColor: Colors.white,
        toolbarTitle: "genie cropper",
      ),
    );
    //
    setState(() {
      _imageFile = File(val.path);
    });
    uploadPic(context, File(_imageFile.path));
  }

  //upload image to API and get Response.

  void uploadImageToFirebase(BuildContext context) async {
    if(_imageFile == null){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Trash Detector"),
          content: Text("No image selected."),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: () async {
                setState(() {
                  _imageFile = null;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }else{
    setState(() {
      isLoading = true;
    });
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://flask-api-trash.herokuapp.com/api'));
    request.files
        .add(await http.MultipartFile.fromPath('image', _imageFile.path));
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print(response.body);
    bool success = jsonDecode(response.body)["success"];
    bool data = jsonDecode(response.body)["data"];
    // print(success);
    if (success == true) {
      if (data == false) {
        print("Trash");
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Result"),
            content: Text("Trash"),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () async {
                  setState(() {
                    _imageFile = null;
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Report"),
                onPressed: () {
                  //uploadPic(context);
                  report(context);
//                  setState(() {
//                    _imageFile = null;
//                    Navigator.pop(context);
//                  });
                },
              ),
            ],
          ),
        );
      } else {
        print("Trash");
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Result"),
            content: Text("Trash"),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () async {
                  setState(() {
                    _imageFile = null;
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Report"),
                onPressed: () {
                  report(context);
                },
              ),
            ],
          ),
        );
      }
    }}
  }
  void uploadImageToFirebase1(BuildContext context) async {
    if(_imageFile == null){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Trash Detector"),
          content: Text("No image selected."),
          actions: [
            FlatButton(
              child: Text("Ok"),
              onPressed: () async {
                setState(() {
                  _imageFile = null;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }else{
    setState(() {
      isLoading = true;
    });
    var request = http.MultipartRequest(
        'POST', Uri.parse('https://flask-api-trash.herokuapp.com/api'));
    request.files
        .add(await http.MultipartFile.fromPath('image', _imageFile.path));
    var res = await request.send();
    var response = await http.Response.fromStream(res);
    print(response.body);
    bool success = jsonDecode(response.body)["success"];
    bool data = jsonDecode(response.body)["data"];
    // print(success);
    if (success == true) {
      if (data == false) {
        print("Not trash");
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Resut"),
            content: Text("Not Trash"),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () async {
                  setState(() {
                    _imageFile = null;
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Report"),
                onPressed: () {
                  report(context);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      } else {
        print("Not trash");
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Resut"),
            content: Text("Not Trash"),
            actions: [
              FlatButton(
                child: Text("Ok"),
                onPressed: () async {
                  setState(() {
                    _imageFile = null;
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Report"),
                onPressed: () {
                  report(context);
                  setState(() {});
                },
              ),
            ],
          ),
        );
      }
    }}
  }

  report(BuildContext context) {
    FirebaseFirestore.instance.collection("Trash").doc().set({
      "latitude": latLng.latitude,
      "longitude": latLng.longitude,
      "address": address,
      "url": url,
      "email": widget.email,
      "type":"kmckarachiauth@gmail.com"
    }).whenComplete(() {
      print("Reported");
      getEmail();
      sendEmail();

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReportSuccess(
                    email: widget.email,
                    image: _imageFile,
                    address: address,
                  )));
//      showDialog(
//          builder: (context) => AlertDialog(
//            title: Text("Report Send"),
//            actions: [
//              FlatButton(onPressed: (){
//                setState(() {
////                  Navigator.pop(context);
////                  Navigator.pop(context);
//
//                });
//              }, child: Text('Ok'))
//            ],
//          ),
//          context: context);
    });
  }

  Future uploadPic(BuildContext context, File imageFile) async {
    String fileName = basename(imageFile.path);
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('Trash Images/$fileName');
    //  Reference ref = Storage.ref()child('Trash Images/$fileName');
    UploadTask uploadTask = ref.putFile(imageFile);
    uploadTask.whenComplete(() {
      ref.getDownloadURL().then((value) {
        print(value);
        url = value;
      });
    }).catchError((onError) {
      print(onError);
    });
    // StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;

    // final String url = (await taskSnapshot.ref.getDownloadURL());

//    setState(() {
//      print("Profile Picture uploaded");
//      print("....................$url");
//      Scaffold.of(context)
//          .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
//    });
  }

  String _locationMessage = "";

  // void _getCurrentLocation() async {

  //   final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   print(position);
  //   print('Latitude: ${position.latitude}');
  //   print('Longitude: ${position.longitude}');

  //   setState(() {
  //     _locationMessage = "${position.latitude}, ${position.longitude}";

  //   });

  // }

  getlocation(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(coordinates);
    print('LATTITUDE: ${coordinates.latitude}');
    print('LONGITUDE: ${coordinates.longitude}');
    print('ADDRESS: $addresses');
    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      var address = addresses.first;
      print(address.addressLine);
      this.address = address.addressLine;
      loading = false;
    });
    showDialog(
        builder: (context) => AlertDialog(
              title: Text("Location"),
              content: Text('GEOPOINTS: $coordinates'),
              actions: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Save'))
              ],
            ),
        context: context);
  }

  getAddress(BuildContext context) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(coordinates);
    print('LATTITUDE: ${coordinates.latitude}');
    print('LONGITUDE: ${coordinates.longitude}');
    print(addresses);
    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      address = addresses.first.toString();
      print(address);
      //this.address = address.addressLine.toString();
      loading = false;
    });
    showDialog(
        builder: (context) => AlertDialog(
              title: Text("Location"),
              content: Text('GEOPOINTS: $address'),
              actions: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pop(context);
                      });
                    },
                    child: Text('Save'))
              ],
            ),
        context: context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCord();
  }

  getCord() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(coordinates);
    print('LATTITUDE: ${coordinates.latitude}');
    print('LONGITUDE: ${coordinates.longitude}');
    print('ADDRESS: $addresses');
    setState(() {
      latLng = LatLng(position.latitude, position.longitude);
      var address = addresses.first;
      print(address.addressLine);
      this.address = address.addressLine;
      loading = false;
    });
  }

  getEmail() async {
    String username = 'kmckarachiauth@gmail.com';
    String password = 'hasanyousufi123';

    final smtpServer = gmail(username, password);
    final message = add.Message()
      ..from = add.Address(username, 'Trash Detector')
      ..recipients.add(widget.email)
      ..subject = 'Your Complain has been launched'
      ..text =
          ('Thankyou for filing a complaint, We value your time and contribution in order to keep the city Clean. \n Complain Id: '
                  '\n' +
              'Your address: \n' + address + '\n' +
              'your cordinates: \n' +
              'Latitude: ' + latLng.latitude.toString() +
              '\n'
              'Longitude:  ' +   latLng.latitude.toString()+ 
              'Your comlain image link: ' + url +
              '\n  you will Recieved An email As soon as your complain will be resolved. \n Thankyou. \n\n Regards, \n Karachi Metropolitian corporation.');

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
  sendEmail() async {
    String username = 'hasanyousufidt@gmail.com';
    String password = 'hasandigi123';

    final smtpServer = gmail(username, password);
    final message = add.Message()
      ..from = add.Address(username, 'Trash Detector')
      ..recipients.add('kmckarachiauth@gmail.com')
      ..subject = 'Dear KMC you have received a new Complain'
      ..text =
      ('Please open your Application and proceed over the Dashboard. \n ' +
          'From address: \n' + address + '\n' +
          'The cordinates: \n' +
          'Latitude: ' + latLng.latitude.toString() +
          '\n'
              'Longitude:  ' +   latLng.latitude.toString()+
          'The comlain image link: ' + url +
          '\n ');

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

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        onTap: () => uploadImageToFirebase(context),
        child: Container(
          decoration: new BoxDecoration(
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
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
                    icon: Icon(
                      Icons.exit_to_app,
                      color: primary,
                    )),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                HomeScreen()
                          ));
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: primary,
                    )),
              ),
              Container(
                  //height: 360,
                  ),
              Container(
                margin: const EdgeInsets.only(top: 80),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text("Capture The Trash",
                            style: GoogleFonts.bitter(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: _height * 0.3,
                      width: _width,
                      child: Image.asset(
                        'assets/upload.png',
                      ),
                    ),
                    SizedBox(height: 20.0),
                    isLoading
                        ? Container(
                            height: 200,
                            child: Center(child: CircularProgressIndicator(backgroundColor: primary,)))
                        : Expanded(
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    // height: double.infinity,
                                    margin: const EdgeInsets.only(
                                        left: 10.0, right: 10.0, top: 10.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: _imageFile != null
                                          ? Image.file(_imageFile)
                                          : FlatButton(
                                              child: Icon(
                                                Icons.add_a_photo,
                                                size: 85,
                                                color: primary,
                                              ),
                                              onPressed: () {
                                                onImageButtonPressed(
                                                  ImageSource.camera,
                                                  context: context,
                                                  capturedImageFile: (s) {
                                                    setState(() {});
                                                  },
                                                );
                                              }),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                    uploadImageButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(30.0)),
            child: FlatButton(
              child: Text(
                "Upload Image",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: () => uploadImageToFirebase1(context),
              // onPressed: () => uploadPic(context)
            ),
          ),
        ],
      ),
    );
  }
}
