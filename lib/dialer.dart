// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dialer/phone_number.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

import 'package:dialer/permissions.dart';

final digitTextStyle = TextStyle(fontSize: 40);
final darkBlue = Color(0xff2969ff);

class DialerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: darkBlue,
        ),
        // primarySwatch: darkBlue,
        primaryColor: darkBlue,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: darkBlue,
            ),
      ),
      title: 'Flutter Dialer',
      home: Scaffold(
          body: SafeArea(
        child: Dialer(),
      )),
    );
  }
}

/// Dialer is a stateful widget. It holds the phone number
/// and preserves the model state between hot reloads
class Dialer extends StatefulWidget {
  @override
  createState() => _DialerState();
}

class _DialerState extends State<Dialer> {
  final providers = Providers()
    ..provide(Provider.value(
      PhoneNumber(),
    ));

  @override
  Widget build(BuildContext context) {
    return ProviderNode(
      providers: providers,
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

class DigitButton extends StatelessWidget {
  DigitButton({this.char});
  final String char;

  @override
  Widget build(BuildContext context) {
    final phoneNumber = Provide.value<PhoneNumber>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: RawMaterialButton(
        shape: CircleBorder(),
        elevation: 6,
        fillColor: Colors.white,
        padding: const EdgeInsets.all(10),
        child: Text(char, style: digitTextStyle),
        onPressed: () => phoneNumber.addDigit(char),
      ),
    );
  }
}

class FlatDigitButton extends StatelessWidget {
  FlatDigitButton({this.char});
  final String char;

  @override
  Widget build(BuildContext context) {
    final phoneNumber = Provide.value<PhoneNumber>(context);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: FlatButton(
        child: Text(
          char,
          style: digitTextStyle.copyWith(color: darkBlue),
        ),
        onPressed: () => phoneNumber.addDigit(char),
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
          Expanded(
            child: Provide<PhoneNumber>(
              builder: (context, _, phoneNumber) {
                return Text(
                  phoneNumber.formattedNumber,
                  textAlign: TextAlign.center,
                  style: digitTextStyle,
                );
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.backspace),
            onPressed: () => Provide.value<PhoneNumber>(context).removeDigit(),
          ),
        ],
      ),
    );
  }
}

/// Dials the entered phone number
class DialButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<PhoneNumber>(
      builder: (context, _, number) => FloatingActionButton(
            child: Icon(Icons.phone),
            onPressed: () =>
                number.hasNumber ? dialNumber(number.number, context) : null,
          ),
    );
  }
}
