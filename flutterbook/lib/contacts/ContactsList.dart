import 'dart:io';
import 'package:flutter/material.dart';
import 'Avatar.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'ContactsDBWorker.dart';
import 'ContactsModel.dart' show Contact, ContactsModel, contactsModel;
import '../utils.dart' as utils;

class ContactsList extends StatelessWidget with Avatar {

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ContactsModel>(
        model: contactsModel,
        child: ScopedModelDescendant<ContactsModel>(
            builder: (BuildContext context, Widget child, ContactsModel model) {
              return Scaffold(
                  floatingActionButton: FloatingActionButton(
                      child: Icon(Icons.add, color: Colors.white),
                      onPressed: () async {
                        File avatarFile = avatarTempFile();
                        if (avatarFile.existsSync()) {
                          avatarFile.deleteSync();
                        }
                        contactsModel.entityBeingEdited = Contact();
                        contactsModel.setBirthday(null);
                        contactsModel.setStackIndex(1);
                      }
                  ),

                  body: ListView.builder(
                      itemCount: contactsModel.entityList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Contact contact = contactsModel.entityList[index];
                        File avatarFile = File(avatarFileName(contact.id));
                        bool avatarFileExists = avatarFile.existsSync();
                        return Column(
                            children: <Widget>[
                              Slidable(
                                actionPane: SlidableDrawerActionPane(),
                                actionExtentRatio: .25,
                                child: ListTile(
                                    leading: CircleAvatar(
                                        backgroundColor: Colors.indigoAccent,
                                        foregroundColor: Colors.white,
                                        backgroundImage: avatarFileExists
                                            ? FileImage(avatarFile)
                                            : null,
                                        child: avatarFileExists ? null : Text(
                                            contact.name.substring(0, 1)
                                                .toUpperCase())
                                    ),
                                    title: Text("${contact.name}"),
                                    subtitle: contact.phone == null
                                        ? null
                                        : Text("${contact.phone}"),
                                    onTap: () async {
                                      File avatarFile = avatarTempFile();
                                      if (avatarFile.existsSync()) {
                                        avatarFile.deleteSync();
                                      }
                                      contactsModel.entityBeingEdited =
                                      await ContactsDBWorker.db.get(contact.id);
                                      if (contactsModel.entityBeingEdited
                                          .birthday == null) {
                                        contactsModel.setBirthday(null);
                                      } else {
                                        contactsModel.setBirthday(
                                            utils.toFormattedDate(
                                                contactsModel.entityBeingEdited
                                                    .birthday));
                                      }
                                      contactsModel.setStackIndex(1);
                                    }
                                ),
                                secondaryActions: <Widget>[
                                  IconSlideAction(
                                    caption: "Delete",
                                    color: Colors.red,
                                    icon: Icons.delete,
                                    onTap: () => _deleteContact(context, contact),
                                  )
                                ],
                              ),
                              Divider()
                            ]
                        );
                      }
                  )
              );
            }
        )
    );
  }

  Future _deleteContact(BuildContext context, Contact contact) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext alertContext) {
          return AlertDialog(
              title: Text('Delete Contact'),
              content: Text('Really delete ${contact.name}?'),
              actions: [
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () { Navigator.of(alertContext).pop(); },
                ),
                FlatButton(
                  child: Text('Delete'),
                  onPressed: () async {
                    await ContactsDBWorker.db.delete(contact.id);
                    Navigator.of(alertContext).pop();
                    Scaffold.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 2),
                          content: Text('Contact deleted'),
                        )
                    );
                    contactsModel.loadData(ContactsDBWorker.db);
                  },
                )
              ]
          );
        }
    );
  }
}