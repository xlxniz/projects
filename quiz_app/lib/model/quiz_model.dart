class QuizModel {
  String name;
  List<Question> question;

  QuizModel({this.name, this.question});

  QuizModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    if (json['question'] != null) {
      question = new List<Question>();
      json['question'].forEach((v) {
        question.add(new Question.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.question != null) {
      data['question'] = this.question.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Question {
  int type;
  String stem;
  dynamic answer;
  List<String> option;

  Question({this.type, this.stem, this.answer, this.option});

  Question.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    stem = json['stem'];
    answer = json['answer'];
    option = json['option'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['stem'] = this.stem;
    data['answer'] = this.answer;
    data['option'] = this.option;
    return data;
  }
}

class _Quiz {
  bool response;
  QuizModel quiz;

  _Quiz({this.response, this.quiz});

  _Quiz.fromJson(Map<String, dynamic> json) {
    response = json['response'];
    quiz = (json['quiz'] != null ? new _Quiz.fromJson(json['quiz']) : null) as QuizModel;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response'] = this.response;
    if (this.quiz != null) {
      data['quiz'] = this.quiz.toJson();
    }
    return data;
  }
}