import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class AbaListarClientesFidelidade extends StatefulWidget {
  @override
  _AbaListarClientesFidelidadeState createState() => _AbaListarClientesFidelidadeState();
}

class _AbaListarClientesFidelidadeState extends State<AbaListarClientesFidelidade> {
  Future _Data;

  Future getClient() async {
    var firestore = FirebaseFirestore.instance;

    QuerySnapshot querySn =
        await firestore.collection("clientes fidelidade").get();

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
    return Container(
      child: FutureBuilder(
          future: _Data,
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Carregando..."),
              );
            } else {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (_, index) {
                    return ListTile(
                      title: Card(
                        child: ListTile(
                            title: Text(snapshot.data[index].data["nome"]),
                            subtitle:
                                Text(snapshot.data[index].data["telefone"])),
                      ),
                      onTap: () => navigateToDetail(snapshot.data[index]),
                    );
                  });
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
      body: SingleChildScrollView(
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
            ))
          ],
        ),
      ),
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
