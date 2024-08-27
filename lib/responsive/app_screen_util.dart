import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppScreenUtil {
  static late double screenWidth;
  static late double screenHeight;
  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultipiler;
  static late double widthMultipiler;
  static late double radiusMultipiler;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;
  void init(BoxConstraints constraints, Orientation orientation) {
    if (orientation == Orientation.portrait) {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = true;
      if (screenWidth < 450) {
        isMobilePortrait = true;
      }
    } else {
      screenWidth = constraints.maxWidth;
      screenHeight = constraints.maxHeight;
      isPortrait = false;
      isMobilePortrait = false;
    }
    textMultiplier = 1.sp;
    imageSizeMultiplier = 1;
    heightMultipiler = 1.h;
    widthMultipiler = 1.w;
    radiusMultipiler = 1.r;
  }
}

extension SizeExtension on num {
  double get widthMultiplier => this * AppScreenUtil.widthMultipiler;
  double get heightMultiplier => this * AppScreenUtil.heightMultipiler;
  double get imageSizeMultiplier => this * AppScreenUtil.imageSizeMultiplier;
  double get textMultiplier => this * AppScreenUtil.textMultiplier;
  double get radiusMultiplier => this * AppScreenUtil.radiusMultipiler;
  double get toVerticalSizedBox => this * AppScreenUtil.heightMultipiler;
  double get toHorizontalSizedBox => this * AppScreenUtil.widthMultipiler;
}
