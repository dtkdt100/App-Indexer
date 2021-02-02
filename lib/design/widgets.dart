import 'package:app_index_for_developers/packages/CountUp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:math' as math;

Widget decideWidgetIfGrow(List listForLines){
  Widget icon;
  String text;

  if (listForLines.length == 0 || listForLines.length == 1 || (listForLines[listForLines.length-1]).toInt() == 51){
    icon = Icon(Icons.trending_flat, color: Colors.grey,);
    text = '0';
  }
  else {
    text = '${(listForLines[listForLines.length-1]).toInt() - (listForLines[listForLines.length-2]).toInt()}';
    if (listForLines[listForLines.length - 1] >
        listForLines[listForLines.length - 2]) {
      icon = Icon(Icons.trending_up, color: Colors.red,);
    }
    else if (listForLines[listForLines.length - 1] == listForLines[listForLines.length - 2]) {
      icon = Icon(Icons.trending_flat, color: Colors.grey,);
      text = '0';
    }
    else {
      text = '${int.parse(text) * -1}';
      icon = Icon(Icons.trending_down, color: Colors.green,);
    }
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text(text, style: TextStyle(color: Colors.grey[700], fontSize: 15),),
      icon,
    ],
  );
}

Widget checkIfLoadingFun(List loading, numberOfTheApp, index, duration, colors){
  if (loading[index]){
    return SpinKitRing(
      color: Colors.blue,
      size: 55,
      lineWidth: 5.5,
    );
  }
  if (numberOfTheApp[index] == 51){
    return Padding(
      padding: const EdgeInsets.only(top: 15, bottom: 15),
      child: Text("Your app is not here",
        style: TextStyle(color: colors[index], fontSize: 20),),
    );
  }
  return Countup(
    begin: 0,
    end: numberOfTheApp[index].toDouble(),
    duration: Duration(
        milliseconds: duration),
    style: TextStyle(
        color: colors[index], fontSize: 45),
  );
}