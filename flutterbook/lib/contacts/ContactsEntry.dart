import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'Avatar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';
import 'ContactsDBWorker.dart';
import 'ContactsModel.dart';
import '../utils.dart' as utils;

class ContactsEntry extends StatelessWidget with Avatar {

  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ContactsEntry() {
    _nameEditingController.addListener(() {
      contactsModel.entityBeingEdited.name = _nameEditingController.text;
    });
    _phoneEditingController.addListener(() {
      contactsModel.entityBeingEdited.phone = _phoneEditingController.text;
    });
    _emailEditingController.addListener(() {
      contactsModel.entityBeingEdited.email = _emailEditingController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<ContactsModel>(
      model: contactsModel,
      child: ScopedModelDescendant<ContactsModel>(
          builder: (BuildContext context, Widget child, ContactsModel model) {

            // Correction:
            // add the following two lines for "editing" an existing note
            if (model.entityBeingEdited != null) {
              _nameEditingController.text = model.entityBeingEdited.name;
              _phoneEditingController.text = model.entityBeingEdited.phone;
              _emailEditingController.text = model.entityBeingEdited.email;
            }

            File avatarFile = avatarTempFile();
            if (!avatarFile.existsSync()) {
              if (model.entityBeingEdited != null && model.entityBeingEdited.id != null) {
                avatarFile = File(avatarFileName(model.entityBeingEdited.id));
              }
            }

            return Scaffold(
                bottomNavigationBar: Padding(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: Row(
                        children: [
                          FlatButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              File avatarFile = avatarTempFile();
                              if (avatarFile.existsSync()) {
                                avatarFile.deleteSync();
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                              model.setStackIndex(0);
                            },
                          ),
                          Spacer(),
                          FlatButton(
                            child: Text('Save'),
                            onPressed: () {
                              _save(context, model);
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
                              title: avatarFile.existsSync() ?
                              //Image.file(avatarFile)
                              Image.memory(
                                Uint8List.fromList(avatarFile.readAsBytesSync()),
                                alignment: Alignment.center,
                                height: 200,
                                width: 200,
                                fit: BoxFit.contain,
                              )
                                  : Text("No avatar image for this contact"),
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  color: Colors.blue,
                                  onPressed: () => _selectAvatar(context)
                              )
                          ),

                          ListTile(
                              leading: Icon(Icons.person),
                              title: TextFormField(
                                  decoration: InputDecoration(hintText: 'Name'),
                                  controller: _nameEditingController,
                                  validator: (String value) {
                                    if (value.length == 0) {
                                      return 'Please enter a name';
                                    }
                                    return null;
                                  }
                              )

                          ),

                          ListTile(
                              leading: Icon(Icons.phone),
                              title: TextFormField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(hintText: "Phone"),
                                controller: _phoneEditingController,
                              )
                          ),

                          ListTile(
                            leading: Icon(Icons.email),
                            title: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(hintText: "Email"),
                              controller: _emailEditingController,
                            ),
                          ),

                          ListTile(
                            leading: Icon(Icons.today),
                            title: Text("Birthday"),
                            subtitle: Text(contactsModel.chosenDate == null ? "" : contactsModel.chosenDate),
                            trailing: IconButton(
                                icon: Icon(Icons.edit),
                                color: Colors.blue,
                                onPressed: () async {
                                  String chosenDate = await utils.selectDate(context,
                                      contactsModel, contactsModel.entityBeingEdited.birthday);
                                  if (chosenDate != null) {
                                    contactsModel.entityBeingEdited.birthday = chosenDate;
                                  }
                                }),
                          )
                        ]
                    )
                )
            );
          }
      ),
    );
  }

  Future _selectAvatar(BuildContext context) {
    return showDialog(context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                        child: Text("Take a picture"),
                        onTap: () async {
                          print('testing');
                          /*
                          var cameraImage = await ImagePicker.pickImage(source: ImageSource.camera);
                          if (cameraImage != null) {
                            cameraImage.copySync(avatarTempFileName());
                            contactsModel.triggerRebuild();
                          }
                          Navigator.of(dialogContext).pop();

                           */
                        }
                    ),

                    Divider(),

                    GestureDetector(
                      child: Text("Select From Gallery"),
                      onTap: () async {
                        print('testing');
                        /*
                        var galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);
                        if (galleryImage != null) {
                          galleryImage.copySync(avatarTempFileName());
                          imageCache.clear();
                          contactsModel.triggerRebuild();
                        }
                        Navigator.of(dialogContext).pop();
                        */
                      },
                    ),
                  ],
                )
            ),
          );
        }
    );
  }

  void _save(BuildContext context, ContactsModel model) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    int id = 0;
    if (model.entityBeingEdited.id == null) {
      id = await ContactsDBWorker.db.create(contactsModel.entityBeingEdited);
    } else {
      id = await ContactsDBWorker.db.update(contactsModel.entityBeingEdited);
    }
    File avatarFile = avatarTempFile();
    if (avatarFile.existsSync()) {
      File f = avatarFile.renameSync(avatarFileName(id));

    }
    contactsModel.loadData(ContactsDBWorker.db);
    model.setStackIndex(0);
    Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2), content: Text('Contact saved'),
        )
    );
  }
}