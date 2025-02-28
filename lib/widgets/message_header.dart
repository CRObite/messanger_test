import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/app_colors.dart';
import '../config/app_styles.dart';

Widget dateHeader(String date) {
  final String today = DateFormat('dd.MM.yyyy').format(DateTime.now());
  return Row(
    children: [
      Expanded(child: Divider(color: AppColors.iconGrey,)),
      SizedBox(width: 10,),
      Text(date == today ? "Сегодня" : date,style: AppStyles.messageDateText,),
      SizedBox(width: 10,),
      Expanded(child: Divider(color: AppColors.iconGrey,)),
    ],
  );
}
