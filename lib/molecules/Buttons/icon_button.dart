import 'package:flutter/material.dart';

class NIconButton extends StatelessWidget {
  // final String? svgPath;
  final Widget? icon;
  final VoidCallback onPressed;
  final Color backgroundColor;
  // final Color? iconColor;
  final double size;
  // final double iconSize;
  final double borderRadius;

  const NIconButton({
    Key? key,
    // this.svgPath,
    this.icon,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    // this.iconColor,
    this.size = 35,
    // this.iconSize = 24,
    this.borderRadius = 8.0,
  });
      

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(borderRadius),
        color: backgroundColor,
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(
          minWidth: size,
          minHeight: size,
        ),
        icon: icon ?? Icon(Icons.do_not_disturb),
        onPressed: onPressed,
      ),
    );
  }
}