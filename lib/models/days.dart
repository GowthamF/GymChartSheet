class Days {
  int dayId;
  String dayName;
  bool isDayCompleted;

  Days({this.dayId, this.dayName, this.isDayCompleted});

  factory Days.fromJson(Map<String, dynamic> json) {
    return Days(
        dayId: json['day_id'],
        dayName: json['day_name'],
        isDayCompleted: json['isdaycompleted']);
  }

  Map<String, dynamic> toMap() {
    return {
      'day_id': dayId,
      'day_name': dayName,
      'isdaycompleted': isDayCompleted
    };
  }
}
