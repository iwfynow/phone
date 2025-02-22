import 'package:flutter/services.dart';

class ContactService {
  static const platformMessage = MethodChannel('com.example.sms/sender');
  static const platformCall = MethodChannel("com.example.phone_book/calls");
  static const platformCallLog = MethodChannel('call_log_channel');
  
  static makeCall(String phoneNumber) async{
    await platformCall.invokeMethod('makePhoneCall', {'phoneNumber': phoneNumber});
  }
  
  static Future<void> sendSms(String phoneNumber, String message) async {
    try {
      await platformMessage.invokeMethod('sendSms', {
        'phoneNumber': phoneNumber,
        'message': message,
      });
    } on PlatformException {}
  }

  static Future<List<Map>> getCallLogs() async {
    try {
      final List<dynamic> logs = await platformCallLog.invokeMethod('getCallLogs');
      return logs.cast<Map>();
    } on PlatformException {
      return [];
    }
  }
}