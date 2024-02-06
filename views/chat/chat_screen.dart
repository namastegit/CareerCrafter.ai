// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

import '../../controllers/audio_controller.dart';
import '../../controllers/chat_Controller.dart';
import '../../utils/text_style.dart';
import '../widgets/message_widget.dart';

class ChatViewScreen extends StatefulWidget {
  final int? id;
  final bool? ocr;
  final String? type;
  final String? prompt;
  final String? sessionId;
  final String? title;
  final String? history;
  final String? initText;
  final bool? question;

  const ChatViewScreen({
    super.key,
    required this.id,
    this.type,
    this.prompt = 'none',
    this.sessionId,
    this.title,
    this.history,
    this.ocr = true,
    this.question = false,
    this.initText = "",
  });

  @override
  State<ChatViewScreen> createState() => _ChatViewScreenState();
}

class _ChatViewScreenState extends State<ChatViewScreen> {
  final TextEditingController textcontroller = TextEditingController();
  final ChatController chatController = Get.put(ChatController());

  String sessionId = '';

  @override
  void initState() {
    setState(() {});
    if (widget.sessionId != null) {
      sessionId = widget.sessionId!;
    } else {
      sessionId = const Uuid().v4();
    }
    if (widget.prompt != 'none') {
      chatController.setSystemNature(widget.prompt!, sessionId,
          question: widget.question);
    }

    super.initState();
  }

  @override
  void dispose() {
    chatController.setGPT(false);
    chatController.messages.clear();
    appAudioController.stopAudio();
    chatController.stopMessage();
    chatController.clearConvo();
    Get.find<AppAudioController>().stopAudio();
    chatController.setTyping(false);
    super.dispose();
  }

  void attachInitialText(String text, String currentPropmpt) {
    if (widget.history != null) {
      chatController.sendMessage(
          widget.id!, text, currentPropmpt, 'history', sessionId, false);
    } else {
      if (widget.prompt != 'none') {
        chatController.sendMessage(
            widget.id!, text, currentPropmpt, 'inbuilt', sessionId, false);
      } else {
        if (widget.id != 10) {
          if (widget.type == 'Generate Summarized Text') {
            chatController.sendMessage(widget.id!, text, currentPropmpt,
                'summarize', sessionId, false);
          } else if (widget.type == 'Get Feedback') {
            chatController.sendMessage(
                widget.id!, '', currentPropmpt, 'feedback', sessionId, false);
          } else if (widget.type == 'Keywords') {
            chatController.sendMessage(
                widget.id!, text, currentPropmpt, 'keywords', sessionId, false);
          } else if (widget.type == 'Find Bugs in your code') {
            chatController.sendMessage(
                widget.id!, text, currentPropmpt, 'bugs', sessionId, false);
          } else if (widget.type == 'Sentence Correction') {
            chatController.sendMessage(
                widget.id!, text, currentPropmpt, 'grammer', sessionId, false);
          } else if (widget.type == 'Study Notes') {
            chatController.sendMessage(
                widget.id!, text, currentPropmpt, 'notes', sessionId, false);
          } else if (widget.type == 'Reasoning Questions') {
            chatController.sendMessage(widget.id!, text, currentPropmpt,
                'reasoning', sessionId, false);
          } else if (widget.type == 'Interview Questions') {
            chatController.sendMessage(widget.id!, text, currentPropmpt,
                'interview', sessionId, false);
          } else {
            chatController.sendMessage(
                widget.id!, text, '', '', sessionId, false);
          }
        } else {
          chatController.analyzeDocs(
              prompt: textcontroller.text,
              fromChat: true,
              sessionId: sessionId);
        }
      }
      textcontroller.clear();
    }
  }

  // bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title ?? '', style: sfBold),
          centerTitle: true,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        // backgroundColor: Theme.of(context).primaryColor,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
              child: GetBuilder<ChatController>(
                  init: ChatController(),
                  builder: (controller) {
                    return SafeArea(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Expanded(
                            child: ListView.builder(
                              reverse: true,
                              padding: const EdgeInsets.all(8),
                              itemCount: controller.messages.length,
                              itemBuilder: (context, index) {
                                return ChatMessage(
                                  isImage: controller.messages[index].isImage,
                                  text: controller.messages[index].text,
                                  time: controller.messages[index].time,
                                  sender: controller.messages[index].sender,
                                  query: controller.messages[index].query,
                                  type: controller.messages[index].type,
                                  index: index,
                                  sessionId:
                                      controller.messages[index].sessionId,
                                );
                              },
                            ),
                          ),
                          if (controller.Typing)
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 18.0,
                              ),
                              child: Image.asset(
                                'assets/typing.gif',
                                fit: BoxFit.cover,
                                height: 17,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          const SizedBox(height: 10),
                          BottomTextField(
                            textcontroller: textcontroller,
                            onSubmitted: () {
                              if (!controller.Typing) {
                                attachInitialText(textcontroller.text, '');
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  })),
        ));
  }
}

class BottomTextField extends StatefulWidget {
  final TextEditingController? textcontroller;
  final VoidCallback? onSubmitted;
  final VoidCallback? onListen;
  final bool? enable;
  const BottomTextField({
    super.key,
    this.textcontroller,
    this.onSubmitted,
    this.onListen,
    this.enable = true,
  });

  @override
  State<BottomTextField> createState() => _BottomTextFieldState();
}

class _BottomTextFieldState extends State<BottomTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    enabled: widget.enable,
                    cursorColor: Theme.of(context).secondaryHeaderColor,
                    controller: widget.textcontroller,
                    maxLines: null,
                    style: sfMedium.copyWith(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                    textInputAction: TextInputAction.send,
                    // onSubmitted: _handleSubmit,
                    onChanged: (value) {},
                    decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            widget.textcontroller!.text.isNotEmpty
                                ? InkWell(
                                    onTap: () {
                                      widget.textcontroller!.clear();
                                      setState(() {});
                                    },
                                    child: const Icon(
                                      Icons.clear,
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            const SizedBox(
                              height: 20,
                              child: VerticalDivider(
                                width: 3,
                                thickness: 1,
                                color: Colors.grey,
                              ),
                            ),
                            IconButton(
                                icon: const Icon(
                                  Icons.send,
                                  size: 30,
                                ),
                                onPressed: () {
                                  widget.onSubmitted!();
                                }),
                          ],
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: 'What do you want to ask?',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(14),
                          ),
                        ),
                        hintStyle: sfMedium.copyWith(color: Colors.black)),
                  ),
                ),
                // widget.ocr!
                //     ? Container(
                //         margin: const EdgeInsets.all(4),
                //         padding: const EdgeInsets.all(3),
                //         decoration: BoxDecoration(
                //             shape: BoxShape.circle,
                //             color: Theme.of(context)
                //                 .primaryColor),
                //         child: Padding(
                //           padding:
                //               const EdgeInsets.all(8.0),
                //           child: InkWell(
                //             onTap: () {
                //               _pickImage();
                //             },
                //             child: const Icon(
                //               Icons.camera_enhance,
                //               color: Colors.white,
                //             ),
                //           ),
                //         ),
                //       )
                //     : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
