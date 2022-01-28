import 'dart:async';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'globals.dart';


void main() => runApp(new ListagemWidget());

class ListagemWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
//    Firestore.instance.collection('mountains').document()
//        .setData({ 'title': 'Mount Baker', 'type': 'volcano' });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Home"),
      ),
      body: new NetCompanyClientList(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance.collection('mountains').doc().set(
            {
              'title': 'Mount Vesuvius',
              'type': 'volcano',
            },
          );
        },
      ),
    );
  }
}

class NetCompanyClientList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
      stream: dataBank.snapshots(),
      // stream: Firestore.instance.collection('mountains').snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView(
          children: snapshot.data.docs.map((document) {
            return new ListTile(
              title: new Text(document['nome']),
              subtitle: new Text(document['sexo']),
            );
          }).toList(),
        );
      },
    );
  }
}