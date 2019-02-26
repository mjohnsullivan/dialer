// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

final darkBlue = Color(0xff2969ff);

/// Returns the theme for the app
ThemeData phoneTheme(BuildContext context) => ThemeData(
      iconTheme: IconThemeData(
        color: darkBlue,
      ),
      primarySwatch: Colors.blue,
      primaryColor: darkBlue,
      textTheme: Theme.of(context).textTheme.apply(
            bodyColor: Colors.green,
            fontSizeFactor: 3,
          ),
    );
