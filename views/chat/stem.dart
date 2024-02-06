import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../home/home_screen.dart';

class StemQuestionAnswer extends StatefulWidget {
  const StemQuestionAnswer({super.key});

  @override
  State<StemQuestionAnswer> createState() => _StemQuestionAnswerState();
}

class _StemQuestionAnswerState extends State<StemQuestionAnswer> {
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(
            child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                "assets/success.json",
                height: 100,
                width: 200,
              ),
              Text(
                message,
                textAlign: TextAlign.left,
                style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontSize: 12),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    title: "Okay",
                    onTap: () {
                      Get.back();
                      Get.back();
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        actions: const [],
      ),
    );
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Emotional Intelligence Questions',
          style: sfBold.copyWith(fontSize: 17),
        ),
      ),
      body: GetBuilder<AnswerProvider>(
          init: AnswerProvider(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.emotionalIntelligenceQuestions.length,
                    itemBuilder: (context, index) {
                      final question =
                          controller.emotionalIntelligenceQuestions[index];
                      return QuestionWidget(
                        index: index,
                        question: question.question,
                        options: question.options,
                        selectedOption: controller.getAnswer(index),
                        onChanged: (value) {
                          controller.setAnswer(index, value);
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: AppButton(
                        title: "Submit",
                        isLoading: _isLoading,
                        onTap: () async {
                          _isLoading = true;
                          setState(() {});
                          await Future.delayed(const Duration(seconds: 5));
                          _isLoading = false;
                          setState(() {});
                          _showDialog('Your EQ Result is 71',
                              'EQ assessments, \n\nBelow Average: Scores below 30-35 might be considered below average, indicating that there may be room for improvement in understanding and managing emotions effectively.\n\nAverage: Scores in the range of 30-70 are often considered within the average range, suggesting that the individual possesses a reasonable level of emotional intelligence. There may be areas where they excel, and others where they could improve.\n\nAbove Average: Scores above 70 are generally considered above average or high, indicating a strong ability to understand and manage emotions effectively.');
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
    );
  }
}

class QuestionWidget extends StatelessWidget {
  final String question;
  final int index;
  final List<String> options;
  final String? selectedOption;
  final ValueChanged<String?> onChanged;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.index,
    required this.options,
    required this.selectedOption,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "${index + 1}.  $question",
              style: sfBold.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Column(
              children: options.map((option) {
                final optionKey = Key('$index-$option');
                return RadioListTile(
                  key: optionKey,
                  title: Text(
                    option,
                    style: sfRegular.copyWith(fontSize: 15),
                  ),
                  value: option,
                  activeColor: Theme.of(context).primaryColor,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    onChanged(value);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class AnswerProvider extends GetxController {
  List<String?> _answers = [];

  List<StemModel> emotionalIntelligenceQuestions = [
    StemModel(
      question:
          "Wai-Hin and Connie have shared an office for years but Wai-Hin gets a new job and Connie loses contact with her. What action would be the most effective for Connie?",
      options: [
        "Just accept that she is gone and the friendship is over.",
        "Ring Wai-Hin and ask her out for lunch or coffee to catch up.",
        "Contact Wai-Hin and arrange to catch up but also make friends with her replacement.",
        "Spend time getting to know the other people in the office, and strike up new friendships.",
      ],
    ),
    StemModel(
      question:
          "Manual is only a few years from retirement when he finds out his position will no longer exist, although he will still have a job with a less prestigious role. What action would be the most effective for Manual?",
      options: [
        "Carefully consider his options and discuss it with his family.",
        "Talk to his boss or the management about it.",
        "Accept the situation, but still feel bitter about it.",
        "Walk out of that job.",
      ],
    ),
    StemModel(
      question:
          "Surbhi starts a new job where he doesn’t know anyone and finds that no one is particularly friendly. What action would be the most effective for Surbhi?",
      options: [
        "Have fun with his friends outside of work hours.",
        "Concentrate on doing his work well at the new job.",
        "Make an effort to talk to people and be friendly himself.",
        "Leave the job and find one with a better environment.",
      ],
    ),
    StemModel(
      question:
          "Andre moves away from the city his friends and family are in. He finds his friends make less effort to keep in contact than he thought they would. What action would be the most effective for Andre?",
      options: [
        "Try to adjust to life in the new city by joining clubs and activities there.",
        "He should make the effort to contact them, but also try to meet people in his new city.",
        "Let go of his old friends, who have shown themselves to be unreliable.",
        "Tell his friends he is disappointed in them for not contacting him.",
      ],
    ),
    StemModel(
      question:
          "Clayton has been overseas for a long time and returns to visit his family. So much has changed that Clayton feels left out. What action would be the most effective for Clayton?",
      options: [
        "Nothing – it will sort itself out soon enough.",
        "Tell his family he feels left out.",
        "Spend time listening and getting involved again.",
        "Reflect that relationships can change with time.",
      ],
    ),
    StemModel(
      question:
          "Daniel has been accepted for a prestigious position in a different country from his family, who he is close to. He and his wife decide it is worth relocating. What action would be the most effective for Daniel?",
      options: [
        "Realize he shouldn’t have applied for the job if he didn’t want to leave.",
        "Set up a system for staying in touch, like weekly phone calls or emails.",
        "Think about the great opportunities this change offers.",
        "Don’t take the position.",
      ],
    ),
    StemModel(
      question:
          "Mei Ling answers the phone and hears that close relatives are in hospital critically ill. What action would be the most effective for Mei Ling?",
      options: [
        "Let herself cry and express emotion for as long as she feels like.",
        "Speak to other family to calm herself and find out what is happening, then visit the hospital.",
        "There is nothing she can do.",
        "Visit the hospital and ask staff about their condition.",
      ],
    ),
    StemModel(
      question:
          "Shona has not spoken to her nephew for months, whereas when he was younger they were very close. She rings him but he can only talk for five minutes. What action would be the most effective for Shona?",
      options: [
        "Realize that he is growing up and might not want to spend so much time with his family anymore.",
        "Make plans to drop by and visit him in person and have a good chat.",
        "Understand that relationships change, but keep calling him from time to time.",
        "Be upset about it, but realize there is nothing she can do.",
      ],
    ),
    StemModel(
      question:
          "Surbhi starts a new job where he doesn’t know anyone and finds that no one is particularly friendly. What action would be the most effective for Surbhi?",
      options: [
        "Have fun with his friends outside of work hours.",
        "Concentrate on doing his work well at the new job.",
        "Make an effort to talk to people and be friendly himself.",
        "Leave the job and find one with a better environment.",
      ],
    ),
    StemModel(
      question:
          "Mina and her sister-in-law normally get along quite well, and the sister-in-law regularly babysits for her for a small fee. Lately she has also been cleaning away cobwebs, commenting on the mess, which Mina finds insulting. What action would be the most effective for Mina?",
      options: [
        "Tell her sister-in-law these comments upset her.",
        "Get a new babysitter.",
        "Be grateful her house is being cleaned for free.",
        "Tell her only to babysit, not to clean.",
      ],
    ),
    StemModel(
      question:
          "Juno is fairly sure his company is going down and his job is under threat. It is a large company and nothing official has been said. What action would be the most effective for Juno?",
      options: [
        "Find out what is happening and discuss his concerns with his family.",
        "Try to keep the company afloat by working harder.",
        "Start applying for other jobs.",
        "Think of these events as an opportunity for a new start.",
      ],
    ),
    StemModel(
      question:
          "Mallory moves from a small company to a very large one, where there is little personal contact, which she misses. What action would be the most effective for Mallory?",
      options: [
        "Talk to her workmates, try to create social contacts and make friends.",
        "Start looking for a new job so she can leave that environment.",
        "Just give it time, and things will be okay.",
        "Concentrate on her outside-work friends and colleagues from previous jobs.",
      ],
    ),
    StemModel(
      question:
          "Reece’s friend points out that her young children seem to be developing more quickly than Reece's. Reece sees that this is true. What action would be the most effective for Reece?",
      options: [
        "Talk the issue over with another friend.",
        "Angrily confront her friend about making such statements.",
        "Realize that children develop at different rates.",
        "Talk to a doctor about what the normal rates of development are.",
      ],
    ),
    StemModel(
      question:
          "Reece’s friend points out that her young children seem to be developing more quickly than Reece's. Reece sees that this is true. What action would be the most effective for Reece?",
      options: [
        "Talk the issue over with another friend.",
        "Angrily confront her friend about making such statements.",
        "Realize that children develop at different rates.",
        "Talk to a doctor about what the normal rates of development are.",
      ],
    ),
    StemModel(
      question:
          "Jumah has been working at a new job part-time while he studies. His shift times for the week are changed at the last minute, without consulting him. What action would be the most effective for Jumah?",
      options: [
        "Refuse to work the new shifts.",
        "Find out if there is some reasonable explanation for the shift changes.",
        "Tell the manager in charge of shifts that he is not happy about it.",
        "Grumpily accept the changes and do the shifts.",
      ],
    ),
    StemModel(
      question:
          "Julie hasn’t seen Ka for ages and looks forward to their weekend trip away. However, Ka has changed a lot and Julie finds that she is no longer an interesting companion. What action would be the most effective for Julie?",
      options: [
        "Cancel the trip and go home.",
        "Realize that it is time to give up the friendship and move on.",
        "Understand that people change, so move on, but remember the good times.",
        "Concentrate on her other, more rewarding friendships.",
      ],
    ),
    StemModel(
      question:
          "Reece’s friend points out that her young children seem to be developing more quickly than Reece's. Reece sees that this is true. What action would be the most effective for Reece?",
      options: [
        "Talk the issue over with another friend.",
        "Angrily confront her friend about making such statements.",
        "Realize that children develop at different rates.",
        "Talk to a doctor about what the normal rates of development are.",
      ],
    ),
    StemModel(
      question:
          "Mina and her sister-in-law normally get along quite well, and the sister-in-law regularly babysits for her for a small fee. Lately she has also been cleaning away cobwebs, commenting on the mess, which Mina finds insulting. What action would be the most effective for Mina?",
      options: [
        "Tell her sister-in-law these comments upset her.",
        "Get a new babysitter.",
        "Be grateful her house is being cleaned for free.",
        "Tell her only to babysit, not to clean.",
      ],
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _answers = List.filled(emotionalIntelligenceQuestions.length, null);
  }

  List<String?> get answers => _answers;

  String? getAnswer(int? question) {
    return _answers[question!];
  }

  void setAnswer(int index, String? value) {
    _answers[index] = (value);
    update();
  }
}
