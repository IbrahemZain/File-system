import 'dart:io';
import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PushNotificationServices {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.configure(
      //app in foreground
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      //app closed completely
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      //app in background
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
  }
}
