import 'dart:async';
import 'dart:io';
import 'package:netcompany_prospeccoes/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netcompany_prospeccoes/model/Usuario.dart';
import 'package:netcompany_prospeccoes/telas/Cadastro.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'Home.dart';

import 'dart:async';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos(model){
    //Recupera dados dos campos
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(email.isNotEmpty && email.contains("@")){

      if(senha.isNotEmpty && senha.length > 6){

        setState(() {
          _mensagemErro = "";
        });
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;
        model.signIn(
            email: _controllerEmail.text,
            pass: _controllerSenha.text,
            onSuccess: _onSuccess,
            onFail: _onFail);
        //_logarUsuario(usuario);

      }else{
        setState(() {
          _mensagemErro = "Preencha a senha";
        });
      }

    }else{
      setState(() {

        _mensagemErro = "Preencha o Email corretamente";

      });
    }

  }

  _logarUsuario(Usuario usuario){

    FirebaseAuth auth  = FirebaseAuth.instance;
    auth.signInWithEmailAndPassword(email: usuario.email, password: usuario.senha).then((firebaseUser){

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Home()));

    }).catchError((error){
      setState(() {
        _mensagemErro = "Erro ao entrar, verifique os campos ou a conexão e tente novamente";

      });


    });


  }

  Future _verificarUsuarioLogado() async{

    FirebaseAuth auth = FirebaseAuth.instance;

    User usuarioLogado = auth.currentUser;
    if(usuarioLogado != null){

      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Home()));

    }

  }

  @override
  void initState() {

    //_verificarUsuarioLogado();

    super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {








    ScreenUtil().setSp(28, allowFontScalingSelf: true);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
              Color.fromARGB(255, 13, 13, 115),
              Color.fromARGB(255, 0, 71, 171)
            ])),
        padding: EdgeInsets.all(ScreenUtil().setSp(16)),
        child: Center(
          child: SingleChildScrollView(
            child: Flex(
              direction: Axis.vertical,
              children: [
                ScopedModelDescendant<UserModel>(builder:
                    (context, child, model){

                      if (model.isLoading) {
                        if(model.isLoggedIn() != null){
                          //_onSuccess();
                        }
                        return Center(
                          heightFactor: ScreenUtil().setWidth(30),
                          child: CircularProgressIndicator(),
                        );
                      }
                      else
                        return
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[


                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(130),
                                  top: ScreenUtil().setHeight(20),
                                  left: ScreenUtil().setWidth(30),
                                  right: ScreenUtil().setWidth(30),
                                ),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(20),
                                      ScreenUtil().setHeight(30),
                                      ScreenUtil().setWidth(20),
                                      ScreenUtil().setHeight(30)),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey,
                                          blurRadius: 10.0,
                                          spreadRadius: 0.1,
                                        )
                                      ]),
                                  child: Image.asset("assets/LOGO_EXT.png",
                                      semanticLabel: "Logotipo da Empresa",
                                      width: ScreenUtil().setWidth(500),
                                      height: ScreenUtil().setHeight(150)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(8),
                                  top: ScreenUtil().setHeight(8),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10),
                                ),
                                child: TextFormField(
                                  controller: _controllerEmail,
                                  autofocus: false,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autocorrect: false,
                                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          ScreenUtil().setWidth(30),
                                          ScreenUtil().setHeight(15),
                                          ScreenUtil().setWidth(30),
                                          ScreenUtil().setHeight(15)),
                                      hintText: "E-mail",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32))),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: ScreenUtil().setHeight(8),
                                  top: ScreenUtil().setHeight(30),
                                  left: ScreenUtil().setWidth(10),
                                  right: ScreenUtil().setWidth(10),
                                ),
                                child: TextField(
                                  obscureText: true,
                                  controller: _controllerSenha,
                                  autofocus: false,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.fromLTRB(
                                          ScreenUtil().setWidth(30),
                                          ScreenUtil().setHeight(15),
                                          ScreenUtil().setWidth(30),
                                          ScreenUtil().setHeight(15)),
                                      hintText: "Senha",
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(32))),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(25),
                                    bottom: ScreenUtil().setHeight(40)),
                                child: Container(
                                  width: ScreenUtil().setWidth(300),
                                  height: ScreenUtil().setHeight(80),
                                  child: RaisedButton(
                                    child: Text(
                                      "Entrar",
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
                                      _validarCampos(model);


                                    },
                                  ),
                                ),
                              ),
                              Center(
                                child: GestureDetector(
                                  child: Text(
                                    "Não tem conta? cadastre-se!",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(28)),
                                  ),
                                  onTap: () async {
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context)=> Cadastro()));
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                                child: Text(
                                  _mensagemErro,
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: ScreenUtil().setSp(25)
                                  ),
                                ),
                              )
                            ],
                          );

                }
                )
              ],
            )
          ),
        ),
      ),
    );

  }

  void _onFail() {

    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao entrar, verifique o email ou senha!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );

  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text("Login realizado com sucesso!"),
          backgroundColor: Theme.of(context).primaryColor,
          duration: Duration(seconds: 2),
        )
    );
    Future.delayed(Duration(seconds: 1)).then((_){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => Home()));
    });
  }


}



