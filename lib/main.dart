import 'package:flutter/material.dart';
import 'package:quiz_app/data/database_service.dart';
import 'package:quiz_app/quiz.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.initDatabase();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(
      Quiz(),
    );
  });
}
