import 'package:flutter/material.dart';
import '../main.dart';

class QuizReview extends StatelessWidget {
  final int resultScore;
  final VoidCallback resetHandler;

  QuizReview(this.resultScore, this.resetHandler);

  String get finalScore {
    var resultText = '$resultScore';
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Text('Score: $finalScore',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          FlatButton(
              textColor: AppColors.grey,
              color: AppColors.white,
              child: Text(
                'A(n) _______________ is a special form of an association representing a has-a or part-whole relationship. There is no lifetime dependency between the whole and the part; they can exist independently, and the part may be shared by multiple wholes.',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: resetHandler),
          Expanded(child:
            Text('The class name should be underlined', style:
              TextStyle(
                  color: AppColors.red,
                  fontSize: 20),))
        ],
      ),
    );
  }
}
