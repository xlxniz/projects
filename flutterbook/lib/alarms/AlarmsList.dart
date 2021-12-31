import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../utils.dart';
import 'AlarmsDBWorker.dart';
import 'AlarmsModel.dart' show Alarm, AlarmsModel, alarmsModel;
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

///this is how the alarm is displayed in UI
class AlarmsList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AlarmsModel>(
        model: alarmsModel,
        child: ScopedModelDescendant<AlarmsModel>(
            builder: (BuildContext context, Widget child, AlarmsModel model) {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        alarmsModel.entityBeingEdited = Alarm();
                        alarmsModel.setStackIndex(1);
                      }
                  ),

                  body: ListView.builder(
                      itemCount: alarmsModel.entityList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Alarm alarm = alarmsModel.entityList[index];
                        String time = "";
                        if (alarm.time != null) {
                          time = " ${toFormattedTime(alarm.time, context)}";
                        }
                        return Column(
                            children: <Widget>[
                              Slidable(
                                ///Two Slides to Delete the alarm, and to stop the alarm
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: .25,
                                child: ListTile(
                                    title: Text(time),
                                    subtitle: alarm.description == null ? null :
                                    Text("${alarm.description}"),
                                    onTap: () async {
                                      alarmsModel.entityBeingEdited =
                                      await AlarmsDBWorker.db.get(alarm.id);
                                      alarmsModel.setStackIndex(1);
                                    }
                                ),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: "Delete",
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () => _deleteAlarm(context, alarm),
                                  ),
                                  ///Turns off the alarm
                                  IconSlideAction(
                                      caption: "Snooze",
                                      color: Colors.blueGrey,
                                      icon: Icons.volume_mute,
                                      onTap: () => FlutterRingtonePlayer.stop()
                                  )
                                ],
                              ),
                              Divider(),
                              RaisedButton(
                                  elevation : 0,
                                  color: Colors.transparent,
                                  textColor: Colors.transparent,
                                  splashColor: Colors.transparent,
                                  //Text('Play Alarm'),
                                  onPressed: () {
                                    FlutterRingtonePlayer.playAlarm();
                                  }
                              )
                            ]
                        );
                      }
                  )
              );
            }
        )
    );
  }
  ///delete existing alarm
  Future _deleteAlarm(BuildContext context, Alarm alarm) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
              title: Text('Delete Alarm'),
              content: Text('Are you sure you want to delete ${alarm.description}?'),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () { Navigator.of(alertContext).pop(); },
                ),
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () async {
                    await AlarmsDBWorker.db.delete(alarm.id);
                    Navigator.of(alertContext).pop();
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Alarm deleted'),
                        )
                    );
                    alarmsModel.loadData(AlarmsDBWorker.db);
                  },
                )
              ]
          );
        }
    );
  }
}