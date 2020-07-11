import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yehlo/screens/wallpaper_form.dart';
import 'package:yehlo/ui/backdrop.dart';
import 'package:yehlo/ui/detailssheet.dart';

class InputForm extends StatefulWidget {
  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1440, allowFontScaling: true);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Backdrop(),
          DetailsSheet(),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.wallpaper),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WallpaperForm(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
