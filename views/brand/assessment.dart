import 'package:ai_story_maker/controllers/chat_Controller.dart';
import 'package:ai_story_maker/controllers/firebase_controller.dart';
import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class CareerAssessmentScreen extends StatefulWidget {
  const CareerAssessmentScreen({super.key});

  @override
  _CareerAssessmentScreenState createState() => _CareerAssessmentScreenState();
}

class _CareerAssessmentScreenState extends State<CareerAssessmentScreen> {
  // List<Map<String, dynamic>> careerAssessmentQuestions = [
  //   {
  //     "question": "On a scale of 1 to 5, how interested are you in Chemistry?",
  //     "type": "rating",
  //     "scale": 5,
  //   },
  //   {
  //     "question":
  //         "On a scale of 1 to 5, how interested are you in Mathematics?",
  //     "type": "rating",
  //     "scale": 5,
  //   },
  //   {
  //     "question":
  //         "What other subjects or areas of study in the Science stream do you find intriguing?",
  //     "type": "text",
  //   },
  //   {
  //     "question":
  //         "What extracurricular activities are you actively involved in?",
  //     "type": "text",
  //   },
  //   {
  //     "question": "On a scale of 1 to 5, how passionate are you about singing?",
  //     "type": "rating",
  //     "scale": 5,
  //   },
  //   {
  //     "question": "On a scale of 1 to 5, how passionate are you about dancing?",
  //     "type": "rating",
  //     "scale": 5,
  //   },
  //   {
  //     "question": "What do you enjoy most about singing and dancing?",
  //     "type": "text",
  //   },
  //   {
  //     "question": "Are you a good problem solver?",
  //     "type": "boolean",
  //   },
  //   {
  //     "question":
  //         "Do you enjoy analyzing data or solving mathematical problems?",
  //     "type": "boolean",
  //   },
  //   {
  //     "question": "Are you a creative thinker?",
  //     "type": "boolean",
  //   },
  //   {
  //     "question":
  //         "How do you feel when you solve a complex chemistry or math problem?",
  //     "type": "text",
  //   },
  //   {
  //     "question":
  //         "Do you enjoy reading books, and if so, what genre or topics do you prefer?",
  //     "type": "text",
  //   },
  //   {
  //     "question":
  //         "What career aspirations or goals do you have for the future?",
  //     "type": "text",
  //   },
  //   {
  //     "question":
  //         "Do you see yourself pursuing a career that combines your interests in science, math, and the arts?",
  //     "type": "boolean",
  //   },
  //   {
  //     "question": "Do you enjoy collaborating with others on projects?",
  //     "type": "boolean",
  //   },
  //   {
  //     "question":
  //         "Have you ever participated in group performances or presentations?",
  //     "type": "boolean",
  //   },
  //   {
  //     "question": "How do you feel about working in a team?",
  //     "type": "text",
  //   },
  //   {
  //     "question":
  //         "Would you prefer a career in a laboratory, academic setting, or a more creative environment?",
  //     "type": "text",
  //   },
  //   {
  //     "question": "What type of work environment do you thrive in?",
  //     "type": "text",
  //   },
  // ];

  Map<int, dynamic> responses =
      {}; // Store responses with question index as the key

  int currentQuestionIndex = 0;

  void recordResponse(dynamic response) {
    responses[currentQuestionIndex] = response;
  }

  void goToNextQuestion() {
    if (currentQuestionIndex <
        chatController.careerAssessmentQuestions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  ChatController chatController = Get.put(ChatController());
  FirebaseController firebaseController = Get.put(FirebaseController());
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseController.getStudentData();
      chatController.generateAssesmentChatSession(false);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Career Assessment', style: sfBold),
      ),
      body: GetBuilder<ChatController>(
          init: ChatController(),
          builder: (controller) {
            return controller.resultLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Stepper(
                          physics: const NeverScrollableScrollPhysics(),
                          currentStep: currentQuestionIndex,
                          onStepContinue: () {
                            if (currentQuestionIndex <
                                chatController
                                        .careerAssessmentQuestions.length -
                                    1) {
                              goToNextQuestion();
                            }
                          },
                          onStepCancel: () {
                            if (currentQuestionIndex > 0) {
                              goToPreviousQuestion();
                            }
                          },
                          steps: chatController.careerAssessmentQuestions
                              .asMap()
                              .entries
                              .map(
                                (entry) => Step(
                                  title: Text(
                                    'Question ${entry.key + 1}',
                                    style: sfBold,
                                  ),
                                  content: Column(
                                    children: [
                                      Text(
                                        entry.value['question'],
                                        style: sfSemiBold,
                                      ),
                                      // Depending on the response type, you can use different widgets
                                      if (entry.value['type'] == 'rating')
                                        Slider(
                                          value: responses[entry.key] ?? 0.0,
                                          onChanged: (newValue) {
                                            setState(() {
                                              recordResponse(newValue);
                                            });
                                          },
                                          min: 0.0,
                                          max: entry.value['scale'].toDouble(),
                                          divisions: entry.value['scale'],
                                        ),
                                      if (entry.value['type'] == 'boolean')
                                        TextField(
                                          onChanged: (newValue) {
                                            recordResponse(newValue);
                                          },
                                        ),
                                      if (entry.value['type'] == 'text') ...{
                                        TextField(
                                          onChanged: (newValue) {
                                            recordResponse(newValue);
                                          },
                                        ),
                                      }
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                        AppButton(
                          onTap: () {
                            chatController.setStudentResponse(responses);
                            chatController.generateAssesmentChatSession(true);
                          },
                          title: ('Submit'),
                        ),
                      ],
                    ),
                  );
          }),
    );
  }
}
