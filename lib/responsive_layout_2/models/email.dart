import 'package:flutter/material.dart';

class Email {
  const Email({
    required this.time,
    required this.isChecked,
    required this.image,
    required this.name,
    required this.subject,
    required this.body,
    required this.isAttachmentAvailable,
    required this.tagColor,
  });
  final String image, name, subject, body, time;
  final bool isAttachmentAvailable, isChecked;
  final Color? tagColor;
}

List<Email> emails = List<Email>.generate(
  demoData.length,
  (int index) => Email(
    name: demoData[index]['name'].toString(),
    image: demoData[index]['image'].toString(),
    subject: demoData[index]['subject'].toString(),
    isAttachmentAvailable: demoData[index]['isAttachmentAvailable'] == true,
    isChecked: demoData[index]['isChecked'] == true,
    tagColor: demoData[index]['tagColor'] as Color?,
    time: demoData[index]['time'].toString(),
    body: emailDemoText,
  ),
);

List<Map<String, dynamic>> demoData = [
  <String, dynamic>{
    'name': 'Apple',
    'image': 'assets/images/user_1.png',
    'subject': 'iPhone 12 is here',
    'isAttachmentAvailable': false,
    'isChecked': true,
    'tagColor': null,
    'time': 'Now'
  },
  <String, dynamic>{
    'name': 'Elvia Atkins',
    'image': 'assets/images/user_2.png',
    'subject': 'Inspiration for our new home',
    'isAttachmentAvailable': true,
    'isChecked': false,
    'tagColor': null,
    'time': '15:32'
  },
  <String, dynamic>{
    'name': 'Marvin Kiehn',
    'image': 'assets/images/user_3.png',
    'subject': 'Business-focused empowering the world',
    'isAttachmentAvailable': true,
    'isChecked': false,
    'tagColor': null,
    'time': '14:27',
  },
  <String, dynamic>{
    'name': 'Domenic Bosco',
    'image': 'assets/images/user_4.png',
    'subject': 'The fastest way to Design',
    'isAttachmentAvailable': false,
    'isChecked': true,
    'tagColor': const Color(0xFF23CF91),
    'time': '10:43'
  },
  <String, dynamic>{
    'name': 'Elenor Bauch',
    'image': 'assets/images/user_5.png',
    'subject': 'New job opportunities',
    'isAttachmentAvailable': false,
    'isChecked': false,
    'tagColor': const Color.fromARGB(255, 0, 0, 0),
    'time': '9:58'
  }
];

String emailDemoText =
    'Corporis illo provident. Sunt omnis neque et aperiam. Nemo ut dolorum fugit eum sed. Corporis illo provident. Sunt omnis neque et aperiam. Nemo ut dolorum fugit eum sed. Corporis illo provident. Sunt omnis neque et aperiam. Nemo ut dolorum fugit eum sed';
