import 'package:ai_story_maker/controllers/auth_controller.dart';
import 'package:ai_story_maker/controllers/firebase_controller.dart';
import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/auth/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

import '../auth/forgot_password.dart';
import '../library/create_story.dart';
import '../library/story_reading.dart';

class GeneratedPosts extends StatefulWidget {
  const GeneratedPosts({super.key});

  @override
  State<GeneratedPosts> createState() => _GeneratedPostsState();
}

class _GeneratedPostsState extends State<GeneratedPosts> {
  bool isLoading = false;

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      firebaseController.getAllPosts();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(),
        Positioned.fill(
          child: Scaffold(
            appBar: appBarWidget(context, "Generated Posts"),
            backgroundColor: Colors.transparent,
            body: GetBuilder<FirebaseController>(
                init: FirebaseController(),
                builder: (controller) {
                  return Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: firebaseController.campaignData == null ||
                            firebaseController.campaignData!.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                "No Data",
                                style: sfBold.copyWith(color: Colors.black),
                              )),
                            ],
                          )
                        : SingleChildScrollView(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    firebaseController.campaignData!.length,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return Card(
                                    child: ListTile(
                                        onTap: () {
                                          Get.to(() => StoryViewingScreen(
                                              history: true,
                                              brandName: firebaseController
                                                      .campaignData![index]
                                                      .brandName ??
                                                  '',
                                              data: firebaseController
                                                      .campaignData![index]
                                                      .data ??
                                                  '',
                                              imageUrl: firebaseController
                                                      .campaignData![index]
                                                      .image ??
                                                  ''));
                                        },
                                        leading: Card(
                                          child: Image.network(
                                            firebaseController
                                                .campaignData![index].image!,
                                            width: 100,
                                          ),
                                        ),
                                        title: Text(
                                          firebaseController
                                              .campaignData![index].data!,
                                          maxLines: 2,
                                          style: sfBold.copyWith(
                                              color: Colors.black),
                                        )),
                                  );
                                }),
                          ),
                  );
                }),
            floatingActionButton: InkWell(
              onTap: () {
                Get.to(() => const CreateStory());
              },
              child: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.add),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
