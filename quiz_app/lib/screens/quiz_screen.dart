import 'package:flutter/material.dart';
import '../main.dart';
import '../model/question.dart';
import '../model/answer.dart';

class QuizScreen extends StatelessWidget {
  final List<Map<String, Object>> questions;
  final int answerIndex;
  final Function answerQuestions;

  QuizScreen({this.answerQuestions, this.questions, this.answerIndex});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //resizeToAvoidBottomInset: false,
      child: Column(
        children: [
          Text('${answerIndex+1}/3',
            style: TextStyle(
              fontSize: 18,
              color: AppColors.grey,
            ),
          ),
          Questions(questions[answerIndex]['questionText'] as String),
          ...(questions[answerIndex]['answers'] as List<Map<String, Object>>)
              .map((answer) {
            return Answers(
              () => answerQuestions(answer['score']), answer['text']);
          }).toList(),
        ],
      ),
    );
  }
}
