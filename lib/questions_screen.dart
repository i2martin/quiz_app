import 'package:flutter/material.dart';
import 'package:quiz_app/data/database_service.dart';
import 'answer_button.dart';
import 'dart:async';
import 'dart:math';

class QuestionsScreen extends StatefulWidget {
  QuestionsScreen(
      {super.key, required this.onSelectAnswer, required this.questions});
  List<Question> questions;
  final void Function(String answer) onSelectAnswer;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final textController = TextEditingController();
  var currentQuestionIndex = 0;
  late Timer _timer;
  late double percentage = 1.0;
  late int questionDuration = 10;
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
        percentage = 1.0 -
            timer.tick /
                widget.questions[currentQuestionIndex].questionDuration;
        if (timer.tick >=
            widget.questions[currentQuestionIndex].questionDuration) {
          timer.cancel();
          answerQuestion("Vrijeme je isteklo.");
        }
      });
    });
  }

  void resetTimer() {
    _timer.cancel();
    setState(() {
      percentage = 1.0;
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
    final currentQuestion = widget.questions[currentQuestionIndex];
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
                    '${widget.questions[currentQuestionIndex].questionDuration - _timer.tick} s',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ]),
            ),
            Builder(builder: (context) {
              if (!currentQuestion.questionText.contains('\\n')) {
                currentQuestion.questionText.replaceAll('\\\\', '\\');
                return Text(
                  currentQuestion.questionText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              } else {
                return Text(
                  currentQuestion.questionText
                      .replaceAll('\\n', '\n')
                      .replaceAll('\\t', '\t')
                      .replaceAll('\\\\', '\\'),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            }),
            const SizedBox(height: 30),
            ...generateAnswers(currentQuestion),
            /*...currentQuestion
                .shuffleQuestionAnswers(currentQuestionIndex)
                .map((item) {
              return AnswerButton(
                answerText: item,
                onTap: () {
                  answerQuestion(item);
                },
              );
            }),*/
          ],
        ),
      ),
    );
  }

  List<Widget> generateAnswers(Question question) {
    List<Widget> widgetAnswers = [];
    if (question.questionType == "MC") {
      List<String> shuffledAnswers =
          question.shuffleQuestionAnswers(currentQuestionIndex);
      for (var answer in shuffledAnswers) {
        widgetAnswers.add(AnswerButton(
          answerText: answer,
          onTap: () {
            answerQuestion(answer);
          },
        ));
      }
    } else {
      widgetAnswers.add(
        TextField(
          controller: textController,
          autofocus: true,
          cursorColor: Colors.white,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFF826DF5),
            focusColor: Color(0xFF826DF5),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFF826DF5),
              ),
            ),
            //border: OutlineInputBorder(),
          ),
        ),
      );
      widgetAnswers.add(AnswerButton(
          answerText: "Spremi",
          onTap: () {
            textController.text != ""
                ? answerQuestion(textController.text)
                : answerQuestion("Nije odgovoreno.");
            textController.text = "";
          }));
    }
    return widgetAnswers;
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
