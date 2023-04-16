import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  String toDateTimeString() =>
      '${DateFormat('dd MMM yyyy').format(this)} at ${DateFormat('hh:mm a').format(this)}';
}

extension TimeStampExtension on Timestamp {
  String toDateTimeString() => formatDate(
      toDate(), [dd, ' ', M, ' ', yyyy, ' - ', hh, ':', nn, ' ', am]);
}

extension MapExtension on Map<String, dynamic> {
  String? encodeQueryParameters(Map<String, String> params) => params.entries
      .map((e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}

extension StringExtension on String {
  String multiple(int x) => this * x;

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');

  String toCapitalized() => length > 1
      ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}'
      : toUpperCase();

  bool isOnlyAlpha() => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  bool isEmail() => RegExp(
          r'^[a-zA-Z0-9.a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+')
      .hasMatch(this);

  bool isPhone() => RegExp(r'^[0-9]{10}$').hasMatch(this);

  bool isPassword() =>
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$')
          .hasMatch(this);

  String getDecimal() => double.parse(this).toStringAsFixed(0);

  String toCapitalizedWords() =>
      split(RegExp('(?=[A-Z])')).map((e) => e.toCapitalized()).join(' ');

  String getGenderAvatar() {
    switch (this) {
      case 'Male':
        return 'https://raw.githubusercontent.com/TechMET-Solutions/Developer-Utilities/main/maleSquare.png';
      case 'Female':
        return 'https://raw.githubusercontent.com/TechMET-Solutions/Developer-Utilities/main/femaleSquare.png';
      default:
        return 'https://raw.githubusercontent.com/TechMET-Solutions/Developer-Utilities/main/other.png';
    }
  }
}

extension DoubleExtension on double {
  String toStringAsFixed(int fractionDigits) =>
      this.toStringAsFixed(fractionDigits);
}

extension IntExtension on int {
  double getDiscountPercent(int discountedPrice) =>
      ((this - discountedPrice) / this) * 100;
}
