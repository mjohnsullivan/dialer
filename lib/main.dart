// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:dialer/widgets.dart';
import 'package:dialer/theme.dart';

void main() => runApp(
      Builder(
        builder: (context) => MaterialApp(
              theme: phoneTheme(context),
              title: 'Flutter Dialer',
              home: Scaffold(
                body: SafeArea(
                    child: DialerData(
                  child: DialerApp(),
                )),
              ),
            ),
      ),
    );

class DialerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Hello MWC!'));
  }
}
