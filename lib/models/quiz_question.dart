class QuizQuestion {
  QuizQuestion(this.questionText, this.questionAnswers);

  final String questionText;
  final List<String> questionAnswers;
  List<String> _alreadyShuffledAnswers = List.empty();
  int _cQuestionIndex = -1;

  List<String> shuffleQuestionAnswers(int questionIndex) {
    if (_cQuestionIndex != questionIndex) {
      //question has changed --> needs to shuffle
      final shuffledList = List.of(questionAnswers);
      shuffledList.shuffle();
      _alreadyShuffledAnswers = shuffledList;
      _cQuestionIndex = questionIndex;
      return shuffledList;
    } else {
      return _alreadyShuffledAnswers;
    }
    /*final shuffledList = List.of(questionAnswers);
    shuffledList.shuffle();
    return shuffledList;*/
  }
}
