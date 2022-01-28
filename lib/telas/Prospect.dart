import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netcompany_prospeccoes/model/user_model.dart';
import 'package:netcompany_prospeccoes/telas/subTelas/AbaCadastrarClientes.dart';
import 'package:netcompany_prospeccoes/telas/subTelas/AbaGeral.dart';
import 'package:netcompany_prospeccoes/telas/subTelas/AbaListarClientes.dart';
import 'package:netcompany_prospeccoes/widgets/custom_drawer.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class Prospect extends StatefulWidget {
  @override
  _ProspectState createState() => _ProspectState();
}

class _ProspectState extends State<Prospect> with SingleTickerProviderStateMixin {
  TabController _tabController;
  User _usuarioLogado;

  String _usuarioUid;
  Color _corAviso = Colors.orange;
  IconData _iconeAviso = Icons.av_timer;




  @override
  void initState() {
    super.initState();


    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    ScreenUtil().setSp(28, allowFontScalingSelf: true);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return ScopedModelDescendant<UserModel>(
        builder: (context, child, model){


          if(model.isLoggedIn()){
            if(model.userData['nivel'] != 1 ){
              return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("fibra").get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Scaffold(
                        appBar: PreferredSize(
                          preferredSize: Size.fromHeight(50),
                          child: AppBar(
                            bottom: TabBar(
                              indicatorWeight: 4, //mudar
                              labelStyle: TextStyle(
                                  fontSize: ScreenUtil().setSp(30),
                                  fontWeight: FontWeight.bold),
                              controller: _tabController,
                              indicatorColor: Colors.white,
                              tabs: <Widget>[
                                Tab(
                                  text: "Cadastrar Clientes",
                                ),
                                Tab(
                                  text: "Listar Clientes",
                                )
                              ],
                            ),
                          ),
                        ),
                        body: TabBarView(
                          controller: _tabController,
                          children: <Widget>[AbaCadastrarClientes(), TabPage()],
                        ),
                      );
                    }
                  });
            }
            else return Center(
                child: Center(
                  child: Text(
                    "Sem nivel de acesso",
                    style: TextStyle(fontSize: ScreenUtil().setSp(80)),
                  ),
                )
            );
          }else{
            return Center(
              child: Text(
                "Não Logado",
                style: TextStyle(fontSize: ScreenUtil().setSp(80)),
              ),
            );
          }



        });

  }
}


