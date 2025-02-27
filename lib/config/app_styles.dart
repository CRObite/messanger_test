import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppStyles{
  static TextStyle titleText = TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600
  );

  static TextStyle messageUserText = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600
  );


  static TextStyle messageSubTitleText = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.messageTimeSubTitleGrey
  );

  static TextStyle fieldHintText = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.iconGrey
  );

  static TextStyle messageDateText = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.iconGrey
  );


  static TextStyle userNoAvatarTextText = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: Colors.white
  );


}