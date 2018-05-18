import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_aurora/res/colors.dart';

class RippleCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  RippleCard({@required this.child,@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return
      new Card(
        child: new Stack(
          children: <Widget>[
            new Positioned.fill(
              child: child,
            ),
            new Material(
              color: Colors.transparent,
              child: new InkWell(
                highlightColor: Colors.transparent,
                enableFeedback: false,
                splashColor: AuroraColors.ripplrColor,
                onTap: () {},
              ),
            ),
          ],
        ),
      );
  }

}class RippleRaisedCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  RippleRaisedCard({@required this.child,@required this.onTap});

  @override
  Widget build(BuildContext context) {
    return
      new RaisedButton(
        onPressed: (){},
        elevation: 1.0,
        padding: new EdgeInsets.all(0.0),
        child: new Stack(
          children: <Widget>[
            child,
            new Material(
              color: Colors.transparent,
              child: new InkWell(
                splashColor: AuroraColors.ripplrColor,
                highlightColor: Colors.transparent,
                onTap: onTap,
              ),
            ),
          ],
        ),
      );
  }

}