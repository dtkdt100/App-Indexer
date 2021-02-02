import 'package:app_index_for_developers/design/allDesigns.dart';
import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../globalVar.dart';
import '../appScreen.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool check2 = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:  MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView(
            physics: ScrollPhysics(),
            children: List.generate(appsNames.value.length + 2, (index) {
              if (index == 0) {
                return Column(
                  children: [
                    Container(
                      height: 20,
                      color: Color(0xff5b84b0),
                    ),
                    DrawerHeader(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      child: Image.asset("assests/1024x500.png", fit: BoxFit.fill,),
                      decoration: BoxDecoration(
                        color: Color(int.parse("0xff17075a")),
                        //color: Colors.blue,
                      ),
                    ),
                  ],
                );
              }
              else if (index > appsNames.value.length) {
                return Column(
                  children: <Widget>[
                    Divider(
                      thickness: 1.4,
                      height: 0,
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          yourApp = '';
                          packageID = '';
                        });
                        addAppDialog(context, '', '', index-1);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 18, bottom: 18),
                        child: Row(
                          children: <Widget>[
                            Spacer(flex: 1,),
                            Icon(Icons.add_box, color: Colors.grey[600],),
                            Spacer(flex: 5,),
                            Text('Add app', style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),),
                            Spacer(flex: 8,)
                          ],
                        ),
                      ),
                    ),
                    //SizedBox(height: 3,),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.only(top: 18, bottom: 18),
                        child: Row(
                          children: <Widget>[
                            Spacer(flex: 1,),
                            Icon(Icons.settings, color: Colors.grey[600],),
                            Spacer(flex: 5,),
                            Text('Settings', style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16),),
                            Spacer(flex: 8,)
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              else {
                return AnimatedOpacity(
                  opacity: visibilities[index - 1] ? 1 : 0,
                  duration: Duration(milliseconds: 250),
                  onEnd: () {
                    setState(() {
                      if (isEqual){
                        if (index - 1 == widgetIndex && check2 || index - 1 == widgetIndex){
                          Navigator.pushReplacement(context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  child: AppScreen(0)));
                          appsNames.value.removeAt(index - 1);
                          appsPackages.value.removeAt(index - 1);
                          appsPackages.notifyListeners();
                          visibilities.removeAt(index - 1);
                          keyWords.removeAt(index - 1);
                          data.removeAt(index - 1);
                          check2 = false;
                          if (index - 1 <= widgetIndex - 1) {
                            widgetIndex = widgetIndex - 1;
                          }
                          setInMemory();
                        } else {
                          check2 = true;
                        }
                      }
                      else {
                        if ((index - 1 < widgetIndex && check || index - 1 > widgetIndex) ) {
                          if(true) {
                            appsNames.value.removeAt(index - 1);
                            appsPackages.value.removeAt(index - 1);
                            appsPackages.notifyListeners();
                            visibilities.removeAt(index - 1);
                            keyWords.removeAt(index - 1);
                            data.removeAt(index - 1);
                            check = false;
                            if (index - 1 <= widgetIndex - 1) {
                              widgetIndex = widgetIndex - 1;
                            }
                            setInMemory();
                          }
                        }
                        else {
                          check = true;
                        }
                      }
                      //_setInMemory();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.only(top: 0, bottom: 1),
                    child: Stack(
                      children: <Widget>[
                        InkWell(
                          onLongPress: () async {
                            setState(() {
                              yourApp = '';
                              packageID = '';
                            });
                            await addAppDialog(context, '${appsNames.value[index - 1]}', '${appsPackages.value[index - 1]}', index - 1);
                            setState(() {
                              print(appsNames.value[index - 1]);
                            });
                          },
                          onTap: () {
                            if (index - 1 == widgetIndex) {
                              Navigator.pop(context);
                            }
                            else {
                              Navigator.pop(context);
                              Navigator.pushReplacement(context,
                                  PageTransition(
                                      type: PageTransitionType.fade,
                                      child: AppScreen(index - 1)));
                            }
                          },
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${appsNames.value[index - 1]}',
                                      style: TextStyle(fontSize: 18,
                                          fontWeight: FontWeight.w500),),
                                    Text('${appsPackages.value[index - 1]}',
                                      style: TextStyle(fontSize: 15,
                                          color: Colors.grey[600]),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete, color: Colors.grey[800],),
                            onPressed: () async {
                              if (!(appsNames.value.length != 1)){await confirmDeleteDialog(context);}
                              else {await confirmDeleteDialog(context, from: 'hi', index: index).then((value){
                                setState(() {});
                              });}
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            })
        ),
      ),
    );
  }


}