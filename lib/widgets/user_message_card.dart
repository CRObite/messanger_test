
import 'package:flutter/material.dart';
import 'package:messanger_test/domain/user_message.dart';


import '../config/app_colors.dart';
import '../config/app_styles.dart';
import '../config/timeago_formatter.dart';

class UserMessageCard extends StatelessWidget {
  const UserMessageCard({super.key, required this.userMessage, required this.sender});

  final UserMessage userMessage;
  final bool sender;

  @override
  Widget build(BuildContext context) {


    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border:Border(
            bottom: BorderSide(width: 1,color: AppColors.borderGrey),
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: CircleAvatar(
                    foregroundImage: userMessage.user.avatar != null
                        ? MemoryImage(userMessage.user.avatar!)
                        : null,
                    backgroundColor: userMessage.user.avatar == null
                        ? userMessage.user.noAvatarColor
                        : null,
                    child: userMessage.user.avatar == null
                        ? Text('${userMessage.user.name[0]}${userMessage.user.surname[0]}',style: AppStyles.userNoAvatarTextText,)
                        : null,
                  )
                ),
            
                SizedBox(width: 12,),
            
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${userMessage.user.name} ${userMessage.user.surname}',
                        overflow: TextOverflow.ellipsis,
                        style: AppStyles.messageUserText,
                      ),
                      Text.rich(
                        overflow: TextOverflow.ellipsis,
                        TextSpan(
                          children: [
                            if (sender) TextSpan(
                              text: 'Вы:',
                              style: AppStyles.messageSubTitleText.copyWith(color: Colors.black),
                            ),
                            TextSpan(
                              text: userMessage.lastMessage?.text ?? '',
                              style: AppStyles.messageSubTitleText,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12,),

          userMessage.lastMessage != null ? SizedBox(
            width: 90,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                TimeagoFormatter.getTimeagoFormat(userMessage.lastMessage!.timestamp),
                style: AppStyles.messageSubTitleText,
              )
            )
          ): SizedBox()
        ],
      ),
    );
  }
}
