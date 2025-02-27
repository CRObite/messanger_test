
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:messanger_test/config/app_colors.dart';
import 'package:messanger_test/config/app_styles.dart';
import 'package:messanger_test/presentation/home_page_cubit/home_page_cubit.dart';

import '../widgets/common_text_field.dart';
import '../widgets/user_message_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomePageCubit homePageCubit = HomePageCubit();

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    homePageCubit.loadUserMessages();

    _searchController.addListener(() {
      homePageCubit.searchUsers(_searchController.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:  PreferredSize(
        preferredSize: Size.fromHeight(160),
        child: Column(
          children: [
            AppBar(
              title: Text('Чаты',style: AppStyles.titleText),
              backgroundColor: Colors.white,
            ),
            SizedBox(height: 6,),
            Container(
              height: 50,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: CommonTextField(
                hint: 'Поиск',
                prefixIcon: 'assets/icons/search.svg',
                controller: _searchController,
              )
            ),
            SizedBox(height: 24,),
            Divider(
              color: AppColors.borderGrey,
            )
          ],
        ),
      ),

      body: BlocProvider(
        create: (context) => homePageCubit,
        child: HomePageBody(
          homePageCubit: homePageCubit
        ),
      )
    );
  }
}


class HomePageBody extends StatelessWidget {
  const HomePageBody({super.key, required this.homePageCubit});

  final HomePageCubit homePageCubit;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocBuilder(
        bloc: homePageCubit,
        builder: (context,state){
          switch (state) {
            case HomePageLoading():
              return const Center(
                child: CircularProgressIndicator(),
              );
            case HomePageError():
              return Center(
                child: Text(
                  state.errorText,
                  style: AppStyles.titleText,
                ),
              );
            case HomePageFetched():
              return ListView.builder(
                itemCount: state.userAndMessages.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed('message',extra: {
                        'currentUser': state.currentUser,
                        'targetUser': state.userAndMessages[index].user,
                      });
                    },
                    child: UserMessageCard(
                      userMessage: state.userAndMessages[index],
                      sender: state.currentUser.uuid == state.userAndMessages[index].lastMessage?.senderUUID,
                    ),
                  );
                },
              );
            default:
              return const SizedBox();
          }

        }
      )
    );
  }
}

