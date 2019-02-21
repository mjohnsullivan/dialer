// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/widgets.dart';

/// Provider for a phone number
class PhoneNumber with ChangeNotifier {
  /// Represented as a string to handle chars like #, *
  var _number = '';

  String get number => _number;
  String get formattedNumber => _formatPhoneNumber(_number);
  bool get hasNumber => _number.isNotEmpty;

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

/// Pretty-print a phone number
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
