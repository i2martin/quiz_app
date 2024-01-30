import 'package:flutter/material.dart';
import 'package:quiz_app/models/data_models.dart';
import 'answer_button.dart';
import 'dart:async';
import 'custom_painter.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen(
      {super.key, required this.onSelectAnswer, required this.questions});
  final List<Question> questions;
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
                return Text(
                  currentQuestion.questionText.replaceAll('\\\\', ''),
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
                      .replaceAll('\\\\', ''),
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }
            }),
            Builder(builder: (context) {
              if (currentQuestion.questionImage.isNotEmpty) {
                return Image(
                  image: Image.memory(currentQuestion.questionImage).image,
                  height: 100,
                );
              } else {
                return const SizedBox(
                  height: 1,
                );
              }
            }),
            const SizedBox(height: 30),
            ...generateAnswers(currentQuestion).expand(
              (cq) => [
                cq,
                const Padding(
                  padding: EdgeInsets.all(3),
                )
              ].toList(),
            ),
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
