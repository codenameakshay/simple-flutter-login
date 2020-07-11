import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yehlo/ui/backdrop.dart';
import 'package:yehlo/ui/detailssheet.dart';
import 'package:yehlo/ui/wallsheet.dart';

class WallpaperForm extends StatefulWidget {
  @override
  _WallpaperFormState createState() => _WallpaperFormState();
}

class _WallpaperFormState extends State<WallpaperForm> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, width: 720, height: 1440, allowFontScaling: true);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Backdrop(),
          WallSheet(),
        ],
      ),
    );
  }
}
