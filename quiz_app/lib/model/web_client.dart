import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WebClient extends StatefulWidget{
  final int numQuestions = 0;

  //MakeQuiz(TextEditingController numQuestions, {this.numQuestions});

  @override
  _WebClient createState() => _WebClient();
}
class _WebClient extends State<WebClient> {
  String quiz = 'quiz03';

  //var futureBuilder = new FutureBuilder(builder: getQuiz(quiz))
  var questions;
  int questionIndex = 0;
  int score = 0;
  bool _loading;



  Future getQuiz(String quiz) async {
    var url = Uri.parse('cheon.atwebpages.com/quiz/quiz$quiz');
    http.Response response = await http.get(url);
    var statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400) {
      return Future.error('Server connection failed ($statusCode).');
    }
    var decoded = json.decode(response.body);
    if(decoded['response'] == false) {
      return null;
    }
    ///call to parseQuiz in Response class
    return decoded['quiz']['question'];
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    );
  }
}