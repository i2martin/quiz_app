import 'dart:io';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:quiz_app/models/data_models.dart';

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
    String path = join(databasesPath, 'questions_db_test.db');

    // Check if the database exists
    bool exists = await databaseExists(path);

    if (!exists) {
      // If it doesn't exist, copy the database from the assets
      ByteData data = await rootBundle
          .load(join('assets', 'data', 'test', 'questions_db_test.db'));
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
