// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:scoped_model/scoped_model.dart';

import 'package:audioplayers/audio_cache.dart';

final digitTextStyle = TextStyle(fontSize: 40);
final flatDigitColor = Color(0xff2969ff);

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

/// Dialer is a stateful widget. It holds the phone number model
/// which will preserve the model state between hot reloads
class Dialer extends StatefulWidget {
  @override
  createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  final model = PhoneNumberModel();

  @override
  Widget build(BuildContext context) {
    return ScopedModel<PhoneNumberModel>(
      model: model,
      child: Column(children: <Widget>[
        NumberReadout(),
        NumberPad(),
        SizedBox(height: 50),
        DialButton(),
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
                .map<Widget>((char) => FlatDigitButton(char: char))
                .toList(),
          ),
        ],
      ),
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
              fillColor: Colors.white,
              padding: const EdgeInsets.all(10),
              child: Text(char, style: digitTextStyle),
              onPressed: () => model.addDigit(char),
            ),
      ),
    );
  }
}

class FlatDigitButton extends StatelessWidget {
  FlatDigitButton({this.char});
  final String char;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ScopedModelDescendant<PhoneNumberModel>(
        rebuildOnChange: false,
        builder: (context, _, model) => FlatButton(
              child: Text(char,
                  style: digitTextStyle.copyWith(color: flatDigitColor)),
              onPressed: () => model.addDigit(char),
            ),
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
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ScopedModelDescendant<PhoneNumberModel>(
              builder: (context, _, model) {
                return Text(
                  model.number,
                  textAlign: TextAlign.center,
                  style: digitTextStyle,
                );
              },
            ),
          ),
          ScopedModelDescendant<PhoneNumberModel>(
            rebuildOnChange: false,
            builder: (context, _, model) {
              return IconButton(
                icon: Icon(Icons.backspace),
                onPressed: () => model.removeDigit(),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Dials the entered phone number
class DialButton extends StatelessWidget {
  static const platform = MethodChannel('dev.flutter.dialer/dialer');

  Future<void> _dialNumber(String phoneNumber, BuildContext context) async {
    assert(phoneNumber != null && phoneNumber.isNotEmpty);
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

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<PhoneNumberModel>(
      builder: (context, _, model) => FloatingActionButton(
            child: Icon(Icons.phone),
            onPressed: () => model._number.isNotEmpty
                ? _dialNumber(model._number, context)
                : null,
          ),
    );
  }
}

/// Model for the entered phone number
class PhoneNumberModel extends Model {
  /// Represented as a string to handle chars like #, *
  var _number = '';

  String get number => _formatPhoneNumber(_number);

  void addDigit(String digit) {
    _number += digit;
    notifyListeners();
  }

  void removeDigit() {
    if (_number.length > 0) {
      _number = _number.substring(0, _number.length - 1);
      notifyListeners();
    }
  }
}

String _formatPhoneNumber(String number) {
  switch (number.length) {
    case (0):
    case (1):
    case (2):
    case (3):
      return number;
    case (4):
    case (5):
    case (6):
    case (7):
      return ('${number.substring(0, 3)}-${number.substring(3)}');
    default:
      return ('(${number.substring(0, 3)}) ${number.substring(3, 6)}-${number.substring(6)}');
  }
}

void playSound(String asset) {
  final player = AudioCache();
  // player.play('beep.mp3');
}
