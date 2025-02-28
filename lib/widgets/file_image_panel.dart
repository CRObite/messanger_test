import 'package:flutter/material.dart';
import 'package:messanger_test/presentation/message_page_cubit/message_page_cubit.dart';
import 'package:messanger_test/widgets/svg_icon.dart';

import '../config/app_colors.dart';

Widget fileImagePanel(BuildContext context, MessagePageCubit messagePageCubit, String senderUUID, String receiverUUID) {
  return Row(
    children: [
      GestureDetector(
        onTap: () => messagePageCubit.setSelectedImage(
          senderUUID,
          receiverUUID
        ),

        child: circleButton('assets/icons/image.svg'),
      ),
      SizedBox(width: 8),
      GestureDetector(
        onTap: () => messagePageCubit.setFile(
            senderUUID,
            receiverUUID
        ),
        child: circleButton('assets/icons/file.svg'),
      ),
    ],
  );
}

Widget circleButton(String iconPath) {
  return Container(
    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.fieldGrey),
    padding: EdgeInsets.all(8),
    child: Center(
      child: SvgIcon(assetName: iconPath, width: 24, height: 24),
    ),
  );
}
