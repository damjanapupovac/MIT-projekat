import 'package:flutter/material.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({
    super.key,
    required this.label,
    this.fontSize = 16,
    this.fontStyle = FontStyle.normal,
    this.fontWeight = FontWeight.w500,
    this.color,
    this.textDecoration = TextDecoration.none,
    this.letterSpacing = 0.5,
  });

  final String label;
  final double fontSize;
  final FontStyle fontStyle;
  final FontWeight fontWeight;
  final Color? color;
  final TextDecoration textDecoration;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: fontSize,
            fontWeight: fontWeight,
            fontStyle: fontStyle,
            decoration: textDecoration,
            letterSpacing: letterSpacing,
            color: color, 
          ),
    );
  }
}
