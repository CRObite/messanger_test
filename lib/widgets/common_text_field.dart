import 'package:flutter/material.dart';
import 'package:messanger_test/config/app_styles.dart';
import 'package:messanger_test/widgets/svg_icon.dart';

import '../config/app_colors.dart';

class CommonTextField extends StatelessWidget {
  const CommonTextField({super.key, required this.hint, this.prefixIcon = '', required this.controller});

  final TextEditingController controller;
  final String hint;
  final String prefixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(decoration: TextDecoration.none,decorationThickness: 0),
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppStyles.fieldHintText,
        fillColor: AppColors.fieldGrey,
        filled: true,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),

        contentPadding: EdgeInsets.only(
          left: 8,
          right: 8,

        ),
        prefixIcon: prefixIcon.isNotEmpty?  Padding(
          padding: const EdgeInsets.all(8.0),
          child: SvgIcon(
            assetName: prefixIcon,
            color: AppColors.iconGrey,
          ),
        ): null,

      ),
    );
  }
}
