import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

Future<dynamic> networkRequest({
  required String url,
  Map<String, String>? formData,
  bool isPost = false,
}) async {
  try {
    final headers = <String, String>{
      HttpHeaders.acceptHeader: 'application/json'
    };
    if (isPost) {
      // Do Authentication Related Stuff like Adding Authentication Token or Id
    }
    Response response;
    if (isPost) {
      response = await post(Uri.parse(url), body: formData, headers: headers);
    } else {
      response = await get(Uri.parse(url), headers: headers);
    }
    return jsonDecode(response.body);
  } on TimeoutException {
    return {
      'status': 'false',
      'message': 'The connection has timed out, Please try again!'
    };
  } on SocketException {
    debugPrint('No Internet connection! 😑');
    return {'status': 'false', 'message': 'No Internet connection! 😑'};
  } on Exception catch (e) {
    debugPrint('Request Error: $e');
    return {'status': 'false', 'message': 'Connection Problem! 😐'};
  }
}
