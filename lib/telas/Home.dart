import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:netcompany_prospeccoes/model/user_model.dart';
import 'package:netcompany_prospeccoes/telas/About.dart';
import 'package:netcompany_prospeccoes/telas/Novidades.dart';
import 'package:netcompany_prospeccoes/telas/Tab_Onu.dart';
import 'package:netcompany_prospeccoes/telas/Prospect.dart';
import 'package:netcompany_prospeccoes/widgets/custom_drawer.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final _pageController = PageController();
  TabController _tabController;
  User _usuarioLogado;

  String _usuarioUid;
  Color _corAviso = Colors.orange;
  Color _shadowAviso = Colors.grey;
  IconData _iconeAviso = Icons.av_timer;

  Future _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    _usuarioLogado = await auth.currentUser;

    setState(() {
      _usuarioUid = _usuarioLogado.uid;
      if (_usuarioLogado.email != null) {
        OneSignal.shared.init("88854af2-dc85-4a03-a1c1-59e4e5b4b803",
            iOSSettings: {
              OSiOSSettings.autoPrompt: false,
              OSiOSSettings.inAppLaunchUrl: false
            });

        OneSignal.shared.promptUserForPushNotificationPermission();
        OneSignal.shared.setSubscription(true);
        OneSignal.shared
            .setEmail(email: UserModel.of(context).firebaseUser.email);
        OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.none);
      }
    });
  }

  @override
  void initState() {
    _recuperarDadosUsuario();

    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334));
    ScreenUtil().setSp(28, allowFontScalingSelf: true);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));

    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Scaffold(
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(ScreenUtil().setSp(35)),
                bottomRight: Radius.circular(ScreenUtil().setSp(35))),
            child: CustomDrawer(_pageController),
          ),
          appBar: AppBar(
            elevation: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: ScreenUtil().setWidth(315)),
                  width: ScreenUtil().setWidth(50),
                  child: Image.asset("assets/LOGO_ICONE.png",
                      color: Colors.white,
                      width: ScreenUtil().setWidth(100),
                      height: ScreenUtil().setHeight(50)),
                ),
              ],
            ),
          ),
          body: Novidades(),
        ),
        Scaffold(
            appBar: AppBar(
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(85)),
                      width: ScreenUtil().setWidth(50),
                      child: Image.asset("assets/LOGO_ICONE.png",
                          color: Colors.white,
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setHeight(50)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(10),
                          bottom: ScreenUtil().setHeight(15)),
                      height: ScreenUtil().setHeight(75),
                      width: ScreenUtil().setWidth(230),
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          if (model.isLoggedIn() != null) {
                            var sections = model.userData['status'].toString();

                            if (sections == 'Tudo Certo') {
                              _corAviso = Colors.green;
                              _shadowAviso = Colors.grey;
                              _iconeAviso = Icons.done;
                            }
                            if (sections == 'null') {
                              _corAviso = Colors.transparent;
                              _shadowAviso = Colors.transparent;
                              _iconeAviso = null;
                              sections = "";
                            }
                            if (sections == 'Em Análise') {
                              _corAviso = Colors.orange;
                              _shadowAviso = Colors.grey;
                              _iconeAviso = Icons.av_timer;
                            }
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(20),
                                  bottom: ScreenUtil().setHeight(10)),
                              child: new Container(
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(15.0)),
                                    color: _corAviso,
                                    boxShadow: [
                                      new BoxShadow(
                                        color: _shadowAviso,
                                        blurRadius: 10.0,
                                        spreadRadius: 0.1,
                                      )
                                    ]),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(10),
                                            left: ScreenUtil().setWidth(10)),
                                        child: Icon(_iconeAviso)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: ScreenUtil().setWidth(10)),
                                      child: Text(
                                        sections,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(20)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(10)),
                                  child: Text(
                                    "Carregando...",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(20)),
                                  ),
                                )
                              ],
                            );
                          }
                        },
                      ),
                    )
                  ],
                )),
            drawer: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(ScreenUtil().setSp(35)),
                  bottomRight: Radius.circular(ScreenUtil().setSp(35))),
              child: CustomDrawer(_pageController),
            ),
            body: TabOnu()),
        Scaffold(
            appBar: AppBar(
                elevation: 0,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: ScreenUtil().setWidth(85)),
                      width: ScreenUtil().setWidth(50),
                      child: Image.asset("assets/LOGO_ICONE.png",
                          color: Colors.white,
                          width: ScreenUtil().setWidth(100),
                          height: ScreenUtil().setHeight(50)),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil().setHeight(10),
                          bottom: ScreenUtil().setHeight(15)),
                      height: ScreenUtil().setHeight(75),
                      width: ScreenUtil().setWidth(230),
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          if (model.isLoggedIn() != null) {
                            // get sections from the document
                            //var sections = courseDocument['status'];
                            var sections = model.userData['status'].toString();

                            if (sections == 'Tudo Certo') {
                              _corAviso = Colors.green;
                              _iconeAviso = Icons.done;
                            }
                            if (sections == 'null') {
                              _corAviso = Colors.transparent;
                              _shadowAviso = Colors.transparent;
                              _iconeAviso = null;
                              sections = "";
                            }
                            if (sections == 'Em Análise') {
                              _corAviso = Colors.orange;
                              _iconeAviso = Icons.av_timer;
                            }
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(20),
                                  bottom: ScreenUtil().setHeight(10)),
                              child: new Container(
                                decoration: new BoxDecoration(
                                    borderRadius: new BorderRadius.all(
                                        Radius.circular(15.0)),
                                    color: _corAviso,
                                    boxShadow: [
                                      new BoxShadow(
                                        color: _shadowAviso,
                                        blurRadius: 10.0,
                                        spreadRadius: 0.1,
                                      )
                                    ]),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: ScreenUtil().setWidth(10),
                                            left: ScreenUtil().setWidth(10)),
                                        child: Icon(_iconeAviso)),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          right: ScreenUtil().setWidth(10)),
                                      child: Text(
                                        sections,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(20)),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: ScreenUtil().setWidth(10)),
                                  child: Text(
                                    "Carregando...",
                                    style: TextStyle(
                                        fontSize: ScreenUtil().setSp(20)),
                                  ),
                                )
                              ],
                            );
                          }
                        },
                      ),
                    )
                  ],
                )),
            drawer: ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(ScreenUtil().setSp(35)),
                  bottomRight: Radius.circular(ScreenUtil().setSp(35))),
              child: CustomDrawer(_pageController),
            ),
            body: Prospect()),
        Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil().setWidth(315)),
                    width: ScreenUtil().setWidth(50),
                    child: Image.asset("assets/LOGO_ICONE.png",
                        color: Colors.white,
                        width: ScreenUtil().setWidth(100),
                        height: ScreenUtil().setHeight(50)),
                  ),
                ],
              )),
          drawer: ClipRRect(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(ScreenUtil().setSp(35)),
                bottomRight: Radius.circular(ScreenUtil().setSp(35))),
            child: CustomDrawer(_pageController),
          ),
          body: About(),
        ),
      ],
    );
  }
}
