import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:netcompany_prospeccoes/datas/onu_data.dart';
import 'package:netcompany_prospeccoes/telas/onu_screen.dart';
import 'package:netcompany_prospeccoes/telas/onu_unlocked_screen.dart';

class OnuUnlockedTile extends StatelessWidget {
  final OnuData onu;
  OnuUnlockedTile(this.onu);

  @override
  Widget build(BuildContext context) {
    String onuImage = 'assets/ONU.jpg';
    if(onu.EquipmentID == 'G103 v3.0'){
      onuImage = 'assets/G103 v3.0 (1).jpg';
    }
    if(onu.EquipmentID == 'G103v3.0'){
      onuImage = 'assets/G103 v3.0 (1).jpg';
    }
    if(onu.EquipmentID == 'ONT1'){
      onuImage = 'assets/ONT1 (2).jpg';
    }
    if(onu.EquipmentID == 'SM16101-GHZ-T10'){
      onuImage = 'assets/SM16101-GHZ-T10(1).png';
    }

    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => OnuUnlockedScreen(onu))
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 0.8,
              child: Image.asset(
                onuImage,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(
                    ScreenUtil().setWidth(15.0),
                    ScreenUtil().setHeight(15.0),
                    ScreenUtil().setWidth(15.0),
                    ScreenUtil().setHeight(15.0)),
                child: Column(
                  children: [
                    Text(
                      onu.alias,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(26)),
                    ),
                    Text(
                      onu.OntSN[0],
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: ScreenUtil().setSp(31),
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
