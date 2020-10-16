import 'package:flutter/material.dart';

class ReusableCard extends StatelessWidget {
  final Color color;
  final Widget child;
  final int flex;
  final Function gestureActionOnTap;
  ReusableCard({
    @required this.color,
    this.child,
    this.gestureActionOnTap,
    this.flex: 1,
  });
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: GestureDetector(
        onTap: gestureActionOnTap,
        child: Container(
          child: Center(
            child: child,
          ),
          margin: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
