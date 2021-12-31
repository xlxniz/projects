import "../BaseModel.dart";

NotesModel notesModel = NotesModel();

class Note{
  String title;
  String content;
  String color;

  String toString() => "{title=$title,content=$content,color=$color}";
}
class NotesModel extends BaseModel{
  int stackIndex = 0;
  List<Note> noteList = [];
  Note noteBeingEdited;
  String color;

  void setColor(String color){
    this.color = color;
    notifyListeners();
  }
}
