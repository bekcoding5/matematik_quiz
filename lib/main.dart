import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Question {
  final String text;
  final int correctAnswer;
  final List<int> options;

  Question(
      {required this.text, required this.correctAnswer, required this.options});
}

// Xatolarni saqlash uchun model
class WrongAnswer {
  final String question;
  final int correct;
  final int userAns;
  WrongAnswer(
      {required this.question, required this.correct, required this.userAns});
}

// ----------------------------------------------------------------
// 2. LOGIC ENGINE
// ----------------------------------------------------------------
// ----------------------------------------------------------------
// YANGILANGAN LOGIC ENGINE (Kombinatsiyalar ko'p va aqlli)
// ----------------------------------------------------------------
class MathEngine {
  final Random _rnd = Random();

  Question generate(String difficulty) {
    // Darajaga qarab zanjir uzunligi va sonlar kattaligi
    int depth = difficulty == 'Oson' ? 1 : (difficulty == 'Qiyin' ? 3 : 2);
    int maxNum = difficulty == 'Oson' ? 10 : (difficulty == 'Qiyin' ? 50 : 20);

    return _generateRecursive(depth, maxNum);
  }

  Question _generateRecursive(int depth, int maxNum) {
    // Boshlang'ich son
    int currentResult = _rnd.nextInt(maxNum) + 2;
    String expression = "$currentResult";

    // Zanjirni qurish (Masalan: 5 -> (5+3) -> ((5+3)*2) )
    for (int i = 0; i < depth; i++) {
      int nextNum = _rnd.nextInt(maxNum) + 2;
      int op = _rnd.nextInt(4); // 0: +, 1: -, 2: *, 3: /

      switch (op) {
        case 0: // Qo'shuv
          currentResult += nextNum;
          expression = "($expression + $nextNum)";
          break;
        case 1: // Ayiruv
          currentResult -= nextNum;
          expression = "($expression - $nextNum)";
          break;
        case 2: // Ko'paytirish
          // Natija juda katta bo'lib ketmasligi uchun kichikroq son
          int smallNum = _rnd.nextInt(5) + 2;
          currentResult *= smallNum;
          expression = "($expression * $smallNum)";
          break;
        case 3: // Bo'lish (Qoldiqsiz bo'lishni ta'minlash)
          int divisor = _rnd.nextInt(5) + 2;
          // Teskari mantiq: natijani ko'paytirib keyin bo'lamiz
          expression = "(${currentResult * divisor} / $divisor)";
          // currentResult o'zgarmaydi, chunki (x*y)/y = x
          break;
      }
    }

    // Qavslarni chiroyli qilish uchun bosh va oxirgi qavsni olib tashlaymiz
    if (expression.startsWith('(') && expression.endsWith(')')) {
      expression = expression.substring(1, expression.length - 1);
    }

    return _build(currentResult, expression);
  }

  Question _build(int res, String txt) {
    Set<int> opts = {res};
    while (opts.length < 4) {
      // Javobga yaqin xato variantlar (Milliardlab kombinatsiyada muhim)
      int offset = _rnd.nextInt(10) + 1;
      int w = res + (_rnd.nextBool() ? offset : -offset);
      if (w != res) opts.add(w);
    }
    return Question(
      text: txt,
      correctAnswer: res,
      options: opts.toList()..shuffle(),
    );
  }
}

// ----------------------------------------------------------------
// 3. UI FOUNDATION
// ----------------------------------------------------------------
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MathMasterApp());
}

class MathMasterApp extends StatelessWidget {
  const MathMasterApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.cyanAccent, brightness: Brightness.dark),
      ),
      home: const MainScreen(),
    );
  }
}

class GlassBox extends StatelessWidget {
  final Widget child;
  final double opacity;
  const GlassBox({super.key, required this.child, this.opacity = 0.1});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------
// 4. SCREENS
// ----------------------------------------------------------------

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.psychology, size: 100, color: Colors.cyanAccent),
              const SizedBox(height: 20),
              const Text("MATH MASTER",
                  style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4)),
              const Text("Miyangizni maksimal darajada ishlating",
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 12)),
              const SizedBox(height: 80),
              _actionBtn(
                  context,
                  "START",
                  () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SetupScreen()))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionBtn(BuildContext context, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: GlassBox(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
          child: Text(label,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
        ),
      ),
    );
  }
}

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});
  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  String _diff = 'O‘rta';
  int _time = 30;
  int _count = 10; // Savollar soni qo'shildi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      appBar: AppBar(
          title: const Text("SOZLAMALAR"), backgroundColor: Colors.transparent),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            _optionTile("QIYINLIK", ['Oson', 'O‘rta', 'Qiyin'], _diff,
                (v) => setState(() => _diff = v)),
            const SizedBox(height: 15),
            _optionTile("VAQT (sekund)", [15, 30, 45], _time,
                (v) => setState(() => _time = v)),
            const SizedBox(height: 15),
            _optionTile("SAVOLLAR SONI", [5, 10, 20], _count,
                (v) => setState(() => _count = v)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black),
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => GameScreen(
                            diff: _diff, time: _time, totalQuestions: _count))),
                child: const Text("O'YINNI BOSHLASH",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _optionTile(
      String title, List opts, dynamic curr, Function(dynamic) onS) {
    return GlassBox(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: opts
                  .map((o) => ChoiceChip(
                        label: Text("$o"),
                        selected: curr == o,
                        onSelected: (_) => onS(o),
                      ))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}

class GameScreen extends StatefulWidget {
  final String diff;
  final int time;
  final int totalQuestions;
  const GameScreen(
      {super.key,
      required this.diff,
      required this.time,
      required this.totalQuestions});
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final MathEngine _engine = MathEngine();
  late Question _q;
  int _currentIndex = 0;
  int _score = 0;
  int _timeLeft = 0;
  Timer? _timer;
  Color _flashColor = Colors.transparent;
  List<WrongAnswer> _wrongAnswersList = [];

  @override
  void initState() {
    super.initState();
    _timeLeft = widget.time;
    _generateNext();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _finish();
      }
    });
  }

  void _generateNext() {
    if (_currentIndex >= widget.totalQuestions) {
      _finish();
    } else {
      _q = _engine.generate(widget.diff);
      _timeLeft = widget.time;
    }
  }

  void _onAnswer(int ans) {
    bool correct = ans == _q.correctAnswer;
    setState(() => _flashColor =
        correct ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2));

    if (correct) {
      _score += 10;
      HapticFeedback.lightImpact();
    } else {
      _wrongAnswersList.add(WrongAnswer(
          question: _q.text, correct: _q.correctAnswer, userAns: ans));
      HapticFeedback.vibrate();
    }

    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _flashColor = Colors.transparent;
          _currentIndex++;
          _generateNext();
        });
      }
    });
  }

  void _finish() {
    _timer?.cancel();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => ResultPage(
                score: _score,
                wrongs: _wrongAnswersList,
                totalQuestions:
                    widget.totalQuestions // Mana shu qismini qo'shing!
                )));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  // GameScreen ichidagi build metodining tegishli qismi:

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: _flashColor,
        child: SafeArea(
          child: Column(
            children: [
              // Yuqori panel (Ball va Vaqt)
              Padding(
                padding: const EdgeInsets.all(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("SAVOL: ${_currentIndex + 1}/${widget.totalQuestions}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    GlassBox(
                      opacity: 0.2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Text(
                            "00:${_timeLeft.toString().padLeft(2, '0')}",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.cyanAccent)),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // SAVOL KONTEYNERI (Siz aytgan qism)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: GlassBox(
                  opacity: 0.15,
                  child: Container(
                    width: double.infinity,
                    height: 180, // Konteyner balandligi barqaror bo'lishi uchun
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 2,
                        )
                      ],
                    ),
                    child: FittedBox(
                      // Matn sig'maganda avtomatik kichrayadi
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _q.text,
                        style: const TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                color: Colors.black54,
                                blurRadius: 10,
                                offset: Offset(2, 2))
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // JAVOBLAR (Tugmalar qatori)
              Padding(
                padding: const EdgeInsets.all(25),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1.3, // Tugmalar proporsiyasini yaxshilaydi
                  children: _q.options.map((o) => _answerBtn(o)).toList(),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _answerBtn(int val) {
    return GestureDetector(
      onTap: () => _onAnswer(val),
      child: GlassBox(
          child: Center(
              child: Text("$val",
                  style: const TextStyle(
                      fontSize: 32, fontWeight: FontWeight.bold)))),
    );
  }
}

// 1. Diagramma chizuvchi maxsus klass (buni ResultPage'dan tashqarida, pastroqda yozib qo'ying)
class StatsPainter extends CustomPainter {
  final double percent;
  StatsPainter(this.percent);

  @override
  void paint(Canvas canvas, Size size) {
    Paint bgPaint = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    Paint progressPaint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, bgPaint);
    double sweepAngle = 2 * 3.1415926535 * (percent / 100);
    canvas.drawArc(Rect.fromLTWH(0, 0, size.width, size.height), -3.1415 / 2,
        sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// 2. Yangilangan ResultPage
class ResultPage extends StatelessWidget {
  final int score;
  final List<WrongAnswer> wrongs;
  final int totalQuestions; // Jami savollar soni qo'shildi

  const ResultPage({
    super.key,
    required this.score,
    required this.wrongs,
    required this.totalQuestions, // Konstruktorga qo'shdik
  });

  void _showWrongs(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => GlassBox(
        opacity: 0.2,
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text("XATOLAR TAHLILI",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent)),
              const Divider(color: Colors.white24),
              Expanded(
                child: ListView.builder(
                  itemCount: wrongs.length,
                  itemBuilder: (context, i) => ListTile(
                    title: Text(wrongs[i].question,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    subtitle: Text(
                        "Siz: ${wrongs[i].userAns} | To'g'ri: ${wrongs[i].correct}",
                        style: const TextStyle(color: Colors.redAccent)),
                    leading: const Icon(Icons.close, color: Colors.red),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Foizni hisoblaymiz
    int correctCount = totalQuestions - wrongs.length;
    double successPercent =
        totalQuestions > 0 ? (correctCount / totalQuestions) * 100 : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F2027),
      body: Center(
        child: GlassBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("O'YIN YAKUNLANDI",
                    style: TextStyle(
                        letterSpacing: 2, fontSize: 14, color: Colors.white60)),
                const SizedBox(height: 25),

                // --- DIAGRAMMA QISMI ---
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      height: 140,
                      child: CustomPaint(painter: StatsPainter(successPercent)),
                    ),
                    Column(
                      children: [
                        Text("${successPercent.toInt()}%",
                            style: const TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold)),
                        const Text("To'g'ri",
                            style: TextStyle(
                                fontSize: 12, color: Colors.cyanAccent)),
                      ],
                    ),
                  ],
                ),
                // -----------------------

                const SizedBox(height: 30),
                Text("$score",
                    style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent)),
                const Text("UMUMIY BALL",
                    style: TextStyle(letterSpacing: 2, fontSize: 12)),

                const SizedBox(height: 30),
                if (wrongs.isNotEmpty)
                  TextButton.icon(
                    onPressed: () => _showWrongs(context),
                    icon: const Icon(Icons.list_alt, color: Colors.cyanAccent),
                    label: const Text("XATOLARNI KO'RISH",
                        style: TextStyle(color: Colors.cyanAccent)),
                  ),

                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onPressed: () =>
                        Navigator.popUntil(context, (r) => r.isFirst),
                    child: const Text("ASOSIY MENYU",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
