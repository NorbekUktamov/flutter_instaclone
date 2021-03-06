import 'dart:convert';
import 'package:http/http.dart';



class HttpService {
  static String BASE = 'fcm.googleapis.com';
  static String API_SEND = '/fcm/send';
  static Map<String, String> headers = {
    'Authorization': 'key=AAAA-DjBcUI:APA91bG_A7y1TW_oHbKgqJ0fToTv_3s_92TZUZ93DeTalj6KYBKrPoP023qWLF9vSseDVZtgsezuz0hsR88MJAZDo6UdjKDM8OUqn2YtHDyOl_0W9wazoM6-VOK1WBrom_71NtL7-wS6',
    'Content-Type': 'application/json'
  };

  static Future<String?> POST(Map<String, dynamic> body) async {
    var uri = Uri.https(BASE, API_SEND);
    var response = await post(uri, headers: headers, body: jsonEncode(body));
    if(response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }


  static Map<String, dynamic> bodyFollow(String fcmToken, String myName) {
    Map<String, dynamic> body = {};
    body.addAll({
      'notification': {
        'title': 'Instagram',
        'body': '$myName started following you'
      },
      'registration_ids': [fcmToken],
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    });
    return body;
  }

  static Map<String, dynamic> bodyLike(String fcmToken, String myName) {
    Map<String, dynamic> body = {};
    body.addAll({
      'notification': {
        'title': 'Instagram',
        'body': '$myName liked your post'
      },
      'registration_ids': [fcmToken],
      'click_action': 'FLUTTER_NOTIFICATION_CLICK'
    });
    return body;
  }
}