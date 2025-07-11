import 'package:flutter/material.dart';

extension SizeDeviceUtil on BuildContext {
  Size get sizeDevice => MediaQuery.of(this).size;
}