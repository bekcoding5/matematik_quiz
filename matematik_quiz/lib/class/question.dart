class Question {
  final String text;
  final int correctAnswer;
  final List<int> options;

  Question({
    required this.text,
    required this.correctAnswer,
    required this.options,
  });
}

class WrongAnswer {
  final String question;
  final int correct;
  final int userAns;

  WrongAnswer({
    required this.question,
    required this.correct,
    required this.userAns,
  });
}