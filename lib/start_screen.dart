import 'package:flutter/material.dart';
import 'package:quiz_app/data/database_service.dart';
import 'package:quiz_app/subcategory_menu.dart';
import 'package:quiz_app/models/data_models.dart';

class StartScreen extends StatefulWidget {
  StartScreen(this.startQuiz, {super.key});
  List<Subcategory> subcategories = [];
  List<Category> categories = [];
  bool isShortAnswerTypeChecked = false;
  @override
  State<StartScreen> createState() => _StartScreenState();
  final void Function(
      String category, String subcategory, bool isShortAnswerChecked) startQuiz;
}

class _StartScreenState extends State<StartScreen> {
  String selectedCategory = "";
  String selectedSubcategory = "";
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

  void updateSelectedCategory(String cat) {
    setState(() {
      selectedCategory = cat;
    });
  }

  void updateSelectedSubcategory(String subcat) {
    setState(() {
      selectedSubcategory = subcat;
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
                  selectedCategory = category!;
                  getSubcategories(category);
                },
              ),
            ),
            SubcategoryMenu(
              subcategories: widget.subcategories,
              updateSubcategory: updateSelectedSubcategory,
            ),
            CheckboxListTile(
                title: const Text("Zadaci kratkog odgovora"),
                value: widget.isShortAnswerTypeChecked,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isShortAnswerTypeChecked = value!;
                  });
                }),
            OutlinedButton.icon(
              icon: const Icon(
                Icons.arrow_right_alt,
              ),
              onPressed: () {
                if (selectedCategory.isNotEmpty &&
                    selectedSubcategory.isNotEmpty) {
                  widget.startQuiz(selectedCategory, selectedSubcategory,
                      widget.isShortAnswerTypeChecked);
                }
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
