import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:ai_story_maker/controllers/firebase_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import '../model/messages.dart';
import '../model/turbo_model.dart';
import '../utils/api_calls.dart';
import '../views/brand/assessment_result.dart';
import '../views/widgets/message_widget.dart';
import 'audio_controller.dart';
import 'google_api.dart';

AppAudioController appAudioController = Get.put(AppAudioController());
FirebaseController firebaseController = Get.put(FirebaseController());

class ChatController extends GetxController {
  List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;
  int _maxLenght = 4000;
  int get maxLenght => _maxLenght;

  bool _textAutoPlay = true;
  bool get textAutoPlay => _textAutoPlay;

  String? _currentModel = 'gpt-4-0613';
  String? get currentModel => _currentModel;

  setCurrentModel(String? value) {
    _currentModel = value;
    GetStorage().write('currentModel', _currentModel);
    update();
  }

  bool _isGpt3 = false;
  bool get isGpt3 => _isGpt3;

  setGPT(bool value, {bool dispose = false}) {
    _isGpt3 = value;
    if (dispose) {
    } else {
      update();
    }
  }

  loadCurrentModel() {
    GetStorage().writeIfNull('currentModel', 'gpt-4-0613');
    _currentModel = GetStorage().read('currentModel');
    update();
  }

  void resetSettings() {
    _maxLenght = 1000;
    _textAutoPlay = true;
    GetStorage().write('isTextAuto', _textAutoPlay);

    _temperature = 0.8;
    _topP = 1.0;
    _currentModel = 'gpt-4-0613';
    update();
  }

  void setTextAutoPlay(bool value) {
    _textAutoPlay = value;
    update();
  }

  void setMaxLenght(int value) {
    _maxLenght = value;
    update();
  }

  //temperature
  double _temperature = 0.8;
  double get temperature => _temperature;

  void setTemperature(double value) {
    _temperature = value;
    update();
  }

  //TopP
  double _topP = 1.0;
  double get topP => _topP;

  void setTopP(double value) {
    _topP = value;
    update();
  }

//filterBySessionId
  Future<void> filterBySessionId(String sessionId) async {
    // _messages = await firebaseController.filterChatsBySessionId(sessionId);
    print("This is ${_messages.length}");

    update();
  }

  String _initialTexts = "";
  String restartSequence = "\n";
  Future<String> getPrompt(String text, String type, String sessionId) async {
    if (text.isEmpty) {
      return _initialTexts;
    } else {
      if (_messages.length > 2) {
        var lastMessage = _messages[0];
        var secondLastMessage = _messages[1];
        var thirdLastMessage = _messages[2];

        _initialTexts =
            "$_initialTexts ${thirdLastMessage.text} $restartSequence ${secondLastMessage.text} $restartSequence ${lastMessage.text} $restartSequence $text";
      } else {
        _initialTexts = "$_initialTexts  $text $restartSequence";
      }

      return _initialTexts;
    }
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  int _freeChats = 0;
  int get freeChats => _freeChats;

  void setFreeChats() {
    var now = DateTime.now();
    var monday = now.subtract(Duration(days: now.weekday - 1));
    var today = DateTime(now.year, now.month, now.day);
    if (monday == today) {
      _freeChats = 7;
    }
    update();
  }

  void stopMessage() async {
    appAudioController.stopAudio();
    _isPlaying = false;
    update();
  }

//clear all messages
  Future<void> clearMessages(String sessionID) async {
    _messages = [];
    _initialTexts = "";
  }

  setCurrentIndex(int index) {
    _currentIndex = index;
    update();
  }

  bool _Typing = false;
  bool get Typing => _Typing;

  setTyping(bool value) {
    _Typing = value;
    update();
  }

  @override
  void onInit() {
    setFreeChats();

    loadCurrentModel();

    super.onInit();
  }

  final List<TurboMessage> _onGoingConv = [];
  List<TurboMessage> get onGoingConv => _onGoingConv;

  addOnGoingConv(TurboMessage message) {
    _onGoingConv.add(message);
    update();
  }

  void clearConvo() {
    _onGoingConv.clear();
    update();
  }

  void setSystemNature(String role, String sessionID,
      {bool? question = false}) async {
    _onGoingConv.add(TurboMessage(role: "system", content: role));
    // if (question!) {
    //   _onGoingConv.add(TurboMessage(role: "user", content: "Hii "));
    //   _onGoingConv.add(TurboMessage(
    //       role: "assistant", content: "Please Provide the paragraph "));
    //   _onGoingConv.add(TurboMessage(
    //       role: "user", content: "This is the paragraph $_currentDocs"));
    // } else {
    _onGoingConv.add(TurboMessage(
        role: "user",
        content:
            "These are the details of student ${firebaseController.studentData[0].name},School Name: ${firebaseController.studentData[0].school},Age: ${firebaseController.studentData[0].age},Studying Class: ${firebaseController.studentData[0].className},Stream: ${firebaseController.studentData[0].stream},Why this you choose this stream: ${firebaseController.studentData[0].why},Favorite Subject: ${firebaseController.studentData[0].subject},Hobbies and Interest: ${firebaseController.studentData[0].hobbies},Goals and Aspirations: ${firebaseController.studentData[0].goals},Preferred Learning Style: ${firebaseController.studentData[0].learningStyle},Extracurricular Activities: ${firebaseController.studentData[0].extra}  Note : Start first conversation with a short Greeting  and dont share student all at once do it while building the conversation all your answer should be short and precise"));
    _onGoingConv.add(TurboMessage(role: "user", content: "Hii "));
    _Typing = true;
    resetCount();
    update();

    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [..._onGoingConv],
        tokenValue: (_maxLenght / 4).ceil(),
        model: _currentModel,
        temperature: _temperature,
        topP: _topP,
      );

      if (rsp.chat == -1) {
        _Typing = false;
        update();
        ChatMessage botMessage = ChatMessage(
          isImage: false,
          text: rsp.msg,
          sender: "gpt",
          query: role,
          index: 0,
          type: 'gpt',
          time: DateTime.now(),
          sessionId: sessionID,
        );
        _messages.insert(0, botMessage);
      } else {
        await insertNewData(
          0,
          rsp.msg,
          rsp.msg,
          sessionID,
          isImage: false,
          insert: false,
        );
      }
      _Typing = false;
      update();
    } catch (e) {
      _Typing = false;
      update();
      print(e);
      Get.snackbar(
        "Error $e",
        "Something went wrong please try again later",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final String _systemRole =
      'You are a helpful assistant that is Smart and Intelligent and Quick and assist users in their daily life.';
  String get systemRole => _systemRole;
  String setSystemRole(String type) {
    return type;
  }

  Future<void> sendMessage(int id, String text, String previous, String type,
      String sessionId, bool isImage) async {
    if (text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: text,
      isImage: isImage,
      sender: "You",
      query: previous,
      index: 0,
      type: 'You',
      time: DateTime.now(),
      sessionId: sessionId,
    );

    _messages.insert(0, message);
    _onGoingConv.add(TurboMessage(role: "user", content: text));
    resetCount();
    _Typing = true;
    update();

    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [
          // TurboMessage(
          //     role: setSystemRole(type),
          //     content: await getPrompt(text, type, sessionId)),
          ..._onGoingConv
        ],
        tokenValue: (_maxLenght / 4).ceil(),
        model: _isGpt3 ? "gpt-3.5-turbo-16k" : _currentModel,
        temperature: _temperature,
        topP: _topP,
      );

      if (rsp.chat == -1) {
        _Typing = false;
        update();
        ChatMessage botMessage = ChatMessage(
          isImage: isImage,
          text: rsp.msg,
          sender: "gpt",
          query: message.text,
          index: 0,
          type: 'gpt',
          time: DateTime.now(),
          sessionId: sessionId,
        );
        _messages.insert(0, botMessage);
      } else {
        await insertNewData(id, rsp.msg, message.text, sessionId,
            isImage: isImage);
      }
    } catch (e) {
      _Typing = false;
      update();
      print(e);
      Get.snackbar(
        "Error $e",
        "Something went wrong please try again later",
        colorText: Colors.white,
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> insertNewData(
      int id, String response, String query, String sessionId,
      {bool isImage = false,
      List<Images> images = const [],
      bool? insert = true}) async {
    ChatMessage botMessage = ChatMessage(
      isImage: isImage,
      text: response,
      sender: "gpt",
      query: query,
      index: 0,
      type: 'gpt',
      time: DateTime.now(),
      sessionId: sessionId,
    );
    setCurrentIndex(0);

    speakMessage(response,
        sessionId: sessionId,
        query: query,
        response: response,
        insert: insert,
        botMessage: botMessage);
  }

  ///APi Section

  int? _currentIndex;
  int get currentIndex => _currentIndex!;

  bool _isDownloading = false;
  bool get isDownloading => _isDownloading;

  final int _progress = 0;
  int get progress => _progress;
  // final String _imageId = "";
  // String get imageId => _imageId;

  ///download image
  ///download image
  Future<void> downloadImage(String url, int index, String? type,
      {Uint8List? bytes}) async {
    setCurrentIndex(index);
    try {
      _isDownloading = true;
      update();
      // Saved with this method.

      if (type == 'stability') {
//get deault path

        var directory = Platform.isAndroid
            ? await getExternalStorageDirectory()
            : await getApplicationSupportDirectory();

        await File('${directory!.path}/stability.png').writeAsBytes(bytes!);

        // final galleryPath =
        //     await ImageGallerySaver.saveFile('${directory.path}/stability.png');
        _isDownloading = false;
        update();

        Get.snackbar(
          "Success",
          "Image saved successfully",
          colorText: Colors.white,
          backgroundColor: Theme.of(Get.context!).primaryColor,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        _isDownloading = false;
        update();

        Get.snackbar(
          "Success",
          "Image saved successfully",
          colorText: Colors.white,
          backgroundColor: Theme.of(Get.context!).primaryColor,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } on PlatformException catch (error) {
      _isDownloading = false;
      update();
      print(error);
    }
  }

  ///ad interval Section

  int _count = 0;
  int get count => _count;

  void setCount() {
    _count++;
    update();
  }

  void resetCount() {
    _count = 0;
    update();
  }

//generate Mock Text Series

  String _testSeries = "";
  String get testSeries => _testSeries;

  bool _resultLoading = false;
  bool get resultLoading => _resultLoading;

  Future<void> generateMockTestSeries(
      {String? topic,
      String? noOfQuestion,
      String? exam,
      String? typeOfExam}) async {
    _resultLoading = true;
    update();
    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [
          TurboMessage(
              role:
                  '''You will act as a Question Generator I will give you type of question,No of Question,topic and Exam Name you will generate a test series  you will return the series in correct  format and no other text with test series questions list''',
              content:
                  "The Topic is $topic, no of Questionis $noOfQuestion and exam name is $exam and the type of Exam is $typeOfExam")
        ],
        tokenValue: (_maxLenght / 4).ceil(),
        model: "gpt-4-0613",
        temperature: _temperature,
        topP: _topP,
      );

      _testSeries = rsp.msg;
      _resultLoading = false;
      update();
    } catch (e) {
      _resultLoading = false;
      update();
    }
  }

  String _solvedTestSeries = "";
  String get solvedTestSeries => _solvedTestSeries;

  Future<void> solveMockTestSeries({
    String? questions,
  }) async {
    _resultLoading = true;
    update();
    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [
          TurboMessage(
              role:
                  '''You will solve and Explain in simple term all given question by user MCQ,Subjective any question''',
              content:
                  "This is the given Test Series '$questions' Please provide a step by step detailed answer to all the given questions")
        ],
        tokenValue: (_maxLenght / 4).ceil(),
        model: "gpt-4-0613",
        temperature: _temperature,
        topP: _topP,
      );

      _solvedTestSeries = rsp.msg;
      _resultLoading = false;
      update();
    } catch (e) {
      _resultLoading = false;
      update();
    }
  }

  String? _currentDocs;
  String? get currentDocs => _currentDocs;

  String? _sessionId;
  String? get sessionId => _sessionId;

  Future<void> setCurrentDocs(String docs, String sessionId) async {
    _currentDocs = docs;
    _sessionId = sessionId;
    update();
  }

  Future<void> analyzeDocs(
      {String? prompt, bool? fromChat, String? sessionId}) async {
    _resultLoading = true;
    // if (fromChat ?? false) {
    ChatMessage myMessage = ChatMessage(
      isImage: false,
      text: prompt ?? '',
      sender: "You",
      query: prompt ?? '',
      index: 0,
      type: 'You',
      time: DateTime.now(),
      sessionId: sessionId ?? '',
    );
    _messages.insert(0, myMessage);
    // }
    _Typing = true;
    update();
    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [
          TurboMessage(
              role:
                  "You will act as an Experienced Teacher that will give answers to student Queries and take document and analyze it and answer user queries from the documents, your answers will be precise and exact and small and all your answer will be in KaTeX format for mathematics, chemistry, and physics based questions",
              content:
                  "The Documents is : \"$_currentDocs\", user input is : $prompt you will reply accordingly")
        ],
        tokenValue: (_maxLenght / 4).ceil(),
        model: "gpt-4-0613",
        temperature: _temperature,
        topP: _topP,
      );
      // if (fromChat ?? false) {
      if (rsp.chat == -1) {
        _Typing = false;
        update();

        ChatMessage botMessage = ChatMessage(
          isImage: false,
          text: rsp.msg,
          sender: "gpt",
          query: prompt ?? '',
          index: 0,
          type: 'gpt',
          time: DateTime.now(),
          sessionId: sessionId ?? '',
        );
        _messages.add(botMessage);
      } else {
        _Typing = false;
        await insertNewData(1, rsp.msg, prompt ?? '', sessionId ?? '',
            isImage: false);
      }
      // } else {
      _testSeries = rsp.msg;
      _resultLoading = false;
      // _messages.add(ChatMessage(
      //   isImage: false,
      //   text: rsp.msg,
      //   sender: "gpt",
      //   query: prompt ?? '',
      //   index: 0,
      //   type: 'gpt',
      //   time: DateTime.now(),
      //   sessionId: sessionId ?? '',
      // ));
      _Typing = false;
      // }
      update();
    } catch (e) {
      _resultLoading = false;
      _Typing = false;

      update();
    } finally {
      _resultLoading = false;
      _Typing = false;

      update();
    }
  }

  final _isSpeechLoading = false.obs;

  bool get isSpeechLoading => _isSpeechLoading.value;

  final _isSpeech = false.obs;

  bool get isSpeech => _isSpeech.value;
  // final googleTTS = GoogleTTS();

  // bool _isActive = true;
  // bool get isActive => _isActive;

  // setIsActive() {
  //   _isActive = false;
  // }

  speakMessage(
    String text, {
    String? sessionId,
    String? query,
    String? response,
    ChatMessage? botMessage,
    bool? insert = true,
  }) async {
    // if (_isActive) {
    _isSpeechLoading.value = true;
    _isSpeech.value = true;
    update();

    // final audioContent = await googleTTS.synthesizeText(
    //   removeHtmlTags(text),
    // );
    _isSpeechLoading.value = false;
    _messages.insert(0, botMessage!);
    _Typing = false;
    update();
    // if (_soundOn) {
    //   appAudioController.setPlaying(true, index: 0);

    //   appAudioController.playAudioFromBase64(audioContent!);
    // }

    if (sessionId != null && insert!) {
      // await fireStoreController.insertToFirestore(1,
      //     text: query,
      //     name: "You",
      //     type: 'You',
      //     sessionId: sessionId,
      //     mp3Content: "");
      // await fireStoreController.insertToFirestore(1,
      //     text: response,
      //     name: "gpt",
      //     type: 'gpt',
      //     sessionId: sessionId,
      //     mp3Content: audioContent);
    }
    if (sessionId != null) {
      getPrompt(response!, 'reply', sessionId);
    }

    resetCount();
    update();
  }
  // }

  bool _soundOn = true;
  bool get soundOn => _soundOn;

  setSoundOn() {
    _soundOn = !_soundOn;

    update();
  }

  void insertFirstMessage(String sessionId) {
    ChatMessage message1 = ChatMessage(
      text: "Hello! How can I assist you today with this document?",
      isImage: false,
      sender: "gpt",
      query: "Hello! How can I assist you today with this document?",
      index: 0,
      type: 'gpt',
      time: DateTime.now(),
      sessionId: sessionId,
    );
    _messages.insert(0, message1);
    update();
  }

  //translate using ChatGPT
  Future<void> translateUsingChatGPT({
    String? prompt,
    String? language,
  }) async {
    _resultLoading = true;

    update();
    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [
          TurboMessage(
              role:
                  "You are powerful language translator that will translate English to any given language",
              content: "Translate this '$prompt' in this language '$language'")
        ],
        tokenValue: (_maxLenght / 4).ceil(),
        model: _currentModel,
        temperature: _temperature,
        topP: _topP,
      );

      if (rsp.chat == -1) {
        _Typing = false;
        update();
      } else {
        _Typing = false;
      }

      _testSeries = rsp.msg;
      _resultLoading = false;

      update();
    } catch (e) {
      _resultLoading = false;
      _Typing = false;
      update();
    } finally {
      _resultLoading = false;
      _Typing = false;

      update();
    }
  }

  final List<Map<String, dynamic>> _careerAssessmentQuestions = [];
  List<Map<String, dynamic>> get careerAssessmentQuestions =>
      _careerAssessmentQuestions;

  void parseAssessmentQuestions(String assesment) {
    try {
      // Parse the JSON string into a list of maps
      final List<dynamic> questionsList = json.decode(assesment);

      // Convert each item in the list to a Map
      for (var item in questionsList) {
        if (item is Map<String, dynamic>) {
          _careerAssessmentQuestions.add(item);
        }
      }

      // Print the parsed questions (you can remove this in your final code)
      for (var question in _careerAssessmentQuestions) {
        print(question['question']);
      }
    } catch (e) {
      // Handle any parsing errors here
      print("Error parsing assessment questions: $e");
    }
  }

  final Map<int, dynamic> _studentResponses = {};

  setStudentResponse(dynamic value) {
    _studentResponses.addAll(value);
    update();
  }

  Future<void> generateAssesmentChatSession(bool isResult) async {
    _resultLoading = true;
    update();

    try {
      Chat rsp = await getTextViaTurbo(
        prompt: [
          TurboMessage(
              role: 'system',
              content:
                  "I will give you details of a Student like interest,name,class,stream,hobbies,etc and you will create career assessment for student involves a combination of self-assessment questions related to academic interests, hobbies, and personal strengths for measuring strength,area of Improvement,decision making etc."),
          TurboMessage(
              role: 'user',
              content:
                  '''These are the details of Student as Name: ${firebaseController.studentData[0].name},School Name: ${firebaseController.studentData[0].school},Age: ${firebaseController.studentData[0].age},Studying Class: ${firebaseController.studentData[0].className},Stream: ${firebaseController.studentData[0].stream},Why this you choose this stream: ${firebaseController.studentData[0].why},Favorite Subject: ${firebaseController.studentData[0].subject},Hobbies and Interest: ${firebaseController.studentData[0].hobbies},Goals and Aspirations: ${firebaseController.studentData[0].goals},Preferred Learning Style: ${firebaseController.studentData[0].learningStyle},Extracurricular Activities: ${firebaseController.studentData[0].extra} \n\n Now only return the assesment question in : [{
    "question": "On a scale of 1 to 5, how interested are you in Chemistry?",
    "type": "rating",
    "scale": 5,
  },{
    "question": "What other subjects or areas of study in the Science stream do you find intriguing?",
    "type": "text",
  }, {
    "question": "Are you a good problem solver?",
    "type": "boolean",
  },]   return only 20 question in this format tailored this student details Note: the next response must only contain assesment question [] no any explaintion text'''),
          if (isResult) ...[
            TurboMessage(role: 'assistant', content: _testSeries),
            TurboMessage(
                role: 'user',
                content:
                    "Student Response : $_studentResponses Now create career assessment for student involves a combination of self-assessment questions related to academic interests, hobbies, and personal strengths for measuring strength,area of Improvement,decision making etc on the basis of these responses and now return as String"),
          ]
        ],
        tokenValue: (_maxLenght / 4).ceil(),
        model: "gpt-3.5-turbo-16k",
        temperature: _temperature,
        topP: _topP,
      );
      print(rsp.msg);

      // _careerAssessmentQuestions = rsp.msg as List<Map<String, dynamic>>;

      _testSeries = rsp.msg;
      if (isResult) {
        Get.to(() => ResultScreen(
              assessmentResults: _testSeries,
            ));
      } else {
        parseAssessmentQuestions(rsp.msg);
      }

      _resultLoading = false;
      update();
    } catch (e) {
      _resultLoading = false;
      update();
    }
  }
}

String removeHtmlTags(String htmlText) {
  final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(regex, '');
}
