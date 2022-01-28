import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netcompany_prospeccoes/datas/onu_data.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:netcompany_prospeccoes/model/user_model.dart';
import 'package:netcompany_prospeccoes/telas/Home.dart';
import 'package:netcompany_prospeccoes/telas/Login.dart';
import 'package:netcompany_prospeccoes/utils/lower_case.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OnuScreen extends StatefulWidget {
  final OnuData onu;
  OnuScreen(this.onu);

  @override
  _OnuScreenState createState() => _OnuScreenState(onu);
}

class _OnuScreenState extends State<OnuScreen> {
  final OnuData onu;
  String size;

  TextEditingController _controllerNome = TextEditingController();
  String _tipo = 'onu';
  var c = 1;

  Color _corB = Colors.grey;

  var _tipoInicial = 0;
  var _tipoTrava = true;
  _OnuScreenState(this.onu);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    if(c == 1){
      _controllerNome.text = onu.alias;
      c = c-1;
    }
    if(onu.tipo != ''){
      _tipoTrava = false;
      if(onu.tipo == 'onu'){
        _tipoInicial = 0;
      }
      if(onu.tipo == 'ont'){
        _tipoInicial = 1;
      }
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
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleSwitch(

                      minWidth: ScreenUtil().setWidth(150),
                      cornerRadius: ScreenUtil().setSp(40),
                      activeBgColors: [[Colors.blue[800]], [Theme.of(context).primaryColor]],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey[400],
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: _tipoInicial,
                      totalSwitches: 2,
                      labels: ['ONU', 'ONT'],
                      radiusStyle: true,
                      changeOnTap: _tipoTrava,
                      onToggle: (index) {
                        GetTipo(index);
                      },
                    ),
                  ],
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
                  child: GetUserPppoe(),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(26),
                ),
                Column(
                  children: [
                    GetAddOrUnlocker()
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  GetAddOrUnlocker() {
    if(onu.TecSolicitante == ""){
      return RaisedButton(
        onPressed: () {
          if (UserModel.of(context).isLoggedIn()) {
            if (_controllerNome.text != null) {
              onu.alias = _controllerNome.text;
              onu.TecSolicitante =  UserModel.of(context).firebaseUser.email;
              onu.tipo = _tipo;
              FirebaseFirestore.instance
                  .collection('fibra')
                  .doc('onu')
                  .collection('disponivel')
                  .doc(onu.OntSN[0].toString())
                  .update(onu.resAliasToMap());
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content:
                Text("Solicitação de desbloqueio enviada ao servidor, aguarde a liberação"),
                backgroundColor: Theme.of(context).primaryColor,
                duration: Duration(seconds: 3),
              ));

              Timer(Duration(seconds: 3), () {
                // 5s over, navigate to a new page

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context)=>Home()),ModalRoute.withName('/home')
                );
              });
            } else {
              _scaffoldKey.currentState.showSnackBar(SnackBar(
                content:
                Text("Preencha o PPPoE antes de solictar!"),
                backgroundColor: Theme.of(context).errorColor,
                duration: Duration(seconds: 3),
              ));
            }
          } else {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => Login()));
          }
        },
        child: Text(
          UserModel.of(context).isLoggedIn()
              ? "Adcionar a fila de desbloqueio"
              : "Entre para desbloquear",
          style: TextStyle(
            fontSize: ScreenUtil().setSp(33),
          ),
        ),
        textColor: Colors.white,
        color: _corB,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(ScreenUtil().setSp(35))),
      );
    }else{

      return Column(
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
      );

    }
  }

  GetUserPppoe() {
    if(onu.TecSolicitante == ''){
      return TextField(
        controller: _controllerNome,
        autofocus: false,
        autocorrect: false,
        inputFormatters: [LowerCaseTextFormatter()],
        onChanged: (value) {
          setState(() {
            _corB = Theme.of(context).primaryColor;
          });
        },
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: ScreenUtil().setSp(35)),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(
                ScreenUtil().setWidth(30),
                ScreenUtil().setHeight(15),
                ScreenUtil().setWidth(30),
                ScreenUtil().setHeight(15)),
            hintText: "exemplo.pppoe",
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32))),
      );
    }else{
      return Text(
        onu.alias,
        style: TextStyle(
            fontSize: ScreenUtil().setSp(35),
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor),
      );

    }
  }
  void GetTipo(index) {

    if(onu.tipo == ''){
      if(index == 0){
        _tipo = "onu";
      }
      if(index == 1){
        _tipo = "ont";
      }
    }
  }
}


