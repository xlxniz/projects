import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'TasksDBWorker.dart';
import 'TasksModel.dart';
import '../utils.dart' show selectDate;

class TasksEntry extends StatelessWidget {

  final TextEditingController _descriptionEditingController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TasksEntry() {
    _descriptionEditingController.addListener(() {
      tasksModel.entityBeingEdited.description = _descriptionEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<TasksModel>(
      model: tasksModel,
      child: ScopedModelDescendant<TasksModel>(
          builder: (BuildContext context, Widget child, TasksModel model) {

            //- Correction:
            // add the following two lines for "editing" an existing note
            if (model.entityBeingEdited != null) {
              _descriptionEditingController.text =
                  model.entityBeingEdited.description;
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
                              _save(context, tasksModel);
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
                              leading: Icon(Icons.content_paste),
                              title: TextFormField(
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 8,
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
                          ListTile(
                            leading: Icon(Icons.today),
                            title: Text("Due Date"),
                            subtitle: Text(_dueDate()),
                            trailing: IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.blue,
                              onPressed: () async {
                                String chosenDate = await selectDate(context, tasksModel,
                                    tasksModel.entityBeingEdited.dueDate);
                                if (chosenDate != null) {
                                  tasksModel.entityBeingEdited.dueDate = chosenDate;
                                }
                              },
                            ),
                          )
                        ]
                    )
                )
            );
          }
      ),
    );
  }

  String _dueDate() {
    if (tasksModel.entityBeingEdited != null && tasksModel.entityBeingEdited.hasDueDate()) {
      return tasksModel.entityBeingEdited.dueDate;
    }
    return '';
  }

  void _save(BuildContext context, TasksModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    if (model.entityBeingEdited.id == null) {
      await TasksDBWorker.db.create(tasksModel.entityBeingEdited);
    } else {
      await TasksDBWorker.db.update(tasksModel.entityBeingEdited);
    }
    tasksModel.loadData(TasksDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Task saved'),
        )
    );
  }
}