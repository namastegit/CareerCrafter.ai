import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/widgets/incoming_chat.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String? assessmentResults;

  const ResultScreen({super.key, this.assessmentResults});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assessment Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Assessment Results:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Display assessment results here
              Center(
                  child: Text(assessmentResults ?? "",
                      style: sfRegular.copyWith(color: Colors.black)))
            ],
          ),
        ),
      ),
    );
  }
}
