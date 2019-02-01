// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
    return Column(children: <Widget>[
      NumPad(),
      SizedBox(height: 50),
      DialButton(),
    ]);
  }
}

class NumPad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Table(
      children: <TableRow>[
        TableRow(
          children: ['1', '2', '3']
              .map<Widget>((char) => DigitButton(char: char))
              .toList(),
        ),
        TableRow(
          children: ['4', '5', '6']
              .map<Widget>((char) => DigitButton(char: char))
              .toList(),
        ),
        TableRow(
          children: ['7', '8', '9']
              .map<Widget>((char) => DigitButton(char: char))
              .toList(),
        ),
        TableRow(
          children: ['*', '0', '#']
              .map<Widget>((char) => DigitButton(char: char))
              .toList(),
        ),
      ],
    );
  }
}

class DigitButton extends StatelessWidget {
  DigitButton({this.char});
  final String char;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RawMaterialButton(
        shape: CircleBorder(),
        elevation: 6,
        fillColor: Colors.grey,
        padding: const EdgeInsets.all(25),
        child: Text(char),
        onPressed: () {},
      ),
    );
  }
}

class DialButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.phone),
      onPressed: () {},
    );
  }
}
