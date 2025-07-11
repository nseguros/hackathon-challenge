import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTexfieldComponent extends StatefulWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController? controller;
  final bool isPasswordField;
  final TextInputType? keyboardType;
  const CustomTexfieldComponent({super.key, required this.labelText, required this.prefixIcon, this.controller, this.isPasswordField = false, this.keyboardType});

  @override
  State<CustomTexfieldComponent> createState() => _CustomTexfieldComponentState();
}

class _CustomTexfieldComponentState extends State<CustomTexfieldComponent> {
  bool _isPasswordVisible = false;
  
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: widget.isPasswordField ? !_isPasswordVisible : false,
      controller: widget.controller,
      keyboardType: widget.keyboardType ?? TextInputType.text,
      onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
      decoration: InputDecoration(
        labelText: widget.labelText,
        prefixIcon: Icon(widget.prefixIcon),
        suffixIcon: !widget.isPasswordField ? SizedBox() :  IconButton(
          icon: Icon(
            _isPasswordVisible ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
            color: Colors.grey,
          ),
          onPressed: () => setState(() {
            _isPasswordVisible = !_isPasswordVisible;
          })
        )
      )
    );
  }
}
