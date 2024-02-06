import 'package:ai_story_maker/views/brand/assessment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/text_style.dart';
import '../chat/chat_screen.dart';
import '../chat/stem.dart';
import '../widgets/app_button.dart';
import '../widgets/text_field.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "CareerCrater.AI",
          style: sfBold,
        ),

        actions: [
          InkWell(
            onTap: () {
              showBottomSheet(
                  context: context,
                  builder: (context) => const SupportBottomSheet());
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.info,
                size: 30,
              ),
            ),
          )
        ],
        // backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                  "assets/bg.png",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //appBanner
                  CardWidget(
                    color: Colors.red,
                    title: 'AI Counseling',
                    intro:
                        'Get expert career advice from our AI-powered counselor.',
                    icon: "assets/phrase 01 2.png",
                    onTap: () {
                      Get.to(() => const ChatViewScreen(
                            id: 1,
                            title: 'AI Counseling',
                            prompt:
                                "Imagine you are an AI Career Counselor, dedicated to helping students make informed decisions about their future careers. Your primary role is to assist students in exploring and deciding their career paths by asking questions, understanding their strengths, values, and interests. You are eager to provide guidance and support throughout their career exploration journey. To start, engage with the student by asking about their academic interests, hobbies, and any subjects or activities they are passionate about. Encourage them to share their career goals and aspirations. Once the student shares their thoughts, provide insightful guidance,suggest Some Courses and colleges ,ask follow-up questions, and offer personalized advice based on their unique profile. Continue the dialogue until the student feels confident and satisfied with their career decisions. Your mission is to be a helpful and compassionate AI Career Counselor, supporting students as they navigate the important choices that will shape their future.",
                          ));
                    },
                  ),

                  CardWidget(
                    color: Colors.blue,
                    icon: "assets/bulb.png",
                    title: 'Career Assessment',
                    intro:
                        'Discover your path to success with personalized assessments.',
                    onTap: () {
                      Get.to(() => const CareerAssessmentScreen());
                    },
                  ),
                  CardWidget(
                    color: Colors.red,
                    title: 'STEM',
                    intro: 'SITUATIONAL TEST OF EMOTION MANAGEMENT ',
                    icon: "assets/phrase 01 2.png",
                    onTap: () {
                      Get.to(() => const StemQuestionAnswer());
                    },
                  ),
                  CardWidget(
                    color: Colors.orange,
                    icon: "assets/book.png",
                    title: 'Personalized Career Recommendations',
                    intro: 'Your tailored career options await.',
                    onTap: () {
                      Get.snackbar("Coming Soon", "Still In Development",
                          colorText: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),

                  CardWidget(
                    color: Colors.purple,
                    title: 'Aptitude Tests',
                    icon: "assets/pop up 2.png",
                    intro: 'Test your skills and find your strengths.',
                    onTap: () {
                      Get.snackbar("Coming Soon", "Still In Development",
                          colorText: Colors.white,
                          backgroundColor: Theme.of(context).primaryColor,
                          snackPosition: SnackPosition.BOTTOM);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContainerButton extends StatelessWidget {
  final Color backgroundColor;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  const ContainerButton({
    super.key,
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: sfBold.copyWith(color: Colors.white)),
            const SizedBox(height: 4),
            Text(subtitle, style: sfMedium.copyWith(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  final String? title;
  final String? intro;
  final VoidCallback? onTap;
  final Color? color;
  final String? icon;
  const CardWidget({
    super.key,
    this.title,
    this.onTap,
    this.color,
    this.intro,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[200]!,
            offset: const Offset(0, 20),
          )
        ],
      ),
      child: Center(
        child: ListTile(
          leading: Image.asset(
            icon!,
            width: 70,
            height: 70,
            fit: BoxFit.contain,
          ),
          onTap: () {
            onTap!();
          },
          title: Text(
            title ?? '',
            style: sfBold.copyWith(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              intro ?? '',
              style: sfRegular.copyWith(
                  fontSize: 11,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}

class SupportBottomSheet extends StatefulWidget {
  const SupportBottomSheet({super.key});

  @override
  SupportBottomSheetState createState() => SupportBottomSheetState();
}

class SupportBottomSheetState extends State<SupportBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Text(
                    "Give Feedback",
                    style: sfBold.copyWith(fontSize: 18, color: Colors.white),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.close,
                    size: 20,
                    color: Colors.white,
                  ),
                )
              ],
            ),
            const SizedBox(height: 30.0),
            MyTextField(
              controller: _emailController,
              inputAction: TextInputAction.next,
              icon: Icons.email,
              hintText: 'Enter Email',
              inputType: TextInputType.text,
              isEnabled: true,
              fillColor: Colors.white,
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              controller: _emailController,
              inputAction: TextInputAction.next,
              icon: Icons.person_outline,
              hintText: 'Enter Name',
              inputType: TextInputType.text,
              isEnabled: true,
              fillColor: Colors.white,
            ),
            const SizedBox(height: 16.0),
            MyTextField(
              maxLines: 3,
              controller: _emailController,
              inputAction: TextInputAction.next,
              icon: Icons.feedback,
              hintText: 'Feedback',
              inputType: TextInputType.text,
              isEnabled: true,
              fillColor: Colors.white,
            ),
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: AppButton(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(context);
                    }
                  },
                  title: ('Submit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StemModel {
  final String question;
  final List<String> options;

  StemModel({required this.question, required this.options});
}
