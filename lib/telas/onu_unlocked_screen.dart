
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netcompany_prospeccoes/datas/onu_data.dart';
import 'package:carousel_pro/carousel_pro.dart';
class OnuUnlockedScreen extends StatefulWidget {
  final OnuData onu;
  OnuUnlockedScreen(this.onu);

  @override
  _OnuUnlockedScreenState createState() => _OnuUnlockedScreenState(onu);
}

class _OnuUnlockedScreenState extends State<OnuUnlockedScreen> {
  final OnuData onu;
  String size;

  TextEditingController _controllerNome = TextEditingController();
  var c = 1;

  Color _corB = Colors.grey;
  _OnuUnlockedScreenState(this.onu);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    if(c == 1){
      _controllerNome.text = onu.alias;
      c = c-1;
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(onu.OntSN[0]),
        centerTitle: true,
        leading: IconButton(
          iconSize: ScreenUtil().setSp(50),
          padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
          icon: FaIcon(FontAwesomeIcons.caretLeft, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: onu.images.map((url) {
                return Image.network(
                  url,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                );
              }).toList(),
              dotSize: ScreenUtil().setSp(8),
              dotBgColor: Colors.transparent,
              dotSpacing: ScreenUtil().setWidth(30),
              autoplay: false,
              dotColor: Theme.of(context).primaryColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ScreenUtil().setSp(35.0)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Frame/Slot/Pon",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  onu.FSP,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(40),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
                  maxLines: 3,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(18),
                ),
                Text(
                  "ONU/ONT ID",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  onu.onuid.toString(),
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(40),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
                  maxLines: 3,
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(18),
                ),
                Text(
                  "Numero de serie",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  onu.OntSN[0] + " " + onu.OntSN[1],
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(18),
                ),
                Text(
                  "Modelo",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  onu.EquipmentID,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(26),
                ),
                Text(
                  "PPPoE do cliente",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: ScreenUtil().setHeight(8),
                    top: ScreenUtil().setHeight(8),
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                  ),
                  child: Text(
                    onu.alias,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(35),
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                ),

                SizedBox(
                  height: ScreenUtil().setHeight(26),
                ),
                Text(
                  "Horário do desbloqueio",
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(35),
                      fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    bottom: ScreenUtil().setHeight(8),
                    top: ScreenUtil().setHeight(8),
                    left: ScreenUtil().setWidth(10),
                    right: ScreenUtil().setWidth(10),
                  ),
                  child: Text(onu.dataDesbloqueio,
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(35),
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(26),
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Solicitante",
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(35),
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        onu.TecSolicitante,
                        style: TextStyle(
                            fontSize: ScreenUtil().setSp(35),
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),

                    ],
                  )
                ),

              ],
            ),
          )
        ],
      ),
    );
  }
}
