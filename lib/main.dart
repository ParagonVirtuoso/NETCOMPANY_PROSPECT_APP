import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:netcompany_prospeccoes/telas/Home.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/user_model.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return ScopedModel<UserModel>(
        model: UserModel(),
        child:
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
          return MaterialApp(
            title: 'Netcompany',
            theme: ThemeData(
              accentColor: Color.fromARGB(255, 0, 71, 171),
              primaryColor: Color.fromARGB(255, 13, 13, 115),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            debugShowCheckedModeBanner: false,
            home: Home(),
          );
        }));
  }
}
