import 'package:flutter/material.dart';
import 'package:gym_chartsheet/chartlist.dart';
import 'package:gym_chartsheet/daysbloc.dart';
import 'package:gym_chartsheet/models/days.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Home();
  }
}

class _Home extends State<Home> with SingleTickerProviderStateMixin {
  final List<String> _tabs = <String>[
    "Day 1",
    "Day 2",
    "Day 3",
    "Day 4",
    "Day 5"
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: DaysBloc().getDays(),
        builder: (context, AsyncSnapshot<List<Days>> snapshot) {
          return ChartList(
            tabs: snapshot.data,
          );
        });
  }
}
