import 'package:flutter/material.dart';
import 'package:quiz_app/models/data_models.dart';
import 'package:quiz_app/questions_summary.dart';

class ResultsScreen extends StatelessWidget {
  @override
  const ResultsScreen(
      {super.key,
      required this.chosenAnswers,
      required this.restartQuiz,
      required this.questions});

  final List<String> chosenAnswers;
  final List<Question> questions;
  final void Function() restartQuiz;
  List<Map<String, Object>> getSummaryData() {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswers.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].questionText,
        'correct_answer': questions[i].correctAnswer,
        'chosen_answer': chosenAnswers[i],
      });
    }
    return summary;
  }

  @override
  Widget build(context) {
    final summaryData = getSummaryData();
    final numOfQuestions = questions.length;
    final numOfCorrectQuestions = summaryData.where((data) {
      return data['chosen_answer'] == data['correct_answer'];
    }).length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Točno ste odgovorili na $numOfCorrectQuestions od $numOfQuestions pitanja!',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionsSummary(
              summaryData: getSummaryData(),
            ),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton.icon(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                restartQuiz();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              label: const Text(
                'Povratak',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
