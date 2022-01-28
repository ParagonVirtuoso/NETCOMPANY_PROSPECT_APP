
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:netcompany_prospeccoes/ot/globals.dart';
void main() => runApp(new FMyApp());




class FMyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<FMyApp> {
  User fUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //my code
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  //end my code

  void initState() {
    super.initState();

    /*
    FirebaseAuth.instance.currentUser().then((fUser) {
      setState(() {
        this.fUser = fUser;
        if (_googleSignIn.currentUser != null) {
          //pushReplacement(context, HomePage());
          print('nao tem que logar');
        } else {
          print('tem que logar');
        }
      });
    }); */
    print("oi o usuario é $currentUser");
    FirebaseAuth.instance.authStateChanges().listen((fUser){

      currentUser = fUser;
      print(currentUser);

    });

  }




  Future<User> _gSignIn(BuildContext context) async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.
      credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      User user = (await _fAuth.signInWithCredential(credential)) as User;
      print("user name: ${user.displayName}");
      return user;
    } catch (error) {
      return error;
    }
  }


  Future<String> Logar(String email, String password) async {
    print(_googleSignIn.currentUser);
  }

  Future<Null> _signOut(BuildContext context) async {
    await _googleSignIn.signOut();
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign out button clicked'),
    ));
    print('Signed out');
  }


  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Vida'),
        ),
        body: new Builder(
          builder: (BuildContext context) {
            return new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new MaterialButton(
                    //padding: new EdgeInsets.all(16.0),
                    minWidth: 150.0,
                    onPressed: (){},
                    child: new Text('Sign in with Facebook'),
                    color: Colors.lightBlueAccent,
                  ),
                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                  ),
                  new MaterialButton(
                    //padding: new EdgeInsets.all(16.0),
                    minWidth: 150.0,
                    onPressed: () => _gSignIn(context)
                        .then((User user) => print(user))
                        .catchError((e) => print(e)),
                    child: new Text('Sign in with Google'),
                    color: Colors.cyanAccent,
                  ),

                  new Padding(
                    padding: const EdgeInsets.all(5.0),
                  ),
                  new MaterialButton(
                    minWidth: 150.0,
                    onPressed: () => _signOut(context),
                    child: new Text('Sign Out'),
                    color: Colors.lightBlueAccent,
                  ),
                  new MaterialButton(
                    minWidth: 150.0,
                    onPressed: () => Logar("emailexemplo@exemplo.com", "12345678")
                        .catchError((e) => print(e)),
                    child: new Text('Logar Verificado'),
                    color: Colors.deepOrange,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}



