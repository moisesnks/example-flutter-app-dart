import 'package:flutter/material.dart';

class CustomText extends StatefulWidget {
  final String text;
  final String labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomText({
    required this.text,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  CustomTextState createState() => CustomTextState();
}

class CustomTextState extends State<CustomText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (widget.prefixIcon != null) widget.prefixIcon!,
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.labelText,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    widget.text,
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          if (widget.suffixIcon != null) widget.suffixIcon!,
        ],
      ),
    );
  }
}
