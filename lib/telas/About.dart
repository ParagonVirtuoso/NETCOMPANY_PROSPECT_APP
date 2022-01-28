import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(
          "Em Breve",
          style: TextStyle(fontSize: ScreenUtil().setSp(80)),
        ),
      ),
    );
  }
}
