import 'dart:convert';
import 'dart:io';

import 'package:ai_story_maker/utils/text_style.dart';
import 'package:ai_story_maker/views/dashboard/dashboard.dart';
import 'package:ai_story_maker/views/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/firebase_controller.dart';
import '../../utils/utilities.dart';
import '../widgets/text_field.dart';

class StudentManagementScreen extends StatefulWidget {
  final bool? fromProfile;
  const StudentManagementScreen({
    super.key,
    this.fromProfile = false,
  });

  @override
  State<StudentManagementScreen> createState() =>
      _StudentManagementScreenState();
}

class _StudentManagementScreenState extends State<StudentManagementScreen> {
  final TextEditingController studentNameController = TextEditingController();
  final FocusNode studentfocusNode = FocusNode();
  String _studentError = "";

  //contact
  final TextEditingController schoolController = TextEditingController();
  final FocusNode schoolfocusNode = FocusNode();
  String _schoolError = "";

  //email

  final TextEditingController ageController = TextEditingController();
  final FocusNode agefocusNode = FocusNode();
  String _ageError = "";

  //country

  final TextEditingController countryController = TextEditingController();
  final FocusNode countryfocusNode = FocusNode();
  final String _countryError = "";

  final TextEditingController classController = TextEditingController();
  final FocusNode classfocusNode = FocusNode();
  String _classError = "";

  final TextEditingController streamController = TextEditingController();
  final FocusNode streamfocusNode = FocusNode();
  String _streamError = "";
  //state
  final TextEditingController stateController = TextEditingController();
  final FocusNode statefocusNode = FocusNode();
  final String _stateError = "";

  final TextEditingController subjectController = TextEditingController();
  final FocusNode subjectfocusNode = FocusNode();
  String _subjectError = "";

  final TextEditingController whyController = TextEditingController();
  final FocusNode whyfocusNode = FocusNode();
  String _whyError = "";

  final TextEditingController hobbiesController = TextEditingController();
  final FocusNode hobbiesfocusNode = FocusNode();
  String _hobbiesError = "";

  final TextEditingController goalsController = TextEditingController();
  final FocusNode goalfocusNode = FocusNode();
  final String _goalError = "";

  final TextEditingController learningController = TextEditingController();
  final FocusNode learningStylefocusNode = FocusNode();
  final String _learningStyleError = "";

  final TextEditingController extraActionController = TextEditingController();
  final String _extraActionError = "";
  final FocusNode extraActionfocusNode = FocusNode();

  // Future<void> _pickPDFFile() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['png', 'jpeg', 'jpg'],
  //     );

  //     if (result != null) {
  //       PlatformFile file = result.files.first;

  //       setState(() {
  //         extraActionController.text = file.name;
  //       });
  //       _selectedITR = await fileToBase64(File(file.path!));
  //     }
  //   } catch (e) {
  //     print("Error");
  //   }
  // }

  Future<String> fileToBase64(File? file) async {
    if (file == null) {
      return "";
    }

    List<int> fileBytes = await file.readAsBytes();
    String base64Image = base64Encode(fileBytes);
    return base64Image;
  }

  //pick date of birth
  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        extraActionController.text = date.toString().substring(0, 10);
      });
    }
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseController.getStudentData();
    });

    if (firebaseController.studentData.isNotEmpty) {
      studentNameController.text = firebaseController.studentData[0].name!;
      ageController.text = firebaseController.studentData[0].age!;
      schoolController.text = firebaseController.studentData[0].school!;
      classController.text = firebaseController.studentData[0].className!;
      streamController.text = firebaseController.studentData[0].stream!;
      whyController.text = firebaseController.studentData[0].why!;
      subjectController.text = firebaseController.studentData[0].subject!;
      hobbiesController.text = firebaseController.studentData[0].hobbies!;
      goalsController.text = firebaseController.studentData[0].goals!;
      learningController.text =
          firebaseController.studentData[0].learningStyle!;
      extraActionController.text = firebaseController.studentData[0].extra!;
      stateController.text = firebaseController.studentData[0].state!;
      countryController.text = firebaseController.studentData[0].country!;
    }
    super.initState();
  }

  @override
  void dispose() {
    studentNameController.dispose();

    studentfocusNode.dispose();
    schoolController.dispose();
    schoolfocusNode.dispose();
    ageController.dispose();
    agefocusNode.dispose();
    goalsController.dispose();
    classfocusNode.dispose();
    whyController.dispose();
    whyfocusNode.dispose();
    learningController.dispose();
    goalfocusNode.dispose();
    learningStylefocusNode.dispose();
    extraActionController.dispose();
    classController.dispose();

    super.dispose();
  }

  FirebaseController firebaseController = Get.put(FirebaseController());

  bool _isLoading = false;
  void _submit() async {
    //validate all

    studentNameController.text.isEmpty
        ? _studentError = "Please enter Name"
        : _studentError = "";

    schoolController.text.isEmpty
        ? _schoolError = "Please enter School Name"
        : _schoolError = "";

    ageController.text.isEmpty
        ? _ageError = "Please enter Age"
        : _ageError = "";

    classController.text.isEmpty
        ? _classError = "Please enter your Class"
        : _classError = "";

    streamController.text.isEmpty
        ? _streamError = "Please enter your Stream"
        : _streamError = "";

    whyController.text.isEmpty
        ? _whyError = "Please enter your reason"
        : _whyError = "";

    subjectController.text.isEmpty
        ? _subjectError = "Please enter your Subjects"
        : _subjectError = "";

    hobbiesController.text.isEmpty
        ? _hobbiesError = "Please enter your hobbies"
        : _hobbiesError = "";

    setState(() {});

    if (_studentError.isEmpty &&
        _schoolError.isEmpty &&
        _ageError.isEmpty &&
        _classError.isEmpty &&
        _streamError.isEmpty &&
        _whyError.isEmpty &&
        _subjectError.isEmpty &&
        _hobbiesError.isEmpty) {
      setState(() {
        _isLoading = true;
      });

      try {
        await firebaseController.insertStudentData(
          name: studentNameController.text,
          school: schoolController.text,
          age: ageController.text,
          goals: goalsController.text,
          subject: subjectController.text,
          why: whyController.text,
          learningStyle: learningController.text,
          className: classController.text,
          stream: streamController.text,
          hobbies: hobbiesController.text,
          extra: extraActionController.text,
          state: stateController.text,
          country: countryController.text,
        );
        _showDialog(
            "Successfully Added", "Your details have been successfully Saved");

        //after 2 seconds
        Future.delayed(const Duration(seconds: 3), () {
          Navigator.pop(context);
          Get.offAll(() => const DashBoardScreen());
        });
      } catch (e) {
        print(e);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

//show dialog
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Center(
            child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        )),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              "assets/success.json",
              height: 200,
              width: 200,
            ),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
            ),
          ],
        ),
        actions: const [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.fromProfile! ? "Your Profile" : "Add Your Details",
            style: sfBold.copyWith(fontSize: 20)),
        automaticallyImplyLeading: false,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFieldWithTitle(
                  title: 'Name',
                  icon: (Icons.person),
                  hintText: 'Enter Your Name',
                  textEditingController: studentNameController,
                  focusNode: studentfocusNode,
                  errorText: _studentError,
                  isMandatory: true,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Age',
                  hintText: 'Enter Your Age',
                  icon: (Icons.confirmation_num_outlined),
                  textEditingController: ageController,
                  focusNode: agefocusNode,
                  errorText: _ageError,
                  isMandatory: true,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'School Name',
                  icon: (Icons.school),
                  hintText: 'Enter School Name',
                  textEditingController: schoolController,
                  focusNode: schoolfocusNode,
                  errorText: _schoolError,
                  isMandatory: true,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Studying Class',
                  isMandatory: true,
                  hintText: '10th,11th,12th',
                  icon: (Icons.subtitles),
                  textEditingController: classController,
                  focusNode: classfocusNode,
                  errorText: _classError,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Stream',
                  isMandatory: true,
                  hintText: 'Science,Commerce,Humanities',
                  icon: (Icons.subtitles),
                  textEditingController: streamController,
                  focusNode: streamfocusNode,
                  errorText: _streamError,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Why this Stream',
                  isMandatory: true,
                  hintText: 'Describe why you prefferd your stream',
                  icon: (Icons.emoji_nature_outlined),
                  textEditingController: whyController,
                  focusNode: whyfocusNode,
                  errorText: _whyError,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Favorite Subjects',
                  isMandatory: true,
                  hintText: 'Physics,Chemistry ( "," Seprated)',
                  icon: (Icons.subject),
                  textEditingController: subjectController,
                  focusNode: subjectfocusNode,
                  errorText: _subjectError,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Hobbies and Interests',
                  isMandatory: true,
                  hintText: 'Dancing,Singing ( "," Seprated)',
                  icon: (Icons.emoji_nature_outlined),
                  textEditingController: hobbiesController,
                  focusNode: hobbiesfocusNode,
                  errorText: _hobbiesError,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Goals and Aspirations:',
                  icon: (Icons.drive_file_rename_outline),
                  hintText: 'Describe Your Goals and Aspirations',
                  textEditingController: goalsController,
                  focusNode: goalfocusNode,
                  errorText: _goalError,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Preferred Learning Style',
                  icon: (Icons.web_stories),
                  hintText: 'Visual, auditory, or kinesthetic',
                  textEditingController: learningController,
                  focusNode: learningStylefocusNode,
                  errorText: _learningStyleError,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Extracurricular Activities',
                  hintText: 'Describe your role in Extracurricular Activities',
                  icon: (Icons.branding_watermark_sharp),
                  textEditingController: extraActionController,
                  errorText: _extraActionError,
                  focusNode: extraActionfocusNode,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'State',
                  hintText: 'Describe your role in Extracurricular Activities',
                  icon: (Icons.branding_watermark_sharp),
                  textEditingController: stateController,
                  errorText: _stateError,
                  focusNode: statefocusNode,
                ),
                const SizedBox(height: 16),
                TextFieldWithTitle(
                  title: 'Country',
                  hintText: 'Describe your role in Extracurricular Activities',
                  icon: (Icons.branding_watermark_sharp),
                  textEditingController: countryController,
                  errorText: _countryError,
                  focusNode: countryfocusNode,
                ),
                const SizedBox(height: 32),
                AppButton(
                  isLoading: _isLoading,
                  onTap: () {
                    UtilValidator.hiddenKeyboard(context);
                    _submit();
                  },
                  title: ('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TextFieldWithTitle extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? textEditingController;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final VoidCallback? suffixIcon;
  final IconData? icon;
  final String? errorText;
  final bool? isEnabled;
  final bool? isMandatory;

  const TextFieldWithTitle({
    super.key,
    required this.title,
    required this.hintText,
    this.textEditingController,
    this.focusNode,
    this.nextFocusNode,
    this.suffixIcon,
    this.icon,
    this.errorText,
    this.isEnabled = true,
    this.isMandatory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              children: [
                TextSpan(
                  text: isMandatory! ? ' *' : "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
              ],
            )),
        const SizedBox(height: 8),
        MyTextField(
          isEnabled: isEnabled!,
          hintText: hintText,
          controller: textEditingController,
          focusNode: focusNode,
          icon: icon,
          nextFocus: nextFocusNode,
          errorText: errorText,
          onChanged: (value) {},
          onTap: () {
            if (suffixIcon != null) {
              suffixIcon!();
            }
          },
          onSubmit: () {
            focusNode!.unfocus(); // Hide keyboard
            FocusScope.of(context)
                .requestFocus(nextFocusNode); // Move focus to the next field
          },
        ),
      ],
    );
  }
}
