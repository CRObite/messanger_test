
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messanger_test/config/app_colors.dart';
import 'package:messanger_test/config/app_styles.dart';

import '../widgets/common_text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(169),
        child: Column(
          children: [
            AppBar(
              title: Text('Чаты',style: AppStyles.titleText),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 6,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CommonTextField(
                hint: 'Поиск',
                prefixIcon: 'assets/icons/search.svg',
              )
            ),
            SizedBox(height: 24,),
            Divider(
              color: AppColors.borderGrey,
            )
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
            itemCount: 5,
            itemBuilder: (context,index){
              return GestureDetector(
                onTap: (){
                  context.pushNamed('message');
                },
                child: Container(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Виктор Власов',style: AppStyles.messageUserText,),
                              Text('Я готов',style: AppStyles.messageSubTitleText,),
                            ],
                          ),
                        ],
                      ),

                      SizedBox(width: 12,),

                      SizedBox(
                        width: 80,
                          child: Align(
                            alignment: Alignment.centerRight,
                              child: Text('Вчера')
                          )
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }
}
