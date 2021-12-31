import 'package:flutter/material.dart';
import '../main.dart';


class Answers extends StatelessWidget {

  final VoidCallback selectHandler;
  final answerText;

  Answers(this.selectHandler, this.answerText);
  @override
  Widget build(BuildContext context) {
    //print(answerText);
    //print(answerText.length);
    if(answerText.length == 11)
      return Container(
        width: double.infinity,
        margin: EdgeInsets.all(5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                  style: TextStyle(color: AppColors.grey),
                  cursorColor: AppColors.grey,
                  //keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Enter answer',
                    labelStyle: TextStyle(color: AppColors.grey),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RaisedButton(
                  color: AppColors.grey,
                  textColor: AppColors.white,
                  child: Text('next'),
                  onPressed: selectHandler
              ),
            ),
          ],
        ),
      );
    else
      return Container(
        width: double.infinity,
        margin: EdgeInsets.all(5),
        child: RaisedButton(
            color: AppColors.grey,
            textColor: AppColors.white,
            child: Text(answerText),
            onPressed: selectHandler
        ),
      );
  }
}

