import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class SimpleLineChart extends StatefulWidget {
  List <String> keyWords;
  List <dynamic> data;
  List<List<DateTime>> dateTimes;
  SimpleLineChart(this.keyWords, this.data, this.dateTimes);
  @override
  _SimpleLineChartState createState() => _SimpleLineChartState();

/// Create one series with sample hard coded data.

}

class _SimpleLineChartState extends State<SimpleLineChart> {
//  List<TimeSeriesSales> data = [
//    TimeSeriesSales(DateTime(2020, 9, 29), 1),
//    TimeSeriesSales(DateTime(2020, 9, 30), 3),
//    TimeSeriesSales(DateTime(2020, 10, 1), 4),
//    TimeSeriesSales(DateTime(2020, 10, 2), 5),
//  ];
//
//  List<TimeSeriesSales> data2 = [
//    TimeSeriesSales(DateTime(2020, 9, 29), 3),
//    TimeSeriesSales(DateTime(2020, 9, 30), 6),
//    TimeSeriesSales(DateTime(2020, 10, 1), 8),
//    TimeSeriesSales(DateTime(2020, 10, 2), 10),
//  ];
//  List<TimeSeriesSales> data3 = [
//    TimeSeriesSales(DateTime(2020, 9, 29), 4),
//    TimeSeriesSales(DateTime(2020, 9, 30), 6),
//    TimeSeriesSales(DateTime(2020, 10, 1), 8),
//    TimeSeriesSales(DateTime(2020, 10, 2), 13),
//  ];
  List<Color> colors;
  List<List<TimeSeriesSales>> dataaaa;
  List<List<TimeSeriesSales>> dataCheck;
  List<bool> valuesForCheckBox;
//  List<List<TimeSeriesSales>> createData() {
//    return List.generate(widget.data.length, (index) {
//      return List.generate(5, (index) {
//        return TimeSeriesSales(DateTime(2020, 9, 20+index), index+1);
//      });
//    });
//  }
  List<charts.Series<TimeSeriesSales, DateTime>> createTheChart() {
    return List.generate(widget.keyWords.length, (index) {
      return new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Sales$index',
        seriesColor: charts.ColorUtil.fromDartColor(colors[index]),
        //colorFn: (_, __) => returnTheColor(),
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        //data: createData()[index],
        data: dataaaa[index],
      );
    });
  }

  @override
  void initState() {
    setState(() {
      dataaaa = generateAChartFromData();
      valuesForCheckBox = List.generate(widget.keyWords.length, (index) => true);
    });
    colors = List.generate(widget.keyWords.length, (index) {
      Color color = (Color((math.Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0));
      return color;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5b84b0),
        title: Text('Analytics'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: charts.TimeSeriesChart(
                createTheChart(),
                domainAxis: charts.DateTimeAxisSpec(
                  tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
                    hour: charts.TimeFormatterSpec(
                    ),
                    day: charts.TimeFormatterSpec(
                      format: 'dd',
                      transitionFormat: 'dd MMM',
                    ),
                  ),
                ),
                animate: true,
                dateTimeFactory: const charts.LocalDateTimeFactory(),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.only(bottom: 15, right: 15, left: 15),
              height: 75,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(widget.keyWords.length, (index) {
                  return Row(
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Column(
                        children: <Widget>[
                          Checkbox(
                            activeColor: colors[index],
                            value: valuesForCheckBox[index],
                            onChanged: (bool){
                              setState(() {
                                valuesForCheckBox[index] = bool;
                                if (dataaaa[index].length == 0){
                                  dataaaa[index] = generateAChartFromSpecificData(index);
                                }
                                else {
                                  dataaaa[index] = [];
                                }
                              });
                            },
                          ),
                          Container(
                            width: 55,
                            height: 20,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: <Widget>[
                                Center(child: Text('${widget.keyWords[index]}', style: TextStyle(color: Colors.grey[600]),)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5,),
                    ],
                  );
                }),
              )
          ),
        ],
      ),
    );
  }
  List<List<TimeSeriesSales>> generateAChartFromData() {
    return List.generate(widget.keyWords.length, (index) {
      return List.generate(widget.data[index].length, (index2) {
        //print(widget.dateTimes[index][index2]);
        return TimeSeriesSales(widget.dateTimes[index][index2], widget.data[index][index2]);
      });
    });
  }
  List<TimeSeriesSales> generateAChartFromSpecificData(index) {
    return List.generate(widget.data[index].length, (index2) {
      return TimeSeriesSales(widget.dateTimes[index][index2], widget.data[index][index2]);
    });
  }
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}