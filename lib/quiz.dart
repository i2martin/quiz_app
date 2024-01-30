import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiz_app/data/database_service.dart';
import 'package:quiz_app/questions_screen.dart';
import 'package:quiz_app/results_screen.dart';
import 'start_screen.dart';
import 'package:quiz_app/models/data_models.dart';

class Quiz extends StatefulWidget {
  final List<Map<String, dynamic>> questions = List.empty();

  Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  Widget? activeScreen;
  List<String> selectedAnswers = [];
  List<Question> newQuestions = [];

  @override
  void initState() {
    activeScreen = StartScreen(switchScreen);
    super.initState();
  }

  void chooseAnswer(String answer) {
    selectedAnswers.add(answer);
    if (selectedAnswers.length == newQuestions.length) {
      setState(() {
        activeScreen = ResultsScreen(
          chosenAnswers: selectedAnswers,
          questions: newQuestions,
          restartQuiz: restartQuiz,
        );
        selectedAnswers = [];
      });
    }
  }

  void restartQuiz() {
    setState(() {
      activeScreen = StartScreen(switchScreen);
    });
  }

  void switchScreen(String category, String subcategory,
      bool isShortAnswerTypeChecked) async {
    newQuestions = await DatabaseHelper.getQuestionsByCategoryAndSubcategory(
      category,
      subcategory,
      isShortAnswerTypeChecked,
    );

    setState(() {
      newQuestions = newQuestions;
      activeScreen = QuestionsScreen(
          onSelectAnswer: chooseAnswer, questions: newQuestions);
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      theme: ThemeData(
        unselectedWidgetColor: Colors.white,
        fontFamily: GoogleFonts.montserrat().fontFamily,
        textTheme: Typography.whiteCupertino,
      ),
      home: Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF78B2D7), Color(0xFFB593E9)]),
            ),
            child: activeScreen),
      ),
    );
  }
}
