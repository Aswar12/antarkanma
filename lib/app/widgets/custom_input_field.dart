import 'package:flutter/material.dart';
import 'package:antarkanma/theme.dart';

class CustomInputField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool initialObscureText;
  final String iconPath;
  final bool showVisibilityToggle;

  const CustomInputField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.validator,
    this.initialObscureText = false,
    required this.iconPath,
    this.showVisibilityToggle = false,
  }) : super(key: key);

  @override
  _CustomInputFieldState createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  late bool _obscureText;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.initialObscureText;
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: backgroundColor2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isFocused ? logoColorSecondary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                SizedBox(width: 16),
                Image.asset(
                  widget.iconPath,
                  width: 17,
                  color: _isFocused ? logoColorSecondary : Colors.grey,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        _isFocused = hasFocus;
                      });
                    },
                    child: TextFormField(
                      style: primaryTextStyle,
                      obscureText: _obscureText,
                      controller: widget.controller,
                      validator: widget.validator,
                      decoration: InputDecoration(
                        hintText: widget.hintText,
                        hintStyle: subtitleTextStyle,
                        border: InputBorder.none,
                        isCollapsed: true,
                      ),
                    ),
                  ),
                ),
                if (widget.showVisibilityToggle)
                  GestureDetector(
                    onTap: _toggleVisibility,
                    child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: _isFocused ? logoColorSecondary : Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
