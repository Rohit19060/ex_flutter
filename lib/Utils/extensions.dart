import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:intl/intl.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toCapitalizedWords() => split(
        RegExp('(?=[A-Z])'),
      ).map((e) => e.toCapitalized()).join(' ');

  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

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
