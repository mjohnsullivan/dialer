// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:dialer/permissions.dart';
import 'package:dialer/theme.dart';
import 'package:flutter/material.dart';
import 'package:provide/provide.dart';

import 'package:dialer/phone_number.dart';

/// DialerData is a stateful widget. It holds the phone number
/// and preserves the model state between hot reloads
class DialerData extends StatefulWidget {
  DialerData({Key key, this.child}) : super(key: key);
  final Widget child;

  @override
  createState() => _DialerDataState();
}

class _DialerDataState extends State<DialerData> {
  final providers = Providers()
    ..provide(Provider.value(
      PhoneNumber(),
    ));

  @override
  Widget build(BuildContext context) {
    return ProviderNode(
      providers: providers,
      child: widget.child,
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

/// Delete button for phone number
class DeleteButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.backspace),
      onPressed: () => Provide.value<PhoneNumber>(context).removeDigit(),
    );
  }
}

/// Phone number display
class PhoneNumberDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Provide<PhoneNumber>(
        builder: (context, _, phoneNumber) {
          return Text(
            phoneNumber.formattedNumber,
            textAlign: TextAlign.center,
            style: digitTextStyle,
          );
        },
      ),
    );
  }
}
