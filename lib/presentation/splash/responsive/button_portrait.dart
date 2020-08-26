import 'dart:io';

import 'package:flipper/generated/l10n.dart';
import 'package:flipper/presentation/splash/popup.dart';
import 'package:flipper/presentation/splash/popup_content.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';

class ButtonPortrait extends StatefulWidget {
  const ButtonPortrait({
    Key key,
  }) : super(key: key);

  @override
  _ButtonPortraitState createState() => _ButtonPortraitState();
}

class _ButtonPortraitState extends State<ButtonPortrait> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 2,
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              height: 20,
            ),
            Container(
              color: Colors.blue,
              child: SizedBox(
                width: 380,
                height: 60,
                child: FlatButton(
                  onPressed: () async {
                    // implement register.
                     Routing.navigator.pushNamed(Routing.flipperLogin);
                  },
                  color: Colors.blue,
                  child: Text(
                    S.of(context).createAccount,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 20,
            ),
            Container(
              color: Colors.white,
              child: SizedBox(
                width: 380,
                height: 60,
                child: OutlineButton(
                  color: Colors.blue,
                  child: Text(
                    S.of(context).signIn,
                    style: const TextStyle(color: Colors.blue),
                  ),
                  onPressed: () {
                    Routing.navigator.pushNamed(Routing.flipperLogin);
                  },
                ),
              ),
            ),
            Container(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  showPopup(BuildContext context, Widget widget, {BuildContext popupContext}) {
    Navigator.push(
      context,
      PopupLayout(
        top: 30,
        left: 30,
        right: 30,
        bottom: 50,
        child: PopupContent(
          content: Scaffold(
            resizeToAvoidBottomPadding: false,
            body: widget,
          ),
        ),
      ),
    );
  }
}
