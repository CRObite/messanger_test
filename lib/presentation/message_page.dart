
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messanger_test/widgets/svg_icon.dart';

import '../config/app_colors.dart';
import '../config/app_styles.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: (){context.pop();},
                      icon: SvgIcon(assetName: 'assets/icons/arrow_back.svg'),
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          height: 50,
                          width: 50,
                        ),

                        SizedBox(width: 12,),

                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Виктор Власов',style: AppStyles.messageUserText,),
                            Text('В сети',style: AppStyles.messageSubTitleText,),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12,),
              Divider(
                color: AppColors.borderGrey,
              )
            ],
          ),
        ),
      ),
      body: Container(color:Colors.white,),
    );
  }
}
