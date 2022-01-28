import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:netcompany_prospeccoes/datas/onu_data.dart';
import 'package:netcompany_prospeccoes/telas/onu_screen.dart';




class OnuTile extends StatefulWidget {
  OnuData onu;
  OnuTile({ Key key, this.onu }): super(key: key);

  @override
  _OnuTileState createState() => _OnuTileState();
}

class _OnuTileState extends State<OnuTile> {

  @override
  void initState() {
    liberandiOnu();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    String onuImage = 'assets/ONU.jpg';
    if(widget.onu.EquipmentID == 'G103 v3.0'){
      onuImage = 'assets/G103 v3.0 (1).jpg';
    }
    if(widget.onu.EquipmentID == 'G103v3.0'){
      onuImage = 'assets/G103 v3.0 (1).jpg';
    }
    if(widget.onu.EquipmentID == 'ONT1'){
      onuImage = 'assets/ONT1 (2).jpg';
    }
    if(widget.onu.EquipmentID == 'SM16101-GHZ-T10'){
      onuImage = 'assets/SM16101-GHZ-T10(1).png';
    }
    return InkWell(
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => OnuScreen(widget.onu))
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [

                Center(
                  child: AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.asset(
                      onuImage,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                liberandiOnu()
              ],
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
                      widget.onu.FSP,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: ScreenUtil().setSp(26)),
                    ),
                    Text(
                      widget.onu.OntSN[0],
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

  liberandiOnu() {
    var zv;

      if(widget.onu.alias == ""){
        zv = Center();
      }else{
        zv = Center(
          child: CircularProgressIndicator(),
        );
      }
      return zv;

  }
}
