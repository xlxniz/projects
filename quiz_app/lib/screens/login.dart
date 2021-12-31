import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_a/screens/welcome.dart';
import 'dart:convert';
import '../main.dart';


class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormFieldState<String>> _usernameFormKey = GlobalKey();
  final GlobalKey<FormFieldState<String>> _passwordFormKey = GlobalKey();
  String username = '';
  String password = '';

  _notEmpty(String value) => value != null && value.isNotEmpty;

  get values => ({
    'username': _usernameFormKey.currentState?.value,
    'password': _passwordFormKey.currentState?.value
  });
  bool value = false;

  //utep ID

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home : Scaffold(
        resizeToAvoidBottomInset: false,
        body : Container(
          padding : EdgeInsets.all(5.0),
          child: Form(
            child: Column(
              children: <Widget>[
                TextFormField(
                  key: _usernameFormKey,
                  decoration: InputDecoration(
                    labelText: 'Username',
                  ),
                  validator: (value) =>
                  _notEmpty(value) ? null : 'Username is required',
                ),
                TextFormField(
                  key: _passwordFormKey,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (value) =>
                  _notEmpty(value) ? null : 'Password is required',
                ),
                Builder(builder: (context) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton( // ElevatedButton
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 125),
                            primary: AppColors.grey),
                        child: Text('Log In'),
                        onPressed: () {
                          //if (_usernameFormKey != username && _passwordFormKey != password)
                            //print('Incorrect username or password'); // for debugging
                          //else
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Welcome()));
                        },
                      ),
                    ],
                  );
                }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: this.value,
                      onChanged: (bool value) {
                        setState(() {
                          this.value = value;
                        });
                      }
                    ),
                    Text('Remember me'),
                  ],
                ),
                Expanded(child: Text('*User name of your UTEP miners account')
                ),
              ],
            ),
          )
        )
      )
    );
  }
}

Future getLogin(username, password) async {

  const _AUTHORITY = 'cheon.atwebpages.com';
  const _PATH = '/quiz';
  const _QUERY = 'login';

  var url = Uri.http(_AUTHORITY, _PATH, {_QUERY: username + password});
  var response = await http.get(url);
  var statusCode = response.statusCode;

  if (statusCode < 200 || statusCode > 400) {
    return Future.error('Server connection failed ($statusCode).');
  }
  var decoded = json.decode(response.body);
  if (decoded['response'] == true) {
    return true;
  }
  return decoded['response'];
}

