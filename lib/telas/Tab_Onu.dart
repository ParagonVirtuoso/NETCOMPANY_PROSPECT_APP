import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:netcompany_prospeccoes/model/user_model.dart';
import 'package:netcompany_prospeccoes/tiles/onus_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class TabOnu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserModel>(
        builder: (context, child, model){
          if(model.isLoggedIn()){
            if(model.userData['nivel'] == '2' ){
              return FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance.collection("fibra").get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      var dividedTiles = ListTile.divideTiles(
                          tiles: snapshot.data.docs.map((doc) {
                            return OnusTile(doc);
                          }).toList(),
                          color: Colors.grey[500])
                          .toList();
                      return ListView(
                        children: dividedTiles,
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

