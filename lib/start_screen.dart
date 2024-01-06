import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.startQuiz, {super.key});

  final void Function() startQuiz;
  @override
  Widget build(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/quiz-logo.png',
              width: 200,
              color: const Color.fromARGB(80, 255, 255, 255),
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Kao što kviz testira tvoje znanje, tako i ponavljanje jača tvoj um – zato, ponavljaj i briljiraj!',
              textAlign: TextAlign.center,
              style: TextStyle(
                height: 1.5,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            OutlinedButton.icon(
              icon: const Icon(
                Icons.arrow_right_alt,
              ),
              onPressed: () {
                startQuiz();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              label: const Text('Započni kviz!'),
            ),
          ],
        ),
      ),
    );
  }
}
