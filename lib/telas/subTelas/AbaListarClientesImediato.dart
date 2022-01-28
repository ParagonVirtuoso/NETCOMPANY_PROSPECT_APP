import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AbaListarClientesImediato extends StatefulWidget {
  @override
  _AbaListarClientesImediatoState createState() => _AbaListarClientesImediatoState();
}

class _AbaListarClientesImediatoState extends State<AbaListarClientesImediato> {
  Future _Data;

  Future getClient() async {
    var firestore = FirebaseFirestore.instance;

    QuerySnapshot querySn =
        await firestore.collection("clientes imediato").get();

    return querySn.docs;
  }

  navigateToDetail(DocumentSnapshot clienteEspecifico) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DetailPage(
                  clienteD: clienteEspecifico,
                )));
  }

  @override
  void initState() {
    super.initState();

    _Data = getClient();
  }

  @override
  Widget build(BuildContext context) {
    _Data = getClient();
    return Container(
      child: FutureBuilder(
          future: _Data,
          builder: (_, snapshot) {
      switch(snapshot.connectionState){
        case  ConnectionState.waiting:
          return Center(
            child: CircularProgressIndicator(),
          );
        case  ConnectionState.none:
        case ConnectionState.done:
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (_, index) {
              return ListTile(
                title: Card(
                  child: ListTile(
                      title: Text(snapshot.data[index]["nome"]),
                      subtitle:
                      Text(snapshot.data[index]["telefone"])),
                ),
                onTap: () => navigateToDetail(snapshot.data[index]),
              );
            });
        default:
          return Center(
            child: CircularProgressIndicator(),
          );
      }
          }),
    );
  }
}

class DetailPage extends StatefulWidget {
  final DocumentSnapshot clienteD;

  DetailPage({this.clienteD});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil().setSp(28, allowFontScalingSelf: true);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.clienteD.data()["nome"]),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    child: Card(
                      child: Padding(
                          padding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(30),
                            top: ScreenUtil().setHeight(30),
                            left: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Nome",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 13, 13, 115),
                                      fontSize: ScreenUtil().setSp(30))),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(20),
                                          top: ScreenUtil().setHeight(20),
                                          left: ScreenUtil().setWidth(30),
                                          right: ScreenUtil().setWidth(30),
                                        ),
                                        child: Text(widget.clienteD.data()["nome"],
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 13, 13, 115),
                                                fontSize: ScreenUtil().setSp(31))),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    )),
                Container(
                    child: Card(
                      child: Padding(
                          padding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(30),
                            top: ScreenUtil().setHeight(30),
                            left: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Email",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 13, 13, 115),
                                      fontSize: ScreenUtil().setSp(30))),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: ScreenUtil().setHeight(20),
                                          top: ScreenUtil().setHeight(20),
                                          left: ScreenUtil().setWidth(30),
                                          right: ScreenUtil().setWidth(30),
                                        ),
                                        child: Text(widget.clienteD.data()["email"],
                                            style: TextStyle(
                                                color: Color.fromARGB(255, 13, 13, 115),
                                                fontSize: ScreenUtil().setSp(31))),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )),
                    )),
                Container(
                    child: Card(
                      child: Padding(
                          padding: EdgeInsets.only(
                            bottom: ScreenUtil().setHeight(30),
                            top: ScreenUtil().setHeight(30),
                            left: ScreenUtil().setWidth(30),
                            right: ScreenUtil().setWidth(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                child: Text("Telefone",
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 13, 13, 115),
                                        fontSize: ScreenUtil().setSp(30))),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(
                                        bottom: ScreenUtil().setHeight(0),
                                        top: ScreenUtil().setHeight(0),
                                        left: ScreenUtil().setWidth(0),
                                        right: ScreenUtil().setWidth(0),
                                      ),
                                      child: FlatButton(
                                          onPressed: () {
                                            var number =
                                            widget.clienteD.data()["telefone"];
                                            launch('tel:$number');
                                          },
                                          child: Container(
                                            child: Text(
                                                widget.clienteD.data()["telefone"],
                                                style: TextStyle(
                                                    color: Color.fromARGB(
                                                        255, 13, 13, 115),
                                                    fontSize: ScreenUtil().setSp(31))),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child:  Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[

                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            right: ScreenUtil().setWidth(50),
                            top: ScreenUtil().setHeight(25),
                            bottom: ScreenUtil().setHeight(40)),
                        child: Container(
                          width: ScreenUtil().setWidth(300),
                          height: ScreenUtil().setHeight(80),
                          child: RaisedButton(
                            child: Text(
                              "Analisado",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 0, 71, 171),
                                  fontSize: ScreenUtil().setSp(35)),
                            ),
                            color: Colors.white,
                            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(32), ScreenUtil().setHeight(16), ScreenUtil().setWidth(32), ScreenUtil().setHeight(16)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)
                            ),
                            onPressed: () {

                            },
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: ScreenUtil().setHeight(25),
                            bottom: ScreenUtil().setHeight(40)),
                        child: Container(
                          width: ScreenUtil().setWidth(300),
                          height: ScreenUtil().setHeight(80),
                          child: RaisedButton(
                            child: Text(
                              "Remover",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 215, 60, 60),
                                  fontSize: ScreenUtil().setSp(35)),
                            ),
                            color: Colors.white,
                            padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(32), ScreenUtil().setHeight(16), ScreenUtil().setWidth(32), ScreenUtil().setHeight(16)),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)
                            ),
                            onPressed: () async {

                              print(widget.clienteD.data);

                              await FirebaseFirestore.instance
                                  .collection('clientes imediato')
                                  .doc(widget.clienteD.id)
                                  .delete().whenComplete(() => Navigator.pop(context));
                              print(widget.clienteD.id);
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )


    );
  }
}

/*
child: ListTile(
title: Text(
widget.clienteD.data["nome"]
),
subtitle: Text(
widget.clienteD.data["email"]
),
),*/
