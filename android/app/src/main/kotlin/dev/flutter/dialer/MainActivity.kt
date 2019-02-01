// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.flutter.dialer

import android.annotation.SuppressLint
import android.content.Intent
import android.net.Uri
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
  private val channel = "dev.flutter.dialer/dialer"

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, channel).setMethodCallHandler { call, result ->
      print("Phone dialer called in Kotlin")
      when (call.method) {
        "dial" -> result.success(callPhoneNumber(call.arguments as String))
        else -> result.notImplemented()
      }
    }
  }

  /*
   * Fires an intent to start a phone call
   * TODO: This should check for appropriate permission and fail gracefully
   */
  @SuppressLint("MissingPermission")
  fun callPhoneNumber(number: String) {
    // If you're using Anko, just use 'makeCall(number)'

    val intent = Intent(Intent.ACTION_CALL)
    intent.data = Uri.parse("tel:$number")
    startActivity(intent)
  }
}
