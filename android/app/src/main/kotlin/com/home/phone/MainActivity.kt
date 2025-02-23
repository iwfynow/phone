package com.home.phone

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.database.Cursor
import android.provider.CallLog

import android.telephony.SmsManager

class MainActivity : FlutterActivity() {
    private val CALL_CHANNEL = "com.home.phone/calls"
    private val SMS_CHANNEL = "com.home.sms/sender"
    private val CALL_LOG_CHANNEL = "call_log_channel"
    private var pendingPhoneNumber: String? = null
    private var pendingMessage: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CALL_LOG_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getCallLogs") {
                result.success(getCallLogs())
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CALL_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "makePhoneCall") {
                val phoneNumber = call.argument<String>("phoneNumber")
                makePhoneCall(phoneNumber)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, SMS_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "sendSms") {
                val phoneNumber = call.argument<String>("phoneNumber")
                val message = call.argument<String>("message")
                if (phoneNumber.isNullOrEmpty() || message.isNullOrEmpty()) {
                    result.error("INVALID_ARGUMENTS", "Phone number or message is null or empty", null)
                } else {
                    sendSms(phoneNumber, message)
                    result.success(null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun makePhoneCall(phoneNumber: String?) {
        if (phoneNumber != null) {
            if (ActivityCompat.checkSelfPermission(this, Manifest.permission.CALL_PHONE) != PackageManager.PERMISSION_GRANTED) {
                ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.CALL_PHONE), 2)
            } else {
                val intent = Intent(Intent.ACTION_CALL)
                intent.data = Uri.parse("tel:$phoneNumber")
                startActivity(intent)
            }
        }
    }

    private fun sendSms(phoneNumber: String, message: String) {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.SEND_SMS) != PackageManager.PERMISSION_GRANTED) {
            pendingPhoneNumber = phoneNumber
            pendingMessage = message
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.SEND_SMS), 3)
        } else {
            try {
                val smsManager: SmsManager = SmsManager.getDefault()
                smsManager.sendTextMessage(phoneNumber, null, message, null, null)
                println("SMS успешно отправлено")
            } catch (e: Exception) {
                println("Ошибка при отправке SMS: ${e.message}")
            }
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    
        if (requestCode == 1) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                println("Разрешение на журнал звонков предоставлено")
                getCallLogs()
            } else {
                println("Разрешение на журнал звонков отклонено")
            }
        }
    
        if (requestCode == 2) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                println("Разрешение на звонки предоставлено")
            } else {
                println("Разрешение на звонки отклонено")
            }
        }
    
        if (requestCode == 3) {
            if (grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                println("Разрешение на SMS предоставлено")
                if (pendingPhoneNumber != null && pendingMessage != null) {
                    sendSms(pendingPhoneNumber!!, pendingMessage!!)
                    pendingPhoneNumber = null
                    pendingMessage = null
                }
            } else {
                println("Разрешение на SMS отклонено")
            }
        }
    }

    private fun getCallLogs(): List<Map<String, String>> {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.READ_CALL_LOG) != PackageManager.PERMISSION_GRANTED) {
            ActivityCompat.requestPermissions(this, arrayOf(Manifest.permission.READ_CALL_LOG), 1)
            return emptyList();
        } else{
            val callLogs = mutableListOf<Map<String, String>>()
            val cursor: Cursor? = contentResolver.query(
                CallLog.Calls.CONTENT_URI,
                null, null, null, CallLog.Calls.DATE + " DESC"
            )
            cursor?.use {
                while (it.moveToNext()) {
                    val number = it.getString(it.getColumnIndexOrThrow(CallLog.Calls.NUMBER))
                    val type = it.getString(it.getColumnIndexOrThrow(CallLog.Calls.TYPE))
                    val date = it.getString(it.getColumnIndexOrThrow(CallLog.Calls.DATE))

                    callLogs.add(
                        mapOf(
                            "number" to number,
                            "type" to type,
                            "date" to date
                        )
                    )
                }
            }
            return callLogs
        }
    }
}