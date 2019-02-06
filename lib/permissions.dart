// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

/// Permission management for Android

Future<void> dialNumber(String phoneNumber, BuildContext context) async {
  assert(phoneNumber != null && phoneNumber.isNotEmpty);
  const platform = MethodChannel('dev.flutter.dialer/dialer');

  try {
    print('Invoking remote');
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
  const platform = MethodChannel('dev.flutter.permissions/permissions');
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
/// This is asynchronous; listen for incoming meothd channel XX for response
Future<bool> requestPermission(String permission, BuildContext context) async {
  const platform = MethodChannel('dev.flutter.permissions/permissions');
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
