
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
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _historyScrollController = ScrollController();

  @override
  void initState() {
    messagePageCubit.loadMessages(
        widget.currentUser.uuid,
        widget.targetUser.uuid
    );
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
          scrollController: _historyScrollController,
        ),
      ),
      bottomNavigationBar: BlocBuilder(
        bloc: messagePageCubit,
        builder: (context,state){
          double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          return Padding(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: Container(
              height: messagePageCubit.selectedImage != null ? 150 : 100,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(width: 1,color:  AppColors.borderGrey)
                  )
              ),
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  if(messagePageCubit.selectedImage != null)
                    ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: (){
                            messagePageCubit.removeSelectedImage(
                              widget.currentUser.uuid,
                              widget.targetUser.uuid
                            );
                          },
                          child: SizedBox(
                            width: 60,
                            height: 60,
                            child: Stack(
                              children: [
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: Image.memory(messagePageCubit.selectedImage!,fit: BoxFit.cover)
                                ),

                                Center(
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.borderGrey..withValues(alpha: 0.5),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ),
                        ),
                      ),

                      SizedBox(height: 6,)
                  ],




                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          messagePageCubit.setSelectedImage(
                              widget.currentUser.uuid,
                              widget.targetUser.uuid
                          );
                        },
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.fieldGrey
                          ),
                          padding: EdgeInsets.all(8),
                          child: SvgIcon(assetName: 'assets/icons/upload.svg'),
                        ),
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
                          if(_messageController.text.isNotEmpty || messagePageCubit.selectedImage != null){
                            messagePageCubit.sendMessage(
                            widget.currentUser.uuid,
                            widget.targetUser.uuid,
                            _messageController.text
                            );
                            messagePageCubit.removeSelectedImage(
                              widget.currentUser.uuid,
                              widget.targetUser.uuid,
                            );
                            _messageController.clear();

                            _historyScrollController.jumpTo(_historyScrollController.position.maxScrollExtent);
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
                          child: SvgIcon(assetName: 'assets/icons/send.svg'),
                        ),
                      ),
                    ],
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
  const MessagePageBody({super.key, required this.messagePageCubit, required this.currentUser, required this.targetUser, required this.scrollController});

  final MessagePageCubit messagePageCubit;
  final ScrollController scrollController;
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
                  return Align(
                    alignment: Alignment.bottomCenter,
                    child: ListView.builder(
                      controller: scrollController,
                      shrinkWrap: true,
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
                    ),
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


                Row(
                  mainAxisSize: message.image == null
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
}


