import 'package:ai_story_maker/model/brand_data.dart';
import 'package:ai_story_maker/model/campaingdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../model/requested_loan.dart';
import '../model/student_data.dart';

class FirebaseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//insert user data in Firebase

  Future<void> insertUserData() async {
    try {
      await _firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': FirebaseAuth.instance.currentUser!.displayName ??
            FirebaseAuth.instance.currentUser!.email!,
        'email': FirebaseAuth.instance.currentUser!.email!,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'verified': false,
        'createdAt': DateTime.now()
      });
    } catch (e) {
      print(e.toString());
    }
  }

  //set verified to true
  // Future<void> setVerified() async {
  //   try {
  //     await _firestore
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update({'verified': true});
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   }
  // }

  Branddata? _selectedBrand;
  Branddata? get selectedBrand => _selectedBrand;

  setSelectedBrand(Branddata data) {
    _selectedBrand = data;
    update();
  }

  Future<void> getSelectedBrand(String name) async {
    if (_brandData.isNotEmpty) {
      _brandData.where((element) => element.name == name).toList();
      setSelectedBrand(
          _brandData.where((element) => element.name == name).toList()[0]);
    }
  }

  List<StudentData> _studentData = [];
  List<StudentData> get studentData => _studentData;
  Future<void> getStudentData() async {
    _isLoading = true;
    update();
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('studentData')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      _studentData = querySnapshot.docs
          .map((e) => StudentData.fromDocumentSnapshot(e))
          .toList();

      _isLoading = false;
      update();
    } catch (e) {
      _isLoading = false;
      update();
      print(e.toString());
    }
  }

  Future<void> insertStudentData({
    required String name,
    required String age,
    required String school,
    required String className,
    required String subject,
    required String stream,
    required String why,
    required String goals,
    required String hobbies,
    required String extra,
    required String state,
    required String country,
    required String learningStyle,
  }) async {
    try {
      await _firestore
          .collection('studentData')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'name': name,
        'age': age,
        'school': school,
        'subject': subject,
        'class': className,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'stream': stream,
        'why': why,
        'hobbies': hobbies,
        'goals': goals,
        'extra': extra,
        'state': state,
        'country': country,
        'learningStyle': learningStyle,
        'createdAt': DateTime.now()
      });
    } catch (e) {}
  }

  Future<void> insertBrandData({
    required String name,
    required String email,
    required String category,
    required String slogan,
    required String instagram,
    required String website,
    required String facebook,
    required String linkedin,
    required String logo,
  }) async {
    try {
      await _firestore.collection('brandData').doc(const Uuid().v4()).set({
        'name': name,
        'brandId': const Uuid().v4(),
        'email': email,
        'category': category,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'slogan': slogan,
        'instagram': instagram,
        'facebook': facebook,
        'website': website,
        'linkedin': linkedin,
        'logo': logo,
        'createdAt': DateTime.now()
      });
    } catch (e) {}
  }

  List<Branddata> _brandData = [];
  List<Branddata> get brandData => _brandData;
//get All Brand
  Future<void> getAllBrand() async {
    _isLoading = true;

    _selectedBrand = null;
    update();
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('brandData')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      _brandData = querySnapshot.docs
          .map((e) => Branddata.fromDocumentSnapshot(e))
          .toList();

      _isLoading = false;
      update();
    } catch (e) {
      _isLoading = false;
      update();
      print(e.toString());
    }
  }

  List<CampaignData>? _campaignData;
  List<CampaignData>? get campaignData => _campaignData;

//get All Brand
  Future<void> getAllPosts() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('campaignData')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      _campaignData = querySnapshot.docs
          .map((e) => CampaignData.fromDocumentSnapshot(e))
          .toList();

      update();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> insertPosts({
    required String data,
    required String image,
    required String brandName,
  }) async {
    try {
      await _firestore.collection('campaignData').doc(const Uuid().v4()).set({
        'data': data,
        'brandName': brandName,
        'image': image,
        'uid': FirebaseAuth.instance.currentUser!.uid,
      });
    } catch (e) {}
  }

  bool _isEmpty = false;
  bool get isEmpty => _isEmpty;

  Future<void> checkStudent() async {
    await getStudentData();
    if (_studentData.isEmpty) {
      _isEmpty = true;
      update();
    } else {
      _isEmpty = false;
      update();
    }
  }

  //get current user verified status firebase
  Future<bool> getVerified() async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
          await _firestore
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();
      print(documentSnapshot.data()!['verified']);
      return documentSnapshot.data()!['verified'] as bool;
    } catch (e) {
      Get.snackbar('Error', e.toString());
      return false;
    }
  }

  //insert data in firebase for loan with amount ,company id ,lead bank name
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  Future<void> insertLoanDataForLoan({
    required String amount,
    required String leadBankName,
  }) async {
    _isLoading = true;
    update();
    try {
      await _firestore
          .collection('loanRequest')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'amount': amount,
        'companyId': FirebaseAuth.instance.currentUser!.uid,
        'leadBankName': leadBankName,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'createdAt': DateTime.now(),
        'status': 'In Review'
      });

      _isLoading = false;
      update();
    } catch (e) {
      print(e);
      _isLoading = false;
      update();
    }
  }

  List<RequestedLoan> _requestedLoan = [];
  List<RequestedLoan> get requestedLoan => _requestedLoan;

  //get all loan request of currentUser  from firebase
  Future<void> getAllLoanRequest() async {
    print("Called");
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('loanRequest')
          .where('companyId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      print(querySnapshot.docs.length);
      _requestedLoan = querySnapshot.docs
          .map((e) => RequestedLoan.fromDocumentSnapshot(e))
          .toList();

      print(_requestedLoan.length);
      update();
    } catch (e) {
      print(e.toString());
    }
  }
}
