// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.flutter.dialer

import android.Manifest
import android.app.Activity
import android.content.pm.PackageManager
import android.os.Bundle
import android.support.v4.app.ActivityCompat
import android.support.v4.content.ContextCompat

import io.flutter.app.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import org.jetbrains.anko.alert
import org.jetbrains.anko.makeCall
import org.jetbrains.anko.noButton
import org.jetbrains.anko.yesButton


class MainActivity: FlutterActivity() {
  private val channel = "dev.flutter.dialer/dialer"
  private val permissionsRequestCode = 11011
  private var number: String? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    MethodChannel(flutterView, channel).setMethodCallHandler { call, result ->
      print("Phone dialer called in Kotlin")
      when (call.method) {
        "dial" -> {
          val number = call.argument<String>("number")
          number?.let {
            callPhoneNumber(number)
          }
        }
        else -> result.notImplemented()
      }
    }
  }

  /*
   * Fires an intent to start a phone call
   * TODO: This should check for appropriate permission and fail gracefully
   */
  private fun callPhoneNumber(number: String) {
    // If you're using Anko, just use 'makeCall(number)'
    this.number = number
    if (isPermissionGranted(Manifest.permission.CALL_PHONE)) {
      makeCall(number)
    } else {
      showPermissionReasonAndRequest(
              "Dialer",
              "Hello there. We need your permission to make a phone call. " +
                      "If this is what you'd like to do, " +
                      "please grant it.",
              Manifest.permission.CALL_PHONE,
              this.permissionsRequestCode
      )
    }
  }

  /*
   * Request permission to make a phone call
   */
  private fun Activity.showPermissionReasonAndRequest(
          title: String,
          message: String,
          permission: String,
          requestCode: Int) {
    alert(
            message,
            title
    ) {
      yesButton {
        ActivityCompat.requestPermissions(
                this@showPermissionReasonAndRequest,
                arrayOf(permission),
                requestCode
        )
      }
      noButton { }
    }.show()
  }

  override fun onRequestPermissionsResult(requestCode: Int,
                                          permissions: Array<String>,
                                          grantResults: IntArray) {
    when (requestCode) {
      permissionsRequestCode -> {
        // If request is cancelled, the result arrays are empty.
        if ((grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED)) {
          number?.let {
            makeCall(it)
          }
        } else {
          // permission denied, boo! Disable the
          // functionality that depends on this permission.
        }
        return
      }

      // Add other 'when' lines to check for other
      // permissions this app might request.
      else -> {
        // Ignore all other requests.
      }
    }
  }

  private fun isPermissionGranted(permission:String):Boolean =
          ContextCompat.checkSelfPermission(
                  this,
                  permission
          ) == PackageManager.PERMISSION_GRANTED

}