import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:messanger_test/presentation/message_page_cubit/message_page_cubit.dart';
import 'package:messanger_test/widgets/common_text_field.dart';
import 'package:messanger_test/widgets/file_image_panel.dart';
import 'package:messanger_test/widgets/svg_icon.dart';


import '../config/app_colors.dart';
import '../config/app_styles.dart';
import '../domain/message.dart';
import '../domain/user.dart';
import '../widgets/message_box.dart';
import '../widgets/message_header.dart';

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
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,color:AppColors.borderGrey
                )
              )
            ),
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
              ],
            ),
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
              height: messagePageCubit.fileImagePanelOpened
                  || messagePageCubit.selectedImage != null
                  || messagePageCubit.selectedFile != null? 150 : 80,
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

                      Divider(
                          color: AppColors.fieldGrey
                      )
                  ],

                  if(messagePageCubit.selectedFile != null)
                    ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: GestureDetector(
                          onTap: (){
                            messagePageCubit.removeFile(
                                widget.currentUser.uuid,
                                widget.targetUser.uuid
                            );
                          },
                          child: SizedBox(
                              width: 150,
                              height: 60,
                              child: Stack(
                                children: [
                                  SizedBox(
                                      width: 150,
                                      height: 60,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.otherMessageGrey,
                                          borderRadius: BorderRadius.circular(23)
                                        ),
                                        padding: EdgeInsets.all(8),
                                        child: Center(
                                          child: Text(
                                            messagePageCubit.selectedFile?.fileName ?? '',
                                            style:AppStyles.messageSubTitleText,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
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

                      Divider(
                          color: AppColors.fieldGrey
                      )
                    ],


                  if(messagePageCubit.fileImagePanelOpened)
                   fileImagePanel(
                       context,
                       messagePageCubit,
                       widget.currentUser.uuid,
                       widget.targetUser.uuid
                   ),



                  Row(
                    children: [
                      GestureDetector(
                        onTap: (){
                          if(messagePageCubit.fileImagePanelOpened){
                            messagePageCubit.closePanel(
                              widget.currentUser.uuid,
                              widget.targetUser.uuid
                            );
                          }else{
                            messagePageCubit.openPanel(
                                widget.currentUser.uuid,
                                widget.targetUser.uuid
                            );
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
                          child: messagePageCubit.fileImagePanelOpened
                              ? Icon(Icons.keyboard_arrow_down)
                              : SvgIcon(assetName: 'assets/icons/upload.svg'),
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
                          if(_messageController.text.isNotEmpty
                              || messagePageCubit.selectedImage != null
                              || messagePageCubit.selectedFile != null){
                            messagePageCubit.sendMessage(
                            widget.currentUser.uuid,
                            widget.targetUser.uuid,
                            _messageController.text
                            );
                            messagePageCubit.removeSelectedImage(
                              widget.currentUser.uuid,
                              widget.targetUser.uuid,
                            );
                            messagePageCubit.removeFile(
                              widget.currentUser.uuid,
                              widget.targetUser.uuid,
                            );
                            _messageController.clear();

                            _historyScrollController.jumpTo(0.0);
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
                  groupedMessages =  Map.fromEntries(groupedMessages.entries.toList().reversed);
                  return ListView.builder(
                    controller: scrollController,
                    reverse: true,
                    itemCount: groupedMessages.length,
                    itemBuilder: (context, index) {
                      String date = groupedMessages.keys.elementAt(index);
                      List<Message> messagesForDate = groupedMessages[date]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          dateHeader(date),
                          SizedBox(height: 20,),
                          ...messagesForDate.map((message) => messageBox(message, currentUser,messagePageCubit)),
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

}


