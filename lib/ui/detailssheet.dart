import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:yehlo/screens/sign_in.dart';
import 'package:yehlo/ui/inputlocationfield.dart';
import 'package:yehlo/ui/inputtextfiels.dart';
import 'package:yehlo/ui/submitbutton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsSheet extends StatefulWidget {
  @override
  _DetailsSheetState createState() => _DetailsSheetState();
}

class _DetailsSheetState extends State<DetailsSheet> {
  final databaseReference = Firestore.instance;
  final myController = TextEditingController();
  File _image;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  bool islocation = false;

  Future getLoc() async {
    Location location = new Location();
    islocation = false;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    setState(() {
      islocation = true;
    });
    print(_locationData.toString());
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
    });
    print(image.toString());
  }

  void createRecord() async {
    await databaseReference.collection("users").document(userId).setData({
      'pgName': myController.text,
      'pgImage': _image.path.toString(),
      'pgLocation':
          "Lat : ${_locationData.latitude}, Long : ${_locationData.longitude}"
    });
  }

  @override
  void initState() {
    super.initState();
    getLoc();
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        margin: EdgeInsets.all(0),
        color: Color(0xFFF2F2F2),
        child: SizedBox(
          height: 980.h,
          width: 720.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                  child: Text(
                    "Details",
                    style: TextStyle(
                      fontFamily: "Berkshire Swash",
                      fontSize: 58,
                      color: Color(0xFF1E4746),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                  child: Text(
                    "Please fill in the PG Details",
                    style: TextStyle(
                      fontFamily: "Noto Sans",
                      fontSize: 14,
                      color: Color(0xFF1E4746),
                    ),
                  ),
                ),
              ),
              InputTextField(myController: myController),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),
                    gradient: LinearGradient(
                      colors: [
                        Color(0xff1E4746).withOpacity(0.1),
                        Color(0xff70D9D6).withOpacity(0.1)
                      ],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          fillColor: Colors.red,
                          labelText: "PG Image",
                          labelStyle: TextStyle(
                            fontFamily: "Noto Sans",
                            color: Color(0xFF1E5C5A),
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.image,
                            color: Color(0xFF1E5C5A),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.vibrate();
                          getImage();
                        },
                        child: SizedBox(
                          height: 100.h,
                          width: 720.w,
                          child: Text(" "),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InputLocationField(
                  islocation: islocation, locationData: _locationData),
              SubmitButton(createRecord),
            ],
          ),
        ),
      ),
    );
  }
}
