import 'dart:ui';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../FirstPage.dart';
import '../appScreen.dart';
import '../globalVar.dart';
import 'package:http/http.dart' as http;

Future<void> myDialog(context, content, {actions, then, from}){
  return showGeneralDialog<void>(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 400, 0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8)),
                //content: Text('Error occured, please check your internet connection'),
                content: content,
                actions: actions,
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 250),
      barrierDismissible: true,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, animation1, animation2) {}
  ).then((value) {
    if (then != null) {
      then(from);
    }
  });
}

Future<void> confirmDeleteDialog(context, {from, index}) async {
  Widget content = Padding(
    padding: EdgeInsets.only(left: 10, right: 10),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Confirm delete', style: TextStyle(fontSize: 27, fontWeight: FontWeight.w500),),
        SizedBox(height: 10,),
        from == 'hi' ? Text('Are you sure you want do delete your app?') : Text('This is your last app.\nAre you sure you want do delete it?'
            , style: TextStyle(fontSize: 17)),
      ],
    ),
  );

  var hi = AwesomeDialog(
      headerAnimationLoop: false,
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.SCALE,
      body: content,
      btnOkText: 'Yes',
      btnCancelText: 'No',
      btnOkOnPress: () async {
        if (from == "hi"){
          Navigator.pop(context);
          if (index - 1 == widgetIndex) {
            if (appsNames.value.length != 1) {
              isEqual = true;
              visibilities[index - 1] = false;
            }
            else {
              confirmDeleteDialog(context);
            }
          }
          else {
            isEqual = false;
            visibilities[index - 1] = false;
          }
        }
        else {
          await deleteMemory();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => FirstPage()));
        }
      },
      btnCancelOnPress: (){}
  );
  await hi.show();
}

deleteMemory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  appsNames.value = [];
  appsPackages.value = [];
  keyWords = [];
  dateTimes = [];
  data = [];
  check = true;
  keySearch = '';
  yourApp = '';
  packageID = '';
  visibilities = [];
  widgetIndex = null;
  firstOpen = true;
  isEqual = false;
  await prefs.clear();
}

Future<void> addAppDialog(context, appName, appPackage, index, {bool fromDialog}) async {
  yourApp = appName;
  packageID = appPackage;
  Widget content = Padding(
    padding: EdgeInsets.only(left: 15, right: 15),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Create an app', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Color(0xFF8185E2)),),
        SizedBox(height: 15,),
        Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: TextEditingController()..text = '$appName',
                autofocus: true,
                cursorColor: Color(0xFF8185E2),
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Color(0xFF8185E2),
                      width: 2.5
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Color(0xFF8185E2),
                      width: 2.5,
                    ),
                  ),
                  labelText: "Your app",
                  labelStyle: TextStyle(fontWeight: FontWeight.w300, color:  Color(0xFF8185E2)),
                  hintText: "Any name you desires",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[400]),
                  //fillColor: Colors.green
                ),
                onChanged: (text){
                 // setState(() {
                    yourApp = text;
                 // });
                },
                //keyboardType: TextInputType.visiblePassword,
              ),
              SizedBox(height: 15,),
              TextFormField(
                controller: TextEditingController()..text = '$appPackage',
                cursorColor: Color(0xFF8185E2),
                decoration: InputDecoration(
                  labelText: "package ID",
                  labelStyle: TextStyle(fontWeight: FontWeight.w300, color: Color(0xFF8185E2)),
                  hintText: "com.example.yourApp",
                  hintStyle: TextStyle(fontWeight: FontWeight.w300, color: Colors.grey[400]),
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                        color: Color(0xFF8185E2),
                        width: 2.5
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: BorderSide(
                      color: Color(0xFF8185E2),
                      width: 2.5,
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                onChanged: (text){
                 // setState(() {
                    packageID = text;
                 // });
                },
                //keyboardType: TextInputType.visiblePassword,
              ),
            ],
          ),
        ),
      ],
    ),
  );
  
  AwesomeDialog(
    headerAnimationLoop: false,
    context: context,
    dialogType: DialogType.INFO,
    animType: AnimType.SCALE,
    body: content,
    btnOkText: 'Add',
    btnCancelOnPress: () {},
    btnOkOnPress: () async {
      if (!(yourApp == '' || packageID == '')) {
        var res = await http.get("https://play.google.com/store/apps/details?id=$packageID");
        if (res.statusCode == 404){
          AwesomeDialog(
              headerAnimationLoop: false,
              context: context,
              dialogType: DialogType.ERROR,
              title: 'Package id is wrong',
              desc: 'Try checking your package id.\nIt is important to use upper\nand lower cases',
              btnOkOnPress: (){}
          )..show().then((value) {
            addAppDialog(context, yourApp, packageID, index, fromDialog: appName != '' ? null : true);
          });
        }
        else {
          if (appName != '' && fromDialog == null){
            print('hi');
            appsNames.value[index] = yourApp;
            appsPackages.value[index] = packageID;
            //Navigator.of(context).pop();
            appsNames.notifyListeners();
            appsPackages.notifyListeners();
          }
          else {
            appsNames.value.add(yourApp);
            appsPackages.value.add(packageID);
            appsPackages.notifyListeners();
            visibilities.add(true);
            keyWords.add([]);
            //listForLines.add([]);
            var hi = data;
            data.add([]);
            dateTimes.add([]);
            hi.add([]);
            // Navigator.of(context).pop();
            Navigator.pushReplacement(context,
                PageTransition(
                    type: PageTransitionType.fade,
                    child: AppScreen(index)));
          }
          setInMemory();
        }
      }
    },
  )..show();
  //await myDialog(context, content, actions: actions);
}

setInMemory() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('appsNames', appsNames.value);

  //await prefs.setStringList('appsPackages', appsPackages.value);
  List<String> hi3 = [];
  List<String> hi2 = [];
  List<String> hi1 = [];
  for (int i = 0; i < keyWords.length; i++){
    hi2.add('${keyWords[i]}');
  }
  for (int i = 0; i < dateTimes.length; i++){
    for (int j = 0; j < dateTimes[i].length; j++){
      for (int k = 0; k < dateTimes[i][j].length; k++){
        hi1.add('${dateTimes[i][j][k]}');
      }
    }
  }
  hi3.add('$data');
  await prefs.setStringList('data', hi3);
  await prefs.setStringList('keyWords', hi2);
  await prefs.setStringList('dateTimes', hi1);
  //await prefs.setString('dateTimes', '$dateTimes');
}

Future<void> noConnectionDialog(from, context, then){
  Widget content = Container(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Network Error', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),),
        SizedBox(height: 10,),
        Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: Text('Error occured, please check your internet connection.', textAlign: TextAlign.center, style: TextStyle(
                fontSize: 18
            ),)
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.deepPurple,
          ),
          margin: EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 5),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              borderRadius: BorderRadius.circular(6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text('CANCEL', style: TextStyle(color: Colors.white, fontSize: 18),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
  AwesomeDialog(
    headerAnimationLoop: false,
    context: context,
    dialogType: DialogType.ERROR,
    animType: AnimType.SCALE,
    body: content,
    btnCancel: null,
    btnOk: null
  )..show().then((value) {
    if (then != null) {
      then(from);
    }
  });
  //myDialog(context, content, then: then, from: from);
}

Future<void> addLineDialog(context, approve) async {
  Widget content = Padding(
    padding: EdgeInsets.all(15),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Type a keySearch', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
        SizedBox(height: 10,),
        TextField(
          autofocus: true,
          maxLength: 25,
          decoration: InputDecoration(
            labelText: "keySearch",
            hintStyle: TextStyle(fontWeight: FontWeight.w300),
          ),
          onChanged: (text){
              keySearch = text;
          },
        ),
      ],
    ),
  );
  List<Widget> actions = [
    FlatButton(
      child: Text('Approve'),
      onPressed: (){approve();}
    ),
  ];
  myDialog(context, content, actions: actions);
}