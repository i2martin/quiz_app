import 'package:flutter/material.dart';

class QuestionsSummary extends StatelessWidget {
  final List<Map<String, Object>> summaryData;

  @override
  const QuestionsSummary({super.key, required this.summaryData});

  @override
  Widget build(context) {
    return SizedBox(
      height: 400,
      child: SingleChildScrollView(
        child: Column(
          children: [
            ...summaryData.map((data) {
              Color color;
              (data['chosen_answer'] == data['correct_answer'])
                  ? color = const Color.fromARGB(255, 113, 192, 134)
                  : color = const Color.fromARGB(255, 223, 123, 123);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      ((data['question_index'] as int) + 1).toString(),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsetsDirectional.only(end: 10),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['question'].toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          data['correct_answer'].toString(),
                          style: const TextStyle(
                            color: Color.fromARGB(255, 73, 157, 95),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          data['chosen_answer'].toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: (data['chosen_answer'] ==
                                    data['correct_answer'])
                                ? color = const Color.fromARGB(255, 73, 157, 95)
                                : color =
                                    const Color.fromARGB(255, 196, 95, 95),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
