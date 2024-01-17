import 'package:flutter/material.dart';
import 'package:quiz_app/data/database_service.dart';
import 'package:quiz_app/subcategory_menu.dart';

class StartScreen extends StatefulWidget {
  StartScreen(this.startQuiz, {super.key});
  List<Subcategory> subcategories = [];
  List<Category> categories = [];
  @override
  State<StartScreen> createState() => _StartScreenState();
  final void Function() startQuiz;
  bool isTrueFalseTypeChecked = false;
  bool isDropdownTypeChecked = false;
  bool isShortAnswerTypeChecked = false;
  bool isProblemSolvingTypeChecked = false;
}

class _StartScreenState extends State<StartScreen> {
  @override
  void initState() {
    getCategories();
    super.initState();
  }

  void getSubcategories(String category) async {
    widget.subcategories = await DatabaseHelper.getAllSubcategories(category);
    setState(() {
      widget.subcategories = widget.subcategories;
    });
  }

  void getCategories() async {
    widget.categories = await DatabaseHelper.getAllCategories();
    setState(() {
      widget.categories = widget.categories;
    });
  }

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
                menuHeight: 200,
                dropdownMenuEntries: widget.categories
                    .map((item) => DropdownMenuEntry<String>(
                        value: item.category, label: item.category))
                    .toList(),
                enableSearch: true,
                enableFilter: true,
                label: const Text("Kategorija"),
                initialSelection: "",
                width: 250,
                onSelected: (String? category) {
                  getSubcategories(category!);
                },
              ),
            ),
            SubcategoryMenu(subcategories: widget.subcategories),
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
