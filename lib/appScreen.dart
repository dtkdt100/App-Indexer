import 'dart:async';
import 'package:flutter/services.dart';

import 'Charts2.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'actions/drawer.dart';
import 'design/allDesigns.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FirstPage.dart';
import 'package:flutter/widgets.dart';
import 'globalVar.dart';
import 'functions/allFunctions.dart';
import 'dart:math' as math;

class AppScreen extends StatefulWidget {
  int index;
  String yourApp;
  String packageId;
  AppScreen(this.index, {this.yourApp, this.packageId});
  @override
  AppScreenState createState() => AppScreenState();
}

List<Color> shuffle(List<Color> items) {
  var random = new Random();
  for (var i = items.length - 1; i > 0; i--) {
    var n = random.nextInt(i + 1);
    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }
  return items;
}

class AppScreenState extends State<AppScreen> {
  List<Color> colors;
  List <bool> loading = [];
  bool checkIfLoading = true;
  bool internetConnection = false;
  Country _selected = Country.findByIsoCode("IL");
  List<dynamic> numberOfTheApp = [];
  int duration = 0;
  Locale myLocale;
  List<bool> visibilitiesKeySearch;
  bool check12 = true;
  bool isMemoryLoad = false;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    appsPackages.addListener(() async  {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('appsPackages', appsPackages.value);
    });
    setState(() {
      widgetIndex = widget.index;
    });
    if (widget.yourApp != null){
      appsNames.value = [];
      appsNames.value.add(widget.yourApp);
      appsPackages.value.add(widget.packageId);
      visibilities.add(true);
      keyWords.add([]);
      var hi = data;
      dateTimes = [[[]]];
      data.add([]);
      hi.add([]);
      setInMemory();
    }
    if (firstOpen) {
      _getFromMemory();
      firstOpen = false;
    } else {
      isMemoryLoad = true;
      loading = List.generate(keyWords[widgetIndex].length, (index) => true);
      visibilitiesKeySearch = List.generate(keyWords[widgetIndex].length + 1, (index) => true);
      colors = List.generate(keyWords[widgetIndex].length, (index) => Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
      setState(() {

      });
      jo();
    }
    super.initState();
  }

  void jo() async {
    for (int i = 0; i < keyWords[widgetIndex].length; i++) {
      if (_selected == null){
        await _makeGetRequest(
            _selected.isoCode, keyWords[widgetIndex][i], i, from: 'hi');
      }
      else {
        await _makeGetRequest(
            _selected.isoCode, keyWords[widgetIndex][i], i, from: 'hi');
      }
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    if (_selected == null) {
      setState(() {
        _selected = Country.findByIsoCode(Localizations.localeOf(context).countryCode);
        myLocale = Localizations.localeOf(context);
      });
    }
    if (!isMemoryLoad){
      return Scaffold(
        body: Center(
          child: SpinKitRing(
            size: 150,
            color: Colors.blue,
          ),
        ),
      );
    }
    else if (appsNames.value.length == 0){
      return FirstPage();
    }
    else {
        return Scaffold(
          drawer: MyDrawer(),
          appBar: AppBar(
            backgroundColor: Color(0xff5b84b0),
            title: ValueListenableBuilder(
              builder: (BuildContext context, List<String> value, Widget child) {
                return Text('${value[widgetIndex]}');
              },
              valueListenable: appsNames,
              child: Text("hi"),
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              addLineDialog(context, () async {
                setState(() {
                  if (!(keySearch == '')) {
                    colors.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
                    keyWords[widgetIndex].add(keySearch);
                    data[widgetIndex].add([]);
                    dateTimes[widgetIndex].add([]);
                    setInMemory();
                    loading.add(true);
                    visibilitiesKeySearch.add(true);
                  }
                });
                Navigator.of(context).pop();
                bool no = await _makeGetRequest(_selected.isoCode, keySearch,  keyWords[widgetIndex].length-1, from: 'hi');
              });
            },
          ),
          bottomNavigationBar: BottomAppBar(
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  height: 50,
                  child: CountryPicker(
                    dense: false,
                    showDialingCode: false,
                    showName: true,
                    showCurrency: false,
                    showCurrencyISO: false,
                    onChanged: (Country country) async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('country', country.isoCode);
                      setState(() {
                        _selected = country;
                        if (keyWords[widgetIndex].length != 0){
                          _handleRefresh();
                        }
                      });
                    },
                    selectedCountry: _selected,
                  ),
                ),
              ],
            ),
            color: Color(0xff5b84b0),
          ),
          body: body(),
        );
      }
  }

  Widget body(){
    if (keyWords[widgetIndex].length == 0){
      return GestureDetector(
        onTap: (){
          addLineDialog(context, () async {
            setState(() {
              if (!(keySearch == '')) {
                colors.add(Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
                keyWords[widgetIndex].add(keySearch);
                data[widgetIndex].add([]);
                dateTimes[widgetIndex].add([]);
                setInMemory();
                loading.add(true);
                visibilitiesKeySearch.add(true);
              }
            });
            Navigator.of(context).pop();
            bool no = await _makeGetRequest(_selected.isoCode, keySearch,  keyWords[widgetIndex].length-1, from: 'hi');
          });
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(child: Icon(Icons.add, color: Colors.blue, size: 100,)),
            Text('Pls add key search to your app', style: TextStyle(
              color: Colors.grey[500]
            ),),
          ],
        ),
      );
    }
    return LiquidPullToRefresh(
      color: Color(0xff5b84b0),
      animSpeedFactor: 1.2,
      showChildOpacityTransition: false,
      onRefresh: _handleRefresh,
      springAnimationDurationInMilliseconds: 350,
      child: ListView(
        children: <Widget>[
          Column(
              children: List.generate(keyWords[widgetIndex].length + 1, (index) {
                if (index == keyWords[widgetIndex].length) {
                  return SizedBox(height: 32,);
                }
                return AnimatedOpacity(
                  opacity: visibilitiesKeySearch[index] ? 1 : 0,
                  duration: Duration(milliseconds: 250),
                  onEnd: (){
                    setState((){
                      if (check12 && index != keyWords[widgetIndex].length){
                        duration = 0;
                        keyWords[widgetIndex].removeAt(index);
                        visibilitiesKeySearch.removeAt(index);
                        data[widgetIndex].removeAt(index);
                        dateTimes[widgetIndex].removeAt(index);
                        check12 = false;
                        loading.removeAt(index);
                        numberOfTheApp.removeAt(index);
                        setInMemory();
                      }
                      else {
                        check12 = true;
                      }
                    });
                  },
                  child: Container(
                    height: 150,
                    child: Card(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 2,
                      shadowColor: Colors.grey[300].withOpacity(0.7),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: InkWell(
                                focusColor: Colors.black,
                                canRequestFocus: true,
                                onTap: () {
                                  var today = DateTime.now();
                                  //dateTimes[widgetIndex][index][1] = DateTime(today.year, today.month, today.day+1);
                                  //print(dateTimes[widgetIndex][index]);
                                 // print(data[widgetIndex]);
                                  Navigator.push(context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          child: SimpleLineChart(keyWords[widgetIndex], data[widgetIndex], dateTimes[widgetIndex])));
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Material(color: Colors.transparent,)
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Stack(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Spacer(flex: 3,),
                                      Text(
                                        '${keyWords[widgetIndex][index]}',
                                        style: TextStyle(fontSize: 25,
                                            fontWeight: FontWeight.w500),),
                                      Spacer(flex: 2,),
                                      IconButton(
                                          icon: Icon(Icons.clear),
                                          onPressed: () {
                                            setState(() {
                                              visibilitiesKeySearch[index] = false;
                                            });

                                          }
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 50, right: 50),
                                child: Center(
                                  child: checkIfLoadingFun(loading, numberOfTheApp, index, duration, colors),
                                ),
                              ),
                              Center(
                                child: decideWidgetIfGrow(data[widgetIndex][index]),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              })
          ),
        ],
      ),
    );
  }

  void then(from) async {
    if (from != 'refresh') {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.none) {
        noConnectionDialog(from, context, then);
      }
      else {
        for (int i = 0; i < keyWords[widgetIndex].length; i++) {
          if (_selected == null) {
            await _makeGetRequest(
                myLocale.countryCode, keyWords[widgetIndex][i], i,
                from: 'hi');
          }
          else {
            await _makeGetRequest(
                _selected.isoCode, keyWords[widgetIndex][i], i, from: 'hi');
          }
        }
        setState(() {});
      }
    }
  }

  Future<void> _handleRefresh() async {
    final Completer<void> completer = Completer<void>();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none || loading.contains(true)) {
       completer.complete();
    }
    else {
      for (int i = 0; i < keyWords[widgetIndex].length; i++) {
        if (_selected == null) {
          bool yo = await _makeGetRequest(
              myLocale.countryCode, keyWords[widgetIndex][i], i);
        }
        else {
          bool yo = await _makeGetRequest(
              _selected.isoCode, keyWords[widgetIndex][i], i);
        }
      }
      setInMemory();
      Timer(const Duration(microseconds: 1), () {
        completer.complete();
      });
    }

    return completer.future.then<void>((_) {
      if (connectivityResult != ConnectivityResult.none){
      setState(() {
          duration = 500;
        });
        Timer(Duration(milliseconds: 500), (){
          setState(() {
            duration = 0;
          });
        });
      }
      else {
        noConnectionDialog('refresh', context, then);
      }
    });
  }

  _getFromMemory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isMemoryLoad = true;
    setState(() {
      appsNames.value = prefs.getStringList('appsNames');
      if (appsNames.value == null){
        appsNames.value = [];
        appsPackages.value = [];
        visibilities = [];
        keyWords = [[]];
      }
      else {
        List<String> hi = prefs.getStringList('keyWords');
        if (hi!=null) {
          for (int i = 0; i < hi.length; i++) {
            if (hi[i].length == 2) {
              keyWords.add([]);
            }
            else {
              List no = hi[i].split('[');
              List bo = no[1].split(']');
              List doo = bo[0].split('[');
              List koo = doo[0].split(',');
              for (int j = 0; j < koo.length; j++) {
                if (j != 0) {
                  koo[j] = removeUnWantedSpacesFromSearchWord(koo[j]);
                }
              }
              keyWords.add(koo);
            }
          }
        }
        visibilitiesKeySearch = List.generate(keyWords[widgetIndex].length + 1, (index) => true);
        colors = List.generate(keyWords[widgetIndex].length, (index) => Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
        List<String> hi2 = prefs.getStringList('data');
        data = json.decode(hi2[0]);
        if (!(prefs.getString('country') == null)) {
          _selected = Country.findByIsoCode(prefs.getString('country'));
        }
        List<String> hi1 = prefs.getStringList('dateTimes');
        print(hi1);
        if (hi1 != null) {
          List<List<DateTime>> no2 = [];
          List<DateTime> no3 = [];
          int counter = 0;
          for (int i = 0; i < data.length; i++) {
            for (int j = 0; j < data[i].length; j++) {
              for (int k = 0; k < data[i][j].length; k++) {
                no3.add(DateTime.parse(hi1[k]));
              }
              no2.add(no3);
              no3 = [];
              counter+=1;
            }
            dateTimes.add(no2);
            no2 = [];

          }
        }
        appsPackages.value = prefs.getStringList('appsPackages');
        for (int i = 0; i < appsNames.value.length; i++) {
          visibilities.add(true);
        }
      }
    });
    for (int i = 0; i < keyWords[widgetIndex].length; i++) {
      loading.add(true);
    }
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      noConnectionDialog('requst', context, then);
    }
    else {
      for (int i = 0; i < keyWords[widgetIndex].length; i++) {
        if (_selected == null) {
          await _makeGetRequest(
              _selected.isoCode, keyWords[widgetIndex][i], i, from: 'hi');
        }
        else {
          await _makeGetRequest(
              _selected.isoCode, keyWords[widgetIndex][i], i, from: 'hi');
        }
      }
      setState((){});
    }
  }

  _makeGetRequest(myLocale, searchWord, index, {from}) async {
    Response response = await get(_localhost(myLocale, searchWord, index));
    int counter = 1;
    String htmlCode = response.body.split('jsname="O2DNWb"')[1];
    for (int i = 0; i < 50; i++) {
      //String appName = handleHtmlCode(htmlCode, 'name', i);
      String packageID2 = handleHtmlCode(htmlCode, 'package', i);
      //appName.toLowerCase() == appsNames.value[widgetIndex].toLowerCase() &&
      if (packageID2.toLowerCase() == appsPackages.value[widgetIndex].toLowerCase()){
        break;
      }
      else {
        counter+=1;
      }
    }
    if (from != null) {
      setState(() {
        loading[index] = false;
      });
    }

    if (numberOfTheApp.length < keyWords[widgetIndex].length){
      numberOfTheApp.add(counter);
    }
    else {
      numberOfTheApp[index] = counter;
    }

    DateTime today = DateTime.now();
    //today = DateTime(2020, 12, 8);
    //print(dateTimes[widgetIndex][index]);
    // dateTimes[widgetIndex][index].add(DateTime(today.year, today.month, today.day+1));
    // print(DateTime(today.year, today.month, today.day));
    // print(DateTime(today.year, today.month, today.day+1));
    // data[widgetIndex][index].add(counter);
    if (dateTimes[widgetIndex][index].length > 0) {
      if (DateTime(today.year, today.month, today.day).difference(dateTimes[widgetIndex][index].last).inDays >= 1) {
        if (counter != 51) {
          dateTimes[widgetIndex][index].add(DateTime(today.year, today.month, today.day));
          data[widgetIndex][index].add(counter);
        }
      }
      else {
        if (counter != 51) {
          dateTimes[widgetIndex][index].last = DateTime(today.year, today.month, today.day);
          data[widgetIndex][index].last = counter;
        }
      }
    }
    else {
      if (counter != 51) {
        dateTimes[widgetIndex][index].add(DateTime(today.year, today.month, today.day));
        data[widgetIndex][index].add(counter);
      }
    }

    if  (data[widgetIndex][index].length == 365){
      data[widgetIndex][index].removeAt(0);
    }
    if (keyWords[widgetIndex].length > index + 1) {
      return true;
    }
    else {
      return false;
    }
  }
  
  String _localhost(localCountry, searchWord, index) {
    return 'https://play.google.com/store/search?q=$searchWord&c=apps&gl=$localCountry&hl=en';
  }
}

///Memory folder
String removeUnWantedSpacesFromSearchWord(String searchWord){
  return searchWord.substring(1, searchWord.length);
}
