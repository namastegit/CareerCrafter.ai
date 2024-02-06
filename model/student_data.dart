import 'package:cloud_firestore/cloud_firestore.dart';

class StudentData {
  final String? name;
  final String? age;
  final String? uid;
  final String? school;
  final String? className;
  final Timestamp? createdAt;
  final String? stream;
  final String? why;
  final String? subject;
  final String? hobbies;
  final String? goals;
  final String? extra;
  final String? state;
  final String? country;
  final String? learningStyle;

  StudentData({
    this.name,
    this.age,
    this.state,
    this.country,
    this.learningStyle,
    this.uid,
    this.school,
    this.className,
    this.createdAt,
    this.stream,
    this.why,
    this.subject,
    this.hobbies,
    this.goals,
    this.extra,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'class': className,
      'school': school,
      'uid': uid,
      'stream': stream,
      'why': why,
      'subject': subject,
      'hobbies': hobbies,
      'goals': goals,
      'extra': extra,
      'state': state,
      'country': country,
      'learningStyle': learningStyle,
      'createdAt': createdAt,
    };
  }

  StudentData.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!['name'] as String?,
        age = doc.data()!['age'] as String?,
        className = doc.data()!['class'] as String?,
        uid = doc.data()!['uid'] as String?,
        school = doc.data()!['school'] as String?,
        stream = doc.data()!['stream'] as String?,
        why = doc.data()!['why'] as String?,
        subject = doc.data()!['subject'] as String?,
        hobbies = doc.data()!['hobbies'] as String?,
        goals = doc.data()!['goals'] as String?,
        extra = doc.data()!['extra'] as String?,
        state = doc.data()!['state'] as String?,
        country = doc.data()!['country'] as String?,
        learningStyle = doc.data()!['learningStyle'] as String?,
        createdAt = doc.data()!['createdAt'] as Timestamp?;
}
