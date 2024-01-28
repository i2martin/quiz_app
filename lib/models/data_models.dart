import 'dart:typed_data';

class Question {
  int questionId;
  String questionText;
  String questionAnswers;
  String correctAnswer;
  String questionType;
  int questionDuration;
  int categoryId;
  int subcategoryId;
  Uint8List questionImage;

  Question({
    required this.questionId,
    required this.questionText,
    required this.questionAnswers,
    required this.correctAnswer,
    required this.questionType,
    required this.questionDuration,
    required this.categoryId,
    required this.subcategoryId,
    required this.questionImage,
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
      questionImage: map['questionImage'] != null
          ? Uint8List.fromList(map['questionImage'])
          : Uint8List(0),
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
