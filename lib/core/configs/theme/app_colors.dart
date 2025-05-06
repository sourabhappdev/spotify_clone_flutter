import 'package:flutter/material.dart';

class AppColors {
  static final AppColors instance = AppColors._();

  factory AppColors() {
    return instance;
  }

  AppColors._();

  static const primary = Color(0xff42C83C);
  static const blueText = Color(0xff288CE9);
  static const lightBackground = Color(0xffF2F2F2);
  static const darkBackground = Color(0xff0D0C0C);
  static const grey = Color(0xffBEBEBE);
  static const darkGrey = Color(0xff343434);
}
