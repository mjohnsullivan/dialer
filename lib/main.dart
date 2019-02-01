// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dialer',
      home: Scaffold(
          body: SafeArea(
        child: ScopedModel<PhoneNumberModel>(
          model: PhoneNumberModel(),
          child: Dialer(),
        ),
      )),
    );
  }
}

class Dialer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      NumText(),
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
      child: ScopedModelDescendant<PhoneNumberModel>(
        rebuildOnChange: false,
        builder: (context, _, model) => RawMaterialButton(
              shape: CircleBorder(),
              elevation: 6,
              fillColor: Colors.grey,
              padding: const EdgeInsets.all(20),
              child: Text(char),
              onPressed: () => model.addDigit(char),
            ),
      ),
    );
  }
}

/// Dials the entered phone number
class DialButton extends StatelessWidget {
  static const platform = MethodChannel('dev.flutter.dialer/dialer');

  Future<void> _dialNumber(String phoneNumber) async {
    assert(phoneNumber != null && phoneNumber.isNotEmpty);

    try {
      print('Inovking remote');
      await platform.invokeMethod('dial', phoneNumber);
    } on PlatformException catch (e) {
      print('Unable to dial number *number*: error $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhoneNumberModel>(
      builder: (context, _, model) => FloatingActionButton(
            child: Icon(Icons.phone),
            onPressed: () =>
                model._number.isNotEmpty ? _dialNumber(model._number) : null,
          ),
    );
  }
}

/// Displays the entered phone number
class NumText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ScopedModelDescendant<PhoneNumberModel>(
        builder: (context, _, model) {
          return Text(model.number);
        },
      ),
    );
  }
}

/// Model for the entered phone number
class PhoneNumberModel extends Model {
  /// Represented as a string to handle chars like #, *
  var _number = '';

  String get number => _number;

  void addDigit(String digit) {
    _number += digit;
    notifyListeners();
  }
}
