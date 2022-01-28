import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';
class Novidades extends StatefulWidget {

  @override
  _NovidadesState createState() => _NovidadesState();
}

class _NovidadesState extends State<Novidades> {
  @override
  Widget build(BuildContext context) {
    Widget _buildBodyBack() => Container(
      height: ScreenUtil().setHeight(1334),
      width: ScreenUtil().setWidth(750),
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 13, 13, 115),
            Color.fromARGB(255,0, 71, 171)

          ], begin: Alignment.topLeft, end: Alignment.bottomRight)),
    );
    return Container(color: Colors.white,
        child: Stack(
          children: [
            _buildBodyBack(),
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  leading: Container(
                    color: Colors.transparent,
                  ),
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding:
                    EdgeInsets.only(bottom: ScreenUtil().setHeight(15.0)),
                    title: Text(
                      "Provisionamentos Recentes",
                      style: TextStyle(fontSize: ScreenUtil().setSp(50)),
                    ),
                    centerTitle: true,
                  ),
                ),
                FutureBuilder<QuerySnapshot>(
                  future: FirebaseFirestore.instance
                      .collection("recentes")
                      .orderBy("pos")
                      .get(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return SliverToBoxAdapter(
                        child: Container(
                          height: ScreenUtil().setHeight(1000),
                          width: ScreenUtil().setWidth(750),
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      );
                    } else
                      return SliverStaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1.0,
                        crossAxisSpacing: 1.0,
                        staggeredTiles: snapshot.data.docs.map((doc) {
                          return StaggeredTile.count(
                              doc.data()["x"], doc.data()["y"]);
                        }).toList(),
                        children: snapshot.data.docs.map((doc) {
                          return Container(
                            padding: EdgeInsets.only(
                                left: ScreenUtil().setWidth(22.0),
                                right: ScreenUtil().setWidth(22.0),
                                top: ScreenUtil().setHeight(15.0),
                                bottom: ScreenUtil().setHeight(15.0)),
                            child: InkWell(
                              onTap: (){
                                print(doc.data());

                              },
                              child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(ScreenUtil().setSp(20))),
                                  child: Container(
                                    color: Colors.white,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        FadeInImage.memoryNetwork(
                                          placeholder: kTransparentImage,
                                          image: doc.data()["image"],
                                          width: double.infinity,
                                          height: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          alignment: Alignment.bottomCenter,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setSp(20))),
                                            child: Container(
                                              alignment: Alignment.center,
                                              color: Color.fromARGB(255, 13, 13, 115),
                                              height: ScreenUtil().setHeight(80),
                                              width: ScreenUtil().setWidth(310),
                                              child: Text(
                                                doc.data()["Alias"].toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                            ),
                          );
                        }).toList(),
                      );
                  },
                )
              ],
            )
          ],
        ));
  }
}
