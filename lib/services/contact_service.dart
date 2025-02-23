import 'package:flutter/services.dart';
import 'package:phone/core/error/app_error.dart';

class ContactService {
  static const platformMessage = MethodChannel('com.home.sms/sender');
  static const platformCall = MethodChannel("com.home.phone/calls");
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
    } on PlatformException catch (e) {
      AppError.showErrorToast(e);
    }
  }

  static Future<List<Map>> getCallLogs() async {
    try {
      final List<dynamic> logs = await platformCallLog.invokeMethod('getCallLogs');
      return logs.cast<Map>();
    } on PlatformException catch (e) {
      AppError.showErrorToast(e);
      return [];
    }
  }
}