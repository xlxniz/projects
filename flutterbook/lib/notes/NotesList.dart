import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesModel.dart';


class NotesList extends StatelessWidget{
  _deleteNote(BuildContext context, NotesModel model, Note note){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext){
          return AlertDialog(
            title: Text("Delete Note"),
            content: Text("Are you sure you want to delete ${note.title}"),
            actions: [
              TextButton(
                  onPressed: ()=>Navigator.of(alertContext).pop(),
                  child: Text("Cancel")
              ),
              TextButton(
                  onPressed: (){
                    model.noteList.remove(note);
                    model.setStackIndex(0);
                    Navigator.of(alertContext).pop();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text("Note deleted")
                      )
                    );
                  },
                  child: Text("Delete"))
            ],
          );
        }
    );
  }
  @override
  Widget build(BuildContext context){
    return ScopedModelDescendant<NotesModel>(
        builder: (BuildContext context,Widget child, NotesModel model){
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  model.noteBeingEdited = Note();
                  model.setColor(null);
                  model.setStackIndex(1);
                }
            ),
            body: ListView.builder(
                itemCount: model.noteList.length,
                itemBuilder: (BuildContext context, int index){
                  Note note = model.noteList[index];
                  Color color = Colors.white;
                  switch(note.color){
                    case "red" : color = Colors.red; break;
                    case "green" : color = Colors.green; break;
                    case "blue" : color = Colors.blue; break;
                    case "yellow" : color = Colors.yellow;break;
                    case "grey" : color = Colors.grey; break;
                    case "purple" : color = Colors.purple; break;
                  }
                  return Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Slidable(
                      actionExtentRatio: .25,
                      secondaryActions: [
                        IconSlideAction(
                            caption: "Delete",
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () => _deleteNote(context, model, note)
                        )
                      ],
                      child: Card(
                        elevation: 8,
                        color: color,
                        child: ListTile(
                          title: Text(note.title),
                          subtitle: Text(note.content),
                          onTap: (){
                            model.noteBeingEdited = note;
                            model.setColor(model.noteBeingEdited.color);
                            model.setStackIndex(1);
                          },
                        )
                      ),
                    )
                  );
                }
            ),
          );
        });
  }
}