// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

const platform = MethodChannel('dev.flutter.dialer/dialer');

/// Makes a phone call to the provided phone number
Future<void> dialNumber(String phoneNumber, BuildContext context) async {
  assert(phoneNumber != null && phoneNumber.isNotEmpty);

  try {
    await platform.invokeMethod('dial', <String, String>{
      'number': phoneNumber,
    });
  } on PlatformException catch (e) {
    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text('Unable to dial $phoneNumber: error $e')),
    );
  }
}

/// Check for call permissions
Future<bool> hasPermission(String permission, BuildContext context) async {
  try {
    final granted =
        await platform.invokeMethod('hasPermission', <String, String>{
      'permission': permission,
    });

    Scaffold.of(context).showSnackBar(
      SnackBar(content: Text('Permission $permission is granted: $granted')),
    );

    return granted;
  } on PlatformException catch (e) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
          content: Text('Unable to access permission $permission: error $e')),
    );
    throw e;
  }
}

/// Request for call permission
/// This is asynchronous; listen for incoming method channel XX for response
Future<void> requestPermission(String permission, BuildContext context) async {
  try {
    await platform.invokeMethod('requestPermission', <String, String>{
      'permission': permission,
    });

    //Scaffold.of(context).showSnackBar(
    //  SnackBar(content: Text('Permission $permission is granted: $granted')),
    //);
  } on PlatformException catch (e) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
          content: Text('Unable to access permission $permission: error $e')),
    );
  }
}
