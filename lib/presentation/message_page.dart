
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:messanger_test/config/message_box_painter.dart';
import 'package:messanger_test/presentation/message_page_cubit/message_page_cubit.dart';
import 'package:messanger_test/widgets/common_text_field.dart';
import 'package:messanger_test/widgets/svg_icon.dart';


import '../config/app_colors.dart';
import '../config/app_styles.dart';
import '../domain/message.dart';
import '../domain/user.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key, required this.currentUser, required this.targetUser});

  final User currentUser;
  final User targetUser;

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {

  MessagePageCubit messagePageCubit = MessagePageCubit();
  bool messageStarted = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    messagePageCubit.loadMessages(
        widget.currentUser.uuid,
        widget.targetUser.uuid
    );

    _messageController.addListener(() {
      if(_messageController.text.isNotEmpty){
        setState(() {
          messageStarted = true;
        });
      }else{
        setState(() {
          messageStarted = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

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

                    Flexible(
                      child: Row(
                        children: [
                          SizedBox(
                              height: 50,
                              width: 50,
                              child: CircleAvatar(
                                foregroundImage: widget.targetUser.avatar != null
                                    ? MemoryImage(widget.targetUser.avatar!)
                                    : null,
                                backgroundColor: widget.targetUser.avatar == null
                                    ? widget.targetUser.noAvatarColor
                                    : null,
                                child: widget.targetUser.avatar == null
                                    ? Text('${widget.targetUser.name[0]}${widget.targetUser.surname[0]}',style: AppStyles.userNoAvatarTextText,)
                                    : null,
                              )
                          ),

                          SizedBox(width: 12,),

                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${widget.targetUser.name} ${widget.targetUser.surname}',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppStyles.messageUserText,
                                ),
                                Text('Не в сети',style: AppStyles.messageSubTitleText,),
                              ],
                            ),
                          ),
                        ],
                      ),
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
      body: BlocProvider(
        create: (context) => messagePageCubit,
        child: MessagePageBody(
          messagePageCubit: messagePageCubit,
          currentUser: widget.currentUser,
          targetUser: widget.targetUser,
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (context){

          double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1,color:  AppColors.borderGrey)
                  )
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 14),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: AppColors.fieldGrey
                    ),
                    padding: EdgeInsets.all(8),
                    child: SvgIcon(assetName: 'assets/icons/upload.svg'),
                  ),
                  SizedBox(width: 8,),
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: CommonTextField(hint: 'Сообщение', controller: _messageController),
                    ),
                  ),
                  SizedBox(width: 8,),
                  GestureDetector(
                    onTap: (){
                      if(messageStarted){
                        messagePageCubit.sendMessage(
                        widget.currentUser.uuid,
                        widget.targetUser.uuid,
                        _messageController.text
                        );
                        _messageController.clear();
                      }
                    },
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.fieldGrey
                      ),
                      padding: EdgeInsets.all(8),
                      child: SvgIcon(assetName: messageStarted
                          ?'assets/icons/send.svg'
                          :'assets/icons/voice.svg'
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      )
    );
  }
}


class MessagePageBody extends StatelessWidget {
  const MessagePageBody({super.key, required this.messagePageCubit, required this.currentUser, required this.targetUser});

  final MessagePageCubit messagePageCubit;
  final User currentUser;
  final User targetUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocBuilder(
            bloc: messagePageCubit,
            builder: (context,state){
              switch (state) {
                case MessagePageLoading():
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case MessagePageError():
                  return Center(
                    child: Text(
                      state.errorText,
                      style: AppStyles.titleText,
                    ),
                  );
                case MessagePageFetched():
                  Map<String, List<Message>> groupedMessages = _groupMessagesByDate(state.listOfMessages);
                  return ListView.builder(
                    reverse: true,
                    itemCount: groupedMessages.length,
                    itemBuilder: (context, index) {
                      String date = groupedMessages.keys.elementAt(index);
                      List<Message> messagesForDate = groupedMessages[date]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _buildDateHeader(date),
                          SizedBox(height: 20,),
                          ...messagesForDate.map((message) => _buildMessageBubble(message, currentUser)),
                        ],
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

  Map<String, List<Message>> _groupMessagesByDate(List<Message> messages) {
    Map<String, List<Message>> groupedMessages = {};

    for (var message in messages) {
      String formattedDate = DateFormat('dd.MM.yyyy').format(message.timestamp);

      if (!groupedMessages.containsKey(formattedDate)) {
        groupedMessages[formattedDate] = [];
      }
      groupedMessages[formattedDate]!.add(message);
    }

    return groupedMessages;
  }

  Widget _buildDateHeader(String date) {
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

  Widget _buildMessageBubble(Message message, User currentUser) {
    bool isCurrentUser = message.senderUUID == currentUser.uuid;

    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: CustomPaint(
          painter: MessageBoxPainter(isCurrentUser: isCurrentUser),
          child: Container(
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.only(top: 8,left: isCurrentUser?8:18,right: isCurrentUser? 18:8,bottom: 8),
            child: Text(message.text, style:isCurrentUser
              ?AppStyles.messageDateText.copyWith(color:AppColors.myMessageTextGrey)
              :AppStyles.messageDateText.copyWith(color:AppColors.otherMessageTextGrey),
            )
          ),
        ),
      ),
    );
  }
}


