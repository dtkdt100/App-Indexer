import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'appScreen.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MaterialApp(
    home: AppScreen(0),
  ));
}

//class HomePage extends StatefulWidget {
//  @override
//  _HomePageState createState() => _HomePageState();
//}
//
//class _HomePageState extends State<HomePage> {
//  List appsNames = ['One to 50'];
//  List appsPackages = ['com.dolev.oneto50'];
//  List appsPhotos = [];
//  String yourApp = '';
//  String keySearch = '';
//  String packageID = '';
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.grey[300],
//      appBar: AppBar(
//        title: Text('Your apps'),
//      ),
//      body: ListView(
//        physics: ScrollPhysics(),
//        children: List.generate(appsNames.length, (index){
//          return SizedBox(
//            height: 150,
//            child: Card(
//              margin: EdgeInsets.only(top: 15, right:  10, left: 10, bottom: 5),
//              child: InkWell(
//                onTap: (){
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => AppScreen(0)),
//                  );
//                },
//                child: Row(
//                  children: <Widget>[
//                    Container(
//                      margin: EdgeInsets.only(left: 15),
//                      child: InkWell(
//                        onTap: (){},
//                        child: Container(
//                            decoration: BoxDecoration(
//                              border: Border.all(
//                                  color: Colors.grey[400]
//                              ),
//                            ),
//
//                            padding: EdgeInsets.only(left: 10, right: 10, top:  15, bottom: 15),
//                            child: Icon(Icons.add_a_photo, size: 55, color: Colors.grey[600],)
//                        ),
//                      ),
//                    ),
//                    SizedBox(width: 10,),
//                    Column(
//                      mainAxisAlignment: MainAxisAlignment.center,
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: <Widget>[
//                        Text('${appsNames[index]}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
//                        Text('${appsPackages[index]}', style: TextStyle(fontSize: 15, color: Colors.grey[600]),),
//                      ],
//                    ),
//                    Spacer(flex: 1,),
//                    Column(
//                      children: <Widget>[
//                        IconButton(
//                          icon: Icon(Icons.delete, color: Colors.grey[800],),
//                          onPressed: (){
//                            setState(() {
//                              appsNames.removeAt(index);
//                              appsPackages.removeAt(index);
//                            });
//                          },
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ),
//          );
//        })
//      ),
//
//      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//      floatingActionButton: FloatingActionButton(
//        onPressed: (){
//          setState(() {
//            yourApp = '';
//            packageID = '';
//          });
//          _showMyDialog();
//        },
//        child: Icon(Icons.add),
//      ),
//    );
//  }
//  Future<void> _showMyDialog() async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: false, // user must tap button!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          title: Text('Create an app'),
//          content: Column(
//            children: <Widget>[
//              TextField(
//                decoration: InputDecoration(
//                    hintText: "your app",
//                    hintStyle: TextStyle(fontWeight: FontWeight.w300)
//                ),
//                onChanged: (text){
//                  setState(() {
//                    yourApp = text;
//                  });
//                },
//              ),
//              TextField(
//                decoration: InputDecoration(
//                    hintText: "package ID",
//                    hintStyle: TextStyle(fontWeight: FontWeight.w300)
//                ),
//                onChanged: (text){
//                  setState(() {
//                    packageID = text;
//                  });
//                },
//              ),
//            ],
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('Approve'),
//              onPressed: () {
//                setState(() {
//                  if (!(yourApp == '' || packageID == '')) {
//                    appsNames.add(yourApp);
//                    appsPackages.add(packageID);
//                  }
//                });
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
//}