import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  StartScreen(this.startQuiz, {super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
  final void Function() startQuiz;

  List<String> categories = [
    "Matematika",
    "Hrvatski jezik",
    "Engleski jezik",
    "Matematika",
    "Hrvatski jezik",
    "Engleski jezik",
    "Matematika",
    "Hrvatski jezik",
    "Engleski jezik",
    "Matematika",
    "Hrvatski jezik",
    "Engleski jezik"
  ];
  bool isTrueFalseTypeChecked = false;
  bool isDropdownTypeChecked = false;
  bool isShortAnswerTypeChecked = false;
  bool isProblemSolvingTypeChecked = false;
}

class _StartScreenState extends State<StartScreen> {
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
            SingleChildScrollView(
              child: DropdownMenu<String>(
                dropdownMenuEntries: widget.categories
                    .map((item) =>
                        DropdownMenuEntry<String>(value: item, label: item))
                    .toList(),
                enableSearch: true,
                initialSelection: widget.categories[0],
              ),
            ),
            CheckboxListTile(
                title: const Text("Zadaci višestrukog odabira"),
                value: widget.isDropdownTypeChecked,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isDropdownTypeChecked = value!;
                  });
                }),
            CheckboxListTile(
                title: const Text("Točno/Netočno zadaci"),
                value: widget.isTrueFalseTypeChecked,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isTrueFalseTypeChecked = value!;
                  });
                }),
            CheckboxListTile(
                title: const Text("Zadaci kratkog odgovora"),
                value: widget.isShortAnswerTypeChecked,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isShortAnswerTypeChecked = value!;
                  });
                }),
            CheckboxListTile(
                title: const Text("Problemski zadaci"),
                value: widget.isProblemSolvingTypeChecked,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isProblemSolvingTypeChecked = value!;
                  });
                }),
            OutlinedButton.icon(
              icon: const Icon(
                Icons.arrow_right_alt,
              ),
              onPressed: () {
                widget.startQuiz();
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
