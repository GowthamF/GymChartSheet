import 'dart:async';

import 'package:gym_chartsheet/models/days.dart';
import 'package:gym_chartsheet/sqliteservice.dart';

class DaysBloc {
  DaysBloc() {
    getDays();
  }

  final _daysController = StreamController<List<Days>>.broadcast();

  final _dayController = StreamController<Days>.broadcast();

  Stream get days => _daysController.stream;

  Stream get day => _dayController.stream;

  dispose() {
    _daysController.close();
    _dayController.close();
  }

  getDays() async {
    _daysController.sink.add(await SqlService.sql.getAllDays());
  }

  addNewDays(Days day) {
    SqlService.sql.addNewDays(day);
    getDays();
  }

  getDay(int id) async {
    _dayController.sink.add(await SqlService.sql.getDay(id));
  }

  updateDays(Days day) {
    SqlService.sql.updateDays(day);
    getDays();
  }

  deleteDay(int id) {
    SqlService.sql.deleteDay(id);
    getDays();
  }

  deleteAllDays() {
    SqlService.sql.deleteAllDays();
    getDays();
  }
}
