import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;

    // If the database does not exist, copy it from the assets folder
    _database = await initDatabase();
    return _database!;
  }

  static Future<List<Map<String, dynamic>>> getAllQuestions() async {
    final Database db = await database;
    return await db.query('Questions');
  }

  static Future<List<Category>> getAllCategories() async {
    final Database db = await database;
    List<Map<String, dynamic>> queryResults = await db.query('Categories');
    return queryResults.map((map) => Category.fromMap(map)).toList();
  }

  static Future<List<Subcategory>> getAllSubcategories(String category) async {
    final Database db = await database;
    //find ID of selected category
    List<Map<String, dynamic>> queryResults = await db.query(
      'Categories',
      where: 'category=?',
      whereArgs: [category],
    );
    int categoryId = queryResults.first['categoryId'];
    //find all subcategories that belong to same category
    queryResults = await db.query(
      'Subcategories',
      where: 'categoryId = ?',
      whereArgs: [categoryId],
    );
    return queryResults.map((map) => Subcategory.fromMap(map)).toList();
  }

  static Future<List<Question>> getQuestionsByCategoryAndSubcategory(
    String categoryName,
    String subcategoryName,
    bool isShortAnswerTypeChecked,
  ) async {
    final Database db = await database;

    // Fetch the category and subcategory IDs based on names
    List<Map<String, dynamic>> categoryResult = await db.query(
      'Categories',
      where: 'category = ?',
      whereArgs: [categoryName],
    );

    List<Map<String, dynamic>> subcategoryResult = await db.query(
      'Subcategories',
      where: 'subcategory = ?',
      whereArgs: [subcategoryName],
    );

    if (categoryResult.isEmpty || subcategoryResult.isEmpty) {
      // Handle the case where the category or subcategory doesn't exist
      return [];
    }

    int categoryId = categoryResult.first['categoryId'];
    int subcategoryId = subcategoryResult.first['subcategoryId'];

    // Retrieve questions based on the fetched category and subcategory IDs
    List<Map<String, dynamic>> queryResults;
    if (isShortAnswerTypeChecked == true) {
      queryResults = await db.query(
        'Questions',
        where: 'categoryId = ? AND subcategoryId = ?',
        whereArgs: [categoryId, subcategoryId],
      );
    } else {
      String questionType = "MC";
      queryResults = await db.query(
        'Questions',
        where: 'categoryId = ? AND subcategoryId = ? AND questionType=?',
        whereArgs: [categoryId, subcategoryId, questionType],
      );
    }
    // Map results to instances of the Question class
    List<Question> questions =
        queryResults.map((map) => Question.fromMap(map)).toList();

    //shuffle questions and display random 15 questions
    questions.shuffle();
    questions.removeRange(15, questions.length);
    return questions;
  }

  static Future<Database> initDatabase() async {
    // Get the path to the database on the device
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'questions_database_test.db');

    // Check if the database exists
    bool exists = await databaseExists(path);

    if (!exists) {
      // If it doesn't exist, copy the database from the assets
      ByteData data = await rootBundle
          .load(join('assets', 'data', 'test', 'questions_database_test.db'));
      List<int> bytes = data.buffer.asUint8List();
      await File(path).writeAsBytes(bytes);
    }

    // Open the database
    return await openDatabase(
      path,
      version: 1,
      singleInstance: true,
    );
  }
}

class Question {
  int questionId;
  String questionText;
  String questionAnswers;
  String correctAnswer;
  String questionType;
  int questionDuration;
  int categoryId;
  int subcategoryId;

  Question({
    required this.questionId,
    required this.questionText,
    required this.questionAnswers,
    required this.correctAnswer,
    required this.questionType,
    required this.questionDuration,
    required this.categoryId,
    required this.subcategoryId,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      questionId: map['questionId'],
      questionText: map['questionText'],
      questionAnswers: map['questionAnswers'],
      correctAnswer: map['correctAnswer'],
      questionType: map['questionType'],
      questionDuration: map['questionDuration'],
      categoryId: map['categoryId'],
      subcategoryId: map['subcategoryId'],
    );
  }

  List<String> _alreadyShuffledAnswers = List.empty();
  int _cQuestionIndex = -1;

  List<String> shuffleQuestionAnswers(int questionIndex) {
    if (_cQuestionIndex != questionIndex) {
      //question has changed --> needs to shuffle
      final List<String> shuffledList = [];
      List<String> answers = questionAnswers.split(',');
      for (int i = 0; i < answers.length; i++) {
        shuffledList.add(answers[i]);
      }
      shuffledList.shuffle();
      _alreadyShuffledAnswers = shuffledList;
      _cQuestionIndex = questionIndex;
      return shuffledList;
    } else {
      return _alreadyShuffledAnswers;
    }
  }
}

class Category {
  int categoryId;
  String category;

  Category({
    required this.categoryId,
    required this.category,
  });

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      categoryId: map['categoryId'],
      category: map['category'],
    );
  }
}

class Subcategory {
  int subcategoryId;
  int categoryId;
  String subcategory;

  Subcategory({
    required this.subcategoryId,
    required this.categoryId,
    required this.subcategory,
  });

  factory Subcategory.fromMap(Map<String, dynamic> map) {
    return Subcategory(
      subcategoryId: map['subcategoryId'],
      categoryId: map['categoryId'],
      subcategory: map['subcategory'],
    );
  }
}
