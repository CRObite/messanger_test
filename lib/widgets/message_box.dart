import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:messanger_test/presentation/message_page_cubit/message_page_cubit.dart';
import 'package:messanger_test/widgets/svg_icon.dart';

import '../config/app_colors.dart';
import '../config/app_styles.dart';
import '../domain/message.dart';
import '../domain/user.dart';
import '../util/message_box_painter.dart';

Widget messageBox( Message message, User currentUser, MessagePageCubit messagePageCubit) {
  bool isCurrentUser = message.senderUUID == currentUser.uuid;

  return Align(
    alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Padding(
      padding: EdgeInsets.only(bottom: 6,left: isCurrentUser? 57:0,right: isCurrentUser? 0:57,),
      child: CustomPaint(
        painter: MessageBoxPainter(isCurrentUser: isCurrentUser),
        child: Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.only(top: 4,left: isCurrentUser?4:14,right: isCurrentUser? 14:4,bottom: 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                if(message.image != null)
                  ...[
                    ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(19),
                          topRight: Radius.circular(19),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                        child: Image.memory(message.image!)
                    ),
                    SizedBox(height: 8,)
                  ],

                if(message.file != null)
                  ...[
                    GestureDetector(
                      onTap: (){
                        messagePageCubit.saveFile(
                          message.file!.fileData!,
                          message.file!.fileName,
                        );
                      },
                      child: Row(
                        children: [

                          Container(
                            decoration: BoxDecoration(
                                color: AppColors.fieldGrey,
                                shape: BoxShape.circle
                            ),
                            padding: EdgeInsets.all(8),
                            child: Icon(
                                Icons.download_rounded,
                                size: 24,
                                color: isCurrentUser
                                    ? AppColors.myMessageTextGrey
                                    : AppColors.otherMessageTextGrey
                            ),
                          ),

                          SizedBox(width: 12,),

                          Flexible(
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              message.file?.fileName ?? '',
                              style: isCurrentUser
                                  ?AppStyles.messageDateText.copyWith(color:AppColors.myMessageTextGrey)
                                  :AppStyles.messageDateText.copyWith(color:AppColors.otherMessageTextGrey),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 8,)
                  ],


                Row(
                  mainAxisSize: message.image == null && message.file == null
                      ? MainAxisSize.min
                      : MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(message.text, style: isCurrentUser
                            ?AppStyles.messageDateText.copyWith(color:AppColors.myMessageTextGrey)
                            :AppStyles.messageDateText.copyWith(color:AppColors.otherMessageTextGrey),
                        ),
                      ),
                    ),
                    SizedBox(width: 12,),
                    Row(
                      children: [
                        Text(DateFormat('HH:mm').format(message.timestamp),
                          style: AppStyles.messageSubTitleText.copyWith(color: AppColors.myMessageTextGrey),),
                        SizedBox(width: 12,),
                        isCurrentUser
                            ? message.read
                            ? SvgIcon(assetName: 'assets/icons/double_check.svg',height: 12,color: AppColors.myMessageTextGrey,)
                            : SvgIcon(assetName: 'assets/icons/check.svg',height: 12,color: AppColors.myMessageTextGrey)
                            : SizedBox()
                      ],
                    )
                  ],
                ),
              ],
            )
        ),
      ),
    ),
  );
}