class QuizQuestion {
  const QuizQuestion(this.questionText, this.questionAnswers);

  final String questionText;
  final List<String> questionAnswers;

  List<String> shuffleQuestionAnswers() {
    final shuffledList = List.of(questionAnswers);
    shuffledList.shuffle();
    return shuffledList;
  }
}
