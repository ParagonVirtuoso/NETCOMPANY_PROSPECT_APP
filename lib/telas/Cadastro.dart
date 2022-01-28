import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netcompany_prospeccoes/model/Usuario.dart';
import 'package:netcompany_prospeccoes/telas/Login.dart';

import 'Home.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  //Controlador
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";
  _validarCampos(){
    //Recupera dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if(nome.isNotEmpty){
      if(email.isNotEmpty && email.contains("@")){

        if(senha.isNotEmpty && senha.length > 6){

          setState(() {
            _mensagemErro = "";
          });
          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;
          usuario.status = "Em Análise";
          usuario.nivel = "1";
          _cadastrarUsuario(usuario);

        }else{
          setState(() {
            _mensagemErro = "Preencha a senha com no minimo 6 digitos";
          });
        }

      }else{
        setState(() {
          _mensagemErro = "Preencha o Email corretamente";
        });
      }

    }else{
      setState(() {
        _mensagemErro = "Preencha o Nome";
      });

    }

  }
  _cadastrarUsuario(Usuario usuario){

    FirebaseAuth auth  = FirebaseAuth.instance;
    
    auth.createUserWithEmailAndPassword(email: usuario.email, password: usuario.senha).then((firebaseUser){
      //Salvar dados do usuario
      FirebaseFirestore db = FirebaseFirestore.instance;
      db.collection("usuarios")
      .doc(firebaseUser.user.uid).set(usuario.toMap());
     Navigator.pushReplacement(context,
     MaterialPageRoute(builder: (context) => Home()));
    }).catchError((error){
      setState(() {
        print(error.toString());
        _mensagemErro = "Erro ao cadastrar usuário, verifique os campos ou a conexão e tente novamente";
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    ScreenUtil().setSp(28, allowFontScalingSelf: true);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: (){
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=> Login()));
          },
        ),
        title: Text(
          "Cadastro"
        ),
      ),
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
            child: Column(
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
                    child: Image.asset("assets/LOGO_ICONE.png",
                        width: ScreenUtil().setWidth(200),
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
                  child: TextField(
                    controller: _controllerNome,
                    autofocus: false,
                    keyboardType: TextInputType.text,
                    style: TextStyle(fontSize: ScreenUtil().setSp(30)),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15),
                            ScreenUtil().setWidth(30),
                            ScreenUtil().setHeight(15)),
                        hintText: "Nome",
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
                    controller: _controllerEmail,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
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
                    controller: _controllerSenha,
                    obscureText: true,
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
                        "Cadastrar",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(25)),
                      ),
                      color: Color.fromARGB(255, 0, 71, 171),
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setWidth(32), ScreenUtil().setHeight(16), ScreenUtil().setWidth(32), ScreenUtil().setHeight(16)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                      ),
                      onPressed: () {
                        _validarCampos();
                      },
                    ),
                  ),
                ),
                Text(
                  _mensagemErro,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: ScreenUtil().setSp(25)
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
