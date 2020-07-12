import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:github/github.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yehlo/globals.dart';
import 'package:yehlo/screens/wallshow.dart';
import 'package:yehlo/ui/inputtextfiels.dart';
import 'package:yehlo/ui/submitbutton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:yehlo/ui/submitbuttondisabled.dart';
import 'package:image/image.dart' as Img;

class WallSheet extends StatefulWidget {
  @override
  _WallSheetState createState() => _WallSheetState();
}

class _WallSheetState extends State<WallSheet> {
  final databaseReference = Firestore.instance;
  final myController1 = TextEditingController();
  final myController2 = TextEditingController();
  final myController3 = TextEditingController();
  final myController4 = TextEditingController();
  final myController5 = TextEditingController();
  final myController6 = TextEditingController();
  final myController7 = TextEditingController();
  File _image;
  String _uploadedFileURL;
  String _uploadedResizedFileURL;
  bool isUploading = false;
  String id = "";
  bool islocation = false;

  void randomId() {
    id = "";
    var alp = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split("");
    var r = new Random();
    var choice = r.nextInt(4);
    for (var i = 0; i < 4; i++) {
      if (choice == i) {
        var ran = r.nextInt(10);
        id = id + ran.toString();
      } else {
        var ran = r.nextInt(26);
        id = id + alp[ran].toString();
      }
    }
    setState(() {
      myController1.text = id;
    });
    print(id);
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    randomId();
    setState(() {
      _image = image;
    });
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    print(decodedImage.width);
    print(decodedImage.height);
    var res =
        decodedImage.width.toString() + "x" + decodedImage.height.toString();
    setState(() {
      myController3.text = res;
    });
    image.length().then((value) =>
        {myController5.text = (value / 1024 / 1024).toStringAsFixed(2) + "MB"});
    uploadFile();
    print(image.toString());
  }

  Future uploadFile() async {
    setState(() {
      isUploading = true;
    });
    List<int> imageBytes = await _image.readAsBytes();
    Img.Image thumbnail =
        Img.copyResize(Img.decodeImage(imageBytes), width: 250, height: 500);
    List<int> imageBytesThumb = Img.encodePng(thumbnail);
    String base64Image = base64Encode(imageBytes);
    String base64ImageThumb = base64Encode(imageBytesThumb);
    var github = GitHub(auth: Authentication.basic(username, password));
    github.repositories
        .createFile(
            RepositorySlug('codenameakshay2', 'prism-walls'),
            CreateFile(
                message: "${Path.basename(_image.path)}",
                content: base64Image,
                path: '${Path.basename(_image.path)}'))
        .then((value) => setState(() {
              _uploadedFileURL = value.content.downloadUrl;
              myController2.text = value.content.downloadUrl;
              isUploading = false;
            }));
    github.repositories
        .createFile(
            RepositorySlug('codenameakshay2', 'prism-walls'),
            CreateFile(
                message: "thumb_${Path.basename(_image.path)}",
                content: base64ImageThumb,
                path: 'thumb_${Path.basename(_image.path)}'))
        .then((value) => setState(() {
              _uploadedResizedFileURL = value.content.downloadUrl;
            }));
    print('File Uploaded');
  }

  void createRecord() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await databaseReference.collection("walls").add({
      'by': preferences.getString('by'),
      'email': preferences.getString('email'),
      'userPhoto': preferences.getString('userPhoto'),
      'id': myController1.text,
      'wallpaper_provider': myController4.text,
      'wallpaper_thumb': _uploadedResizedFileURL,
      'wallpaper_url': _uploadedFileURL,
      'resolution': myController3.text,
      'size': myController5.text,
      'category': myController6.text,
      'desc': myController7.text,
    });
  }

  @override
  void initState() {
    randomId();
    super.initState();
  }

  @override
  void dispose() {
    myController1.dispose();
    myController2.dispose();
    myController3.dispose();
    myController4.dispose();
    myController5.dispose();
    myController6.dispose();
    myController7.dispose();
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
          height: 1200.h,
          width: 720.w,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "Walls",
                          style: TextStyle(
                            fontFamily: "Berkshire Swash",
                            fontSize: 58,
                            color: Color(0xFF1E4746),
                          ),
                        ),
                        MaterialButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            HapticFeedback.vibrate();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return WallShow();
                                },
                              ),
                            );
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          highlightElevation: 0,
                          padding: EdgeInsets.all(20),
                          child: Ink(
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF70D9D6).withOpacity(0.8),
                                    spreadRadius: 3,
                                    blurRadius: 10,
                                    offset: Offset(
                                        0, 4), // changes position of shadow
                                  ),
                                ],
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff1E4746),
                                    Color(0xff70D9D6)
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(50.0)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Text(
                                'Already uploaded',
                                style: TextStyle(
                                  fontFamily: "Noto Sans",
                                  fontSize: 16,
                                  color: Color(0xFFF2F2F2),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 0, 0, 30),
                    child: Text(
                      "Please fill in the wallpaper details",
                      style: TextStyle(
                        fontFamily: "Noto Sans",
                        fontSize: 14,
                        color: Color(0xFF1E4746),
                      ),
                    ),
                  ),
                ),
                InputTextField(
                  myController: myController1,
                  text: "Wallpaper ID",
                  icon: Icons.wallpaper,
                  initialText: id,
                ),
                InputTextField(
                  myController: myController2,
                  text: "Wallpaper URL",
                  icon: Icons.insert_link,
                  initialText: "",
                ),
                InputTextField(
                  myController: myController3,
                  text: "Wallpaper Resolution",
                  icon: Icons.photo,
                  initialText: "2000x4000",
                ),
                InputTextField(
                  myController: myController4,
                  text: "Wallpaper provider",
                  icon: Icons.business,
                  initialText: "Prism",
                ),
                InputTextField(
                  myController: myController5,
                  text: "Wallpaper Size",
                  icon: Icons.play_arrow,
                  initialText: "2MB",
                ),
                InputTextField(
                  myController: myController7,
                  text: "Desc",
                  icon: Icons.image,
                  initialText: "Designed by Freepik",
                ),
                InputTextField(
                  myController: myController6,
                  text: "Category Name",
                  icon: Icons.image,
                  initialText: "General",
                ),
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
                            labelText: isUploading
                                ? "Uploading"
                                : _uploadedFileURL != null
                                    ? "Uploaded"
                                    : "Wallpaper",
                            labelStyle: TextStyle(
                              fontFamily: "Noto Sans",
                              color: Color(0xFF1E5C5A),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            prefixIcon: isUploading
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Color(0xFF1E5C5A)),
                                    ),
                                  )
                                : _uploadedFileURL != null
                                    ? Icon(
                                        Icons.check_box,
                                        color: Color(0xFF1E5C5A),
                                      )
                                    : Icon(
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
                // InputLocationField(
                //     islocation: islocation, locationData: _locationData),
                _uploadedFileURL != null &&
                        !isUploading &&
                        myController1.text != "" &&
                        myController2.text != "" &&
                        myController3.text != "" &&
                        myController4.text != "" &&
                        myController5.text != "" &&
                        myController6.text != ""
                    ? SubmitButton(createRecord, true)
                    : SubmitButtonDisabled(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
