import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netcompany_prospeccoes/telas/onus_screen.dart';

class OnusTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  OnusTile(this.snapshot);


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          ScreenUtil().setWidth(15.0),
          ScreenUtil().setHeight(15.0),
          ScreenUtil().setWidth(20.0),
          ScreenUtil().setHeight(15.0)),
      child: ListTile(
        title: Text(
          snapshot.data()["title"],
          style: TextStyle(fontSize: ScreenUtil().setSp(40)),
        ),
        trailing: FaIcon(FontAwesomeIcons.angleRight),
        onTap: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context)=>OnusScreen(snapshot))
          );
        },
      ),
    );
  }
}
