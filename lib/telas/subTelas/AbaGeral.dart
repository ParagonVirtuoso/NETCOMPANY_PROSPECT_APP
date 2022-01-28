import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:netcompany_prospeccoes/telas/subTelas/AbaListarClientesFidelidade.dart';
import 'package:netcompany_prospeccoes/telas/subTelas/AbaListarClientesImediato.dart';
import 'AbaListarClientes.dart';

void main() => runApp(TabPage());

class TabPage extends StatefulWidget {
  @override
  _TabPageState createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  bool _clienteLiberado = true;



  int selectedIndex = 0;

  PageController controller = PageController();

  List<GButton> tabs = new List();
  List<Color> colors = [
    Colors.purple,
    Colors.pink,
    Colors.amber[600],
    Colors.teal
  ];
  _verif() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('usuarios').doc(usuarioLogado.uid).get();
    if(snapshot.data()["nivel"] == '2'){
      setState(() {
        _clienteLiberado = false;
      });
    }else {
      Scaffold.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Você Não Possui Permissões"),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _verif();
    var padding = EdgeInsets.symmetric(horizontal: 7, vertical: 2);
    double gap = 22;

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.lightBlue,
      iconColor: Colors.black,
      textColor: Colors.lightBlue,
      color: Colors.lightBlue.withOpacity(.2),
      iconSize: ScreenUtil().setSp(35),
      padding: padding,
      icon: Icons.remove_red_eye,
      textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(25),
          color: Colors.lightBlue
      ),
      text: 'Analise',
    ));

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.purple,
      iconColor: Colors.black,
      textColor: Colors.purple,
      color: Colors.purple.withOpacity(.2),
      iconSize: ScreenUtil().setSp(35),
      padding: padding,
      icon: Icons.call,
      textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(25),
        color: Colors.purple
      ),
      text: 'Realizar Contato Imediato',
    ));

    tabs.add(GButton(
      gap: gap,
      iconActiveColor: Colors.pink,
      iconColor: Colors.black,
      textColor: Colors.pink,
      color: Colors.pink.withOpacity(.2),
      iconSize: ScreenUtil().setSp(35),
      padding: padding,
      icon: Icons.timer,
      textStyle: TextStyle(
          fontSize: ScreenUtil().setSp(25),
        color: Colors.pink
      ),
      text: 'Aguardando o fim da fidelidade',
    ));



  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil().setSp(28, allowFontScalingSelf: true);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Offstage(
      offstage: _clienteLiberado,
      child: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: -8,
                        blurRadius: 60,
                        color: Colors.black.withOpacity(.20),
                        offset: Offset(0, 15))
                  ]),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 5),
                child: GNav(
                    tabs: tabs,
                    selectedIndex: selectedIndex,
                    onTabChange: (index) {
                      print(index);
                      setState(() {
                        selectedIndex = index;
                      });
                      controller.jumpToPage(index);
                    }),
              ),
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: PageView.builder(
          onPageChanged: (page) {
            setState(() {
              selectedIndex = page;
            });
          },
          controller: controller,
          itemBuilder: (context, position) {
            if(position == 0){
              return Container(
                child: AbaListarClientes(),
              );
            }if(position == 1){
              return Container(
                child: AbaListarClientesImediato(),
              );
            } if(position == 2){
              return Container(
                child: AbaListarClientesFidelidade(),
              );
            }  else return Center(
              child: Text(
                  "Erro ao Carregar Listas"
              ),
            );
          },
          itemCount: tabs.length, // Can be null
        ),
      ),
    );
  }
}