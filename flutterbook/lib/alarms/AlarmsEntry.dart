import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'AlarmsDBWorker.dart';
import 'AlarmsModel.dart' show Alarm, AlarmsModel, alarmsModel;
import '../utils.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

///This is the adding/editing alarm class
class AlarmsEntry extends StatelessWidget {

  final TextEditingController _timeEditingController = TextEditingController();
  final TextEditingController _descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AlarmsEntry() {
    _timeEditingController.addListener(() {
      alarmsModel.entityBeingEdited.time = _timeEditingController.text;
    });
    _descriptionEditingController.addListener(() {
      alarmsModel.entityBeingEdited.description = _descriptionEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<AlarmsModel>(
      model: alarmsModel,
      child: ScopedModelDescendant<AlarmsModel>(
          builder: (BuildContext context, Widget child, AlarmsModel model) {

            // add the following two lines for "editing" an existing note
            if (model.entityBeingEdited != null) {
              _timeEditingController.text = model.entityBeingEdited.time;
            }

            return Scaffold(
                bottomNavigationBar: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Row(
                        children: [
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              model.setStackIndex(0);
                            },
                          ),
                          Spacer(),
                          FlatButton(
                            child: Text('Save'),
                            onPressed: () {
                              _save(context, alarmsModel);
                            },
                          )
                        ]
                    )
                ),
                body: Form(
                    key: _formKey,
                    child: ListView(
                        children: [
                          ListTile(
                            leading: Icon(Icons.alarm),
                            title: Text("Alarm"),
                            subtitle: Text(alarmsModel.time ?? ''),
                            trailing: IconButton(
                                icon: Icon(Icons.alarm_add),
                                color: Colors.blueGrey,
                                onPressed: () => _selectTime(context)
                            ),
                          ),
                          ListTile(
                              leading: Icon(Icons.content_paste),
                              title: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 1,
                                  decoration: InputDecoration(hintText: 'Description'),
                                  controller: _descriptionEditingController,
                                  validator: (String value) {
                                    if (value.length == 0) {
                                      return 'Please enter a description';
                                    }
                                    return null;
                                  }
                              )
                          ),
                        ]
                    )
                )
            );
          }
      ),
    );
  }

  Future<void> _playAlarm(var time) async {
    print(time);
    print(TimeOfDay.now());
    if (time == TimeOfDay.now()) {
      FlutterRingtonePlayer.playAlarm();
    }
  }

  ///Method to call on to select time
  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();
    if (alarmsModel.entityBeingEdited.time != null) {
      initialTime = toTime(alarmsModel.entityBeingEdited.time);
    }
    TimeOfDay picked = await showTimePicker(context: context, initialTime: initialTime);
    if (picked != null) {
      alarmsModel.entityBeingEdited.time = "${picked.hour},${picked.minute}";
      alarmsModel.setTime(picked.format(context));
    }
  }

  ///Saves the Entry
  void _save(BuildContext context, AlarmsModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    int id = 0;
    if (model.entityBeingEdited.id == null) {
      id = await AlarmsDBWorker.db.create(alarmsModel.entityBeingEdited);
    } else {
      id = await AlarmsDBWorker.db.update(alarmsModel.entityBeingEdited);
    }

    alarmsModel.loadData(AlarmsDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.blueGrey,
          duration: Duration(seconds: 2), content: Text('Alarm saved'),
        )
    );
  }
}