import 'package:flutter/material.dart';
import '../main.dart';
import '../model/make_quiz.dart';


class Welcome extends StatefulWidget {
  const Welcome({Key key}) : super(key:key);
  @override
  _Welcome createState() => _Welcome();
}
class _Welcome extends State<Welcome> {
  final numQuestions = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 32.0,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text('Welcome!',
                    style: TextStyle(
                      fontSize: 40,
                      color: AppColors.grey,
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: TextField(
                  style: TextStyle(color: AppColors.grey),
                  cursorColor: AppColors.grey,
                  keyboardType: TextInputType.number,
                  controller: numQuestions,
                  onChanged: (v) => numQuestions.text = v,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    labelText: 'Enter number of questions',
                    labelStyle: TextStyle(color: AppColors.grey),
                  )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Builder(
                  builder: (context) {
                    return ElevatedButton( // ElevatedButton
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 50),
                          primary: AppColors.grey),
                      child: Text('Start Quiz'),
                      onPressed: () {
                        //WebClient();
                        Navigator.push(context, MaterialPageRoute(builder: (context) => MakeQuiz()));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

