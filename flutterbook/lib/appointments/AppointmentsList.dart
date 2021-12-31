import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'AppointmentsDBWorker.dart';
import 'AppointmentsModel.dart' show Appointment, AppointmentsModel, appointmentsModel;
import '../utils.dart';

class AppointmentsList extends StatelessWidget {
  Widget build(BuildContext inContext) {
    EventList<Event> _markedDateMap = EventList(
        events: {});
    for (
    int i = 0; i < appointmentsModel.entityList.length; i++
    ) {
      Appointment appointment =
      appointmentsModel.entityList[i];
      List dateParts = appointment.date.split(",");
      DateTime apptDate = DateTime(
          int.parse(dateParts[0]), int.parse(dateParts[1]),
          int.parse(dateParts[2]));
      _markedDateMap.add(apptDate, Event(date: apptDate,
          icon: Container(decoration: BoxDecoration(
              color: Colors.blueGrey))
      ));
    }
    return ScopedModel<AppointmentsModel>(
        model: appointmentsModel,
        child: ScopedModelDescendant<AppointmentsModel>(
            builder: (inContext, inChild, inModel) {
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                    child: Icon(Icons.add, color: Colors.white),
                    onPressed: () async {
                      appointmentsModel.entityBeingEdited =
                          Appointment();
                      DateTime now = DateTime.now();
                      appointmentsModel.entityBeingEdited.date =
                      "${now.year},${now.month},${now.day}";
                      appointmentsModel.setChosenDate(
                          DateFormat.yMMMMd("en_US").format(
                              now.toLocal()));
                      appointmentsModel.setTime(null);
                      appointmentsModel.setStackIndex(1);
                    }
                ), body: Column(
                  children: [
                    Expanded(
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: CalendarCarousel<Event>(
                                thisMonthDayBorderColor: Colors.grey,
                                todayButtonColor: Colors.blueGrey,
                                selectedDayBorderColor: Colors.blueGrey,
                                todayBorderColor: Colors.blueGrey,
                                daysHaveCircularBorder: false,
                                markedDatesMap: _markedDateMap,
                                onDayPressed:
                                    (DateTime inDate, List<Event> inEvents) {
                                  _showAppointments(inDate, inContext);
                                }
                            )
                        )
                    )
                  ]
              ),
              );
            }
        )
    );
  }


  void _editAppointment(BuildContext inContext, Appointment
  inAppointment) async {
    appointmentsModel.entityBeingEdited =
    await AppointmentsDBWorker.db.get(inAppointment.id);
    if (appointmentsModel.entityBeingEdited.date == null) {
      appointmentsModel.setChosenDate(null);
    } else {
      List dateParts =
      appointmentsModel.entityBeingEdited.date.split(",");
      DateTime apptDate = DateTime(
          int.parse(dateParts[0]), int.parse(dateParts[1]),
          int.parse(dateParts[2]));
      appointmentsModel.setChosenDate(
          DateFormat.yMMMMd("en_US").format(apptDate.toLocal()));
    }
    if (appointmentsModel.entityBeingEdited.time == null) {
      appointmentsModel.setTime(null);
    } else {
      List timeParts =
      appointmentsModel.entityBeingEdited.time.split(",");
      TimeOfDay apptTime = TimeOfDay(
          hour : int.parse(timeParts[0]),
          minute : int.parse(timeParts[1]));
      appointmentsModel.setTime(apptTime.format(inContext));
    }
    appointmentsModel.setStackIndex(1);
    Navigator.pop(inContext);
  }

  Future _deleteAppointment(BuildContext context, Appointment app) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
              title: Text('Delete Appointment'),
              content: Text('Really delete ${app.title}?'),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () { Navigator.of(alertContext).pop(); },
                ),
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () async {
                    await AppointmentsDBWorker.db.delete(app.id);
                    Navigator.of(alertContext).pop();
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Appointment deleted'),
                        )
                    );
                    appointmentsModel.loadData(AppointmentsDBWorker.db);
                  },
                )
              ]
          );
        }
    );
  }

  void _showAppointments(DateTime date, BuildContext context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return ScopedModel<AppointmentsModel>(
              model: appointmentsModel,
              child: ScopedModelDescendant<AppointmentsModel>(
                  builder: (BuildContext context, Widget child, AppointmentsModel model) {
                    return Scaffold(
                        body: Container(
                            child: Padding(
                                padding: EdgeInsets.all(10),
                                child: GestureDetector(
                                    child: Column(
                                      children: <Widget>[
                                        Text(formatDate(date),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Theme.of(context).accentColor, fontSize: 24)),
                                        Divider(),
                                        Expanded(
                                            child: ListView.builder(
                                                itemCount: appointmentsModel.entityList.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  Appointment app = appointmentsModel.entityList[index];
                                                  if (app.date != "${date.year},${date.month},${date.day}") {
                                                    return Container(height: 0);
                                                  }
                                                  String time = "";
                                                  if (app.time != null) {
                                                    time = " (${toFormattedTime(app.time, context)})";
                                                  }
                                                  return Slidable(
                                                    actionPane: SlidableDrawerActionPane(),
                                                    actionExtentRatio: .25,
                                                    child: Container(
                                                        margin: EdgeInsets.only(bottom: 8),
                                                        color: Colors.grey.shade300,
                                                        child: ListTile(
                                                          title: Text("${app.title}$time"),
                                                          subtitle: app.description == null ? null :
                                                          Text("${app.description}"),
                                                          onTap: () async {
                                                            _editAppointment(context, app);
                                                          },
                                                        )
                                                    ),
                                                    secondaryActions: <Widget>[
                                                      IconSlideAction(
                                                        caption: "Delete",
                                                        color: Colors.red,
                                                        icon: Icons.delete,
                                                        onTap: () => _deleteAppointment(context, app),
                                                      )
                                                    ],
                                                  );
                                                })
                                        ),
                                      ],
                                    )
                                )
                            )
                        )

                    );
                  }
              )
          );
        });
  }
}