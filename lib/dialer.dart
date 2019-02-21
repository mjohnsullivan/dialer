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
      home: Scaffold(
          body: SafeArea(
        child: Dialer(),
      )),
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
        FlutterLogo(size: 50),
      ]),
    );
  }
}

class NumberPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Table(
        children: <TableRow>[
          TableRow(
            children: ['1', '2', '3']
                .map<Widget>((char) => FlatDigitButton(char: char))
                .toList(),
          ),
          TableRow(
            children: ['4', '5', '6']
                .map<Widget>((char) => FlatDigitButton(char: char))
                .toList(),
          ),
          TableRow(
            children: ['7', '8', '9']
                .map<Widget>((char) => FlatDigitButton(char: char))
                .toList(),
          ),
          TableRow(
            children: ['*', '0', '#']
                .map<Widget>((char) => FlatDigitButton(char: char))
                .toList(),
          ),
        ],
      ),
    );
  }
}

/// Displays the entered phone number
class NumberReadout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: darkBlue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          PhoneNumberDisplay(),
          DeleteButton(),
        ],
      ),
    );
  }
}
