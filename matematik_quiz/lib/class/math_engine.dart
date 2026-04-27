import 'dart:math';
import 'package:matematik_quiz/class/question.dart';

class MathEngine {
  final Random _rnd = Random();

  Question generate(String difficulty) {
    int depth;
    int maxNum;
    List<String> ops = ['+', '-'];

    if (difficulty == 'Easy') {
      depth = 1;
      maxNum = 15;
    } else if (difficulty == 'Medium') {
      depth = 2;
      maxNum = 30;
      ops.addAll(['*', '/']);
    } else {
      depth = 3;
      maxNum = 50;
      ops.addAll(['*', '/']);
    }

    int result = _rnd.nextInt(maxNum) + 2;
    String expression = '$result';

    for (int i = 0; i < depth; i++) {
      String op = ops[_rnd.nextInt(ops.length)];
      int n = _rnd.nextInt(maxNum) + 2;

      if (op == '+') {
        result += n;
        expression = '($expression + $n)';
      } else if (op == '-') {
        result -= n;
        expression = '($expression - $n)';
      } else if (op == '*') {
        int smallN = _rnd.nextInt(10) + 2;
        result *= smallN;
        expression = '($expression * $smallN)';
      } else if (op == '/') {
        int divisor = _rnd.nextInt(10) + 2;
        int newTotal = result * divisor;
        expression = '($newTotal / $divisor)';
      }
    }

    if (expression.startsWith('(') && expression.endsWith(')')) {
      expression = expression.substring(1, expression.length - 1);
    }

    Set<int> opts = {result};
    while (opts.length < 4) {
      int offset = _rnd.nextInt(10) + 1;
      opts.add(result + (_rnd.nextBool() ? offset : -offset));
    }

    return Question(
      text: expression,
      correctAnswer: result,
      options: opts.toList()..shuffle(),
    );
  }
}