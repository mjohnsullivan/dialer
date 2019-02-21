// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'package:dialer/widgets.dart';
import 'package:dialer/theme.dart';

class DialerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: phoneTheme(context),
      title: 'Flutter Dialer',
      home: Scaffold(body: SafeArea(child: Dialer())),
    );
  }
}

class Dialer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DialerData(
      child: Column(children: <Widget>[
        NumberReadout(),
        NumberPad(),
        SizedBox(height: 50),
        DialButton(),
        SizedBox(height: 50),
      ]),
    );
  }
}
