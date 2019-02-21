import 'package:dialer/dialer.dart';
import 'package:flutter/material.dart';

class FlutterDialer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              colors: <Color>[
                Colors.cyan,
                Colors.white,
              ],
            )),
            child: Opacity(
              opacity: 0.2,
              child: FlutterLogo(),
            ),
          ),
        ),
        Dialer(),
      ],
    );
  }
}
