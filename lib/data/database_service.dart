import 'dart:io';
import 'dart:typed_data';

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

  static Future<List<Question>> getQuestionsByCategoryAndSubcategory(
    String categoryName,
    String subcategoryName,
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
    List<Map<String, dynamic>> queryResults = await db.query(
      'Questions',
      where: 'categoryId = ? AND subcategoryId = ?',
      whereArgs: [categoryId, subcategoryId],
    );

    // Map results to instances of the Question class
    List<Question> questions =
        queryResults.map((map) => Question.fromMap(map)).toList();

    return questions;
  }

  static Future<Database> initDatabase() async {
    // Get the path to the database on the device
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'questions.db');

    // Check if the database exists
    bool exists = await databaseExists(path);

    if (!exists) {
      // If it doesn't exist, copy the database from the assets
      ByteData data =
          await rootBundle.load(join('assets', 'data', 'questions.db'));
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
  int categoryId;
  int subcategoryId;

  Question({
    required this.questionId,
    required this.questionText,
    required this.questionAnswers,
    required this.correctAnswer,
    required this.questionType,
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
      categoryId: map['categoryId'],
      subcategoryId: map['subcategoryId'],
    );
  }
}
