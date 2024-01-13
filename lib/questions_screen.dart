import 'package:flutter/material.dart';
import 'answer_button.dart';
import 'package:quiz_app/data/questions.dart';
import 'dart:async';
import 'dart:math';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key, required this.onSelectAnswer});

  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;
  late Timer _timer;
  late double percentage = 1.0;
  late int questionDuration = 10;
  int index = -1;
  void answerQuestion(String selectedAnswer) {
    widget.onSelectAnswer(selectedAnswer);
    setState(() {
      resetTimer();
      currentQuestionIndex++;
    });
  }

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  void startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      setState(() {
        percentage = timer.tick / questionDuration;
        if (timer.tick >= questionDuration) {
          timer.cancel();
          answerQuestion("Vrijeme je isteklo.");
        }
      });
    });
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      percentage = 0.0;
    });
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(context) {
    final currentQuestion = questions[currentQuestionIndex];
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(children: [
                Positioned.fill(
                    child: CustomPaint(
                  painter: TimerPainter(percentage: percentage),
                )),
                Center(
                  child: Text(
                    '${questionDuration - _timer.tick} s',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
            Text(
              currentQuestion.questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ...currentQuestion
                .shuffleQuestionAnswers(currentQuestionIndex)
                .map((item) {
              index = currentQuestionIndex;
              return AnswerButton(
                answerText: item,
                onTap: () {
                  answerQuestion(item);
                },
              );
            })
          ],
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double percentage;

  TimerPainter({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color.fromARGB(0, 193, 193, 193)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 4, size.height / 4);

    canvas.drawCircle(center, radius, paint);

    final progressPaint = Paint()
      ..color = const Color(0xFF826DF5)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;

    final sweepAngle = 2 * pi * percentage;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
