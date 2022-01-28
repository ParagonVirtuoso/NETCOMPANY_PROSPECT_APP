import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:netcompany_prospeccoes/datas/onu_data.dart';
import 'package:netcompany_prospeccoes/tiles/onu_tile.dart';
import 'package:netcompany_prospeccoes/tiles/onu_unlocked_tile.dart';
import 'package:netcompany_prospeccoes/utils/lower_case.dart';

class OnusScreen extends StatefulWidget {
  final DocumentSnapshot snapshot;

  OnusScreen(this.snapshot);

  @override
  _OnusScreenState createState() => _OnusScreenState();
}

class _OnusScreenState extends State<OnusScreen> {
  var _pesquisaController;

  var ctr = 1;

  var modificador;
  String userpesquisa;

  @override
  Widget build(BuildContext context) {
    if (ctr == 1) {
      if (widget.snapshot.data()["title"] == 'Provisionadas') {
        modificador = 'liberados';
      } else {
        modificador = 'disponivel';
      }
      ctr = ctr - 1;
    }
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            iconSize: ScreenUtil().setSp(50),
            padding: EdgeInsets.only(left: ScreenUtil().setWidth(40)),
            icon: FaIcon(FontAwesomeIcons.caretLeft, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0.0,
          title: Text(widget.snapshot.data()["title"]),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: ScreenUtil().setHeight(10),
                  bottom: ScreenUtil().setHeight(10)),
              height: ScreenUtil().setHeight(110),
              width: ScreenUtil().setWidth(650),
              child: ((){
                if(modificador == 'liberados'){
                  return TextField(
                    inputFormatters: [LowerCaseTextFormatter()],
                    onChanged: (value) {

                      setState(() {
                        userpesquisa = value.toLowerCase();
                      });
                    },
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.text,
                    autocorrect: false,
                    autofocus: false,
                    controller: _pesquisaController,
                    style: TextStyle(fontSize: ScreenUtil().setSp(31)),
                    decoration: InputDecoration(

                        contentPadding: EdgeInsets.all(ScreenUtil().setSp(5)),
                        prefixIcon: Container(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setSp(35),
                              top: ScreenUtil().setHeight(18),
                              bottom: ScreenUtil().setHeight(18),
                              right: ScreenUtil().setSp(35)),
                          child: Image.asset("assets/LOGO_ICONE.png"),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color.fromARGB(255,0, 71, 171), width: 1.0),
                            borderRadius: BorderRadius.circular(25.0)),
                        border: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color.fromARGB(255,0, 71, 171), width: 1.0),
                            borderRadius: BorderRadius.circular(25.0)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Color.fromARGB(255,0, 71, 171), width: 1.0),
                            borderRadius: BorderRadius.circular(25.0)),

                        filled: true,
                        hintText: "Digite o PPPoE do cliente",
                        fillColor: Colors.white70),
                  );
                }else Container();
              }())
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: (userpesquisa != "" && userpesquisa != null)
                        ? FirebaseFirestore.instance
                            .collection("fibra")
                            .doc(widget.snapshot.id)
                            .collection(modificador)
                            .orderBy('Alias')
                            .startAt([userpesquisa]).endAt(
                                [userpesquisa + '\uf8ff']).snapshots()
                        : FirebaseFirestore.instance
                            .collection("fibra")
                            .doc(widget.snapshot.id)
                            .collection(modificador)
                            .orderBy('Alias')
                            .startAt(['']).endAt(['' + '\uf8ff']).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else
                        return GridView.builder(
                            padding: EdgeInsets.all(ScreenUtil().setSp(10.0)),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: ScreenUtil().setSp(10),
                              crossAxisSpacing: ScreenUtil().setSp(10),
                              childAspectRatio: 0.65,
                            ),
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              OnuData data = OnuData.fromDocument(
                                  snapshot.data.docs[index]);

                              data.id = this.widget.snapshot.id;

                              if (modificador == 'liberados') {
                                return OnuUnlockedTile(data);
                              } else {
                                return OnuTile(onu: data);
                              }
                            });
                    }))
          ],
        ));
  }
}


