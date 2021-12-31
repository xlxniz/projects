import "../BaseModel.dart";

///alarm model class
AlarmsModel alarmsModel = AlarmsModel();

class Alarm {
  int id;
  String time;
  String description;

  bool hasTime() => time != null;

  String toString() =>
      "{ id=$id, time=$time, description=$description }";
}

class AlarmsModel extends BaseModel<Alarm> with DateSelection {
  String time;

  void setDate(String date) {
    super.setChosenDate(date);
  }

  void setTime(String time) {
    this.time = time;
    notifyListeners();
  }
}

