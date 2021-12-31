import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:quiz_a/screens/quiz_screen.dart';
import '../main.dart';
import '../screens/quiz_review.dart';

class MakeQuiz extends StatefulWidget {
  @override
  _MakeQuiz createState() => _MakeQuiz();
}

class _MakeQuiz extends State<MakeQuiz> {

  var index = 0;
  var score = 0;
  var numberOfQuestions = 3;

  final _questions = const [
    {
      'questionText': '‘Which of the following is NOT a correct description of the UML class diagram?',
      'answers': [
        {'text': 'It is the most important and most widely-used diagram among UML diagrams','score': 0},
        {'text': 'It models data, entities and static structures', 'score': 0},
        {'text': 'It models data, entities and static structures', 'score': 0},
        {'text': 'It models the control flow of a system', 'score': 1},
      ]
    },
    {
      'questionText': 'All of the following are correct descriptions of the UML notation for classes, EXCEPT?',
      'answers': [
        {'text': 'A class is represented with a rectangular box', 'score': 0},
        {'text': 'The class box can have several compartments, including name, attributes (fields) and operations (methods)', 'score': 0},
        {'text': 'The name compartment is required, but the others are optional', 'score': 0},
        {'text': 'The class name should be underlined', 'score': 1},
      ]
    },
    {
      'questionText': 'A(n) _______________ is a special form of an association representing a has-a or part-whole relationship. There is no lifetime dependency between the whole and the part; they can exist independently, and the part may be shared by multiple wholes.',
      'answers': [
        {'text': 'aggregation', 'score': 1},
      ]
    },
    {
      'questionText': 'All of the following are correct descriptions of the UML notation for classes, EXCEPT:',
      'answers': [
        {'text': 'A class is represented with a rectangular box', 'score': 0},
        {'text': 'The class box can have several compartments, including name, attributes (fields) and operations (methods)', 'score': 0},
        {'text': 'The name compartment is required, but the others are optional', 'score': 0},
        {'text': 'The class name should be underlined', 'score': 1},
      ]
    },
  ];

  void _review() {
    setState(() {
      return score;
    });
  }

  void getScore(int _score) {
    setState(() {
      score = score + _score;
    });

    setState(() {
      index = index + 1;
    });


  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.grey,
          title: Text('Quiz Center'),
        ),
        body: index < numberOfQuestions
            ?
            QuizScreen(
            answerQuestions: getScore,
            answerIndex: index,
            questions: _questions)
            : QuizReview(score, _review),
      ),
    );
  }
}