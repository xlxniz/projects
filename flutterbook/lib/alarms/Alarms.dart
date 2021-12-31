import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'AlarmsEntry.dart';
import 'AlarmsModel.dart' show AlarmsModel, alarmsModel;
import 'AlarmsDBWorker.dart';
import 'AlarmsList.dart';

///loads data and calls on AlarmList and AlarmsEntry
class Alarms extends StatelessWidget {
  Alarms() {
    alarmsModel.loadData(AlarmsDBWorker.db);
  }
  @override
  Widget build(BuildContext context) {
    return ScopedModel<AlarmsModel>(
        model: alarmsModel,
        child: ScopedModelDescendant<AlarmsModel>(
            builder: (BuildContext context, Widget child, AlarmsModel model) {
              return IndexedStack(
                index: model.stackIndex,
                children: <Widget>[ AlarmsList(), AlarmsEntry()],
              );
            }
        )
    );
  }
}
