import 'package:flutter/material.dart';

final ValueNotifier<List <String>> appsNames = ValueNotifier<List <String>>([]);
final ValueNotifier<List <String>> appsPackages = ValueNotifier<List <String>>([]);
List<List<String>> keyWords = [];
List<List<List<DateTime>>> dateTimes = [];
List<dynamic> data = [];
bool check = true;
String keySearch = '';
String yourApp = '';
String packageID = '';
List <bool> visibilities = [];
int widgetIndex;
bool firstOpen = true;
bool isEqual = false;