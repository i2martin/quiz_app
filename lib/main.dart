import 'package:flutter/material.dart';
import 'package:quiz_app/quiz.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((fn) {
    runApp(
      const Quiz(),
    );
  });
}
