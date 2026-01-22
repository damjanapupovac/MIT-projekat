import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  const TitleText({
    super.key,
    required this.label,
    this.fontSize = 20,
    this.color,
    this.maxLines = 1,
    this.letterSpacing = 0.8,
  });

  final String label;
  final double fontSize;
  final Color? color;
  final int? maxLines;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            letterSpacing: letterSpacing,
            color: color,
          ),
    );
  }
}
