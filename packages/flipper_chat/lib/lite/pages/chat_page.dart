import 'package:flipper_chat/lite/widgets/chat_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flipper_models/view_models/message_view_model.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart' as ChatUi;
import 'package:stacked/stacked.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flipper_models/message.dart';
import 'package:flipper_routing/routes.logger.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  ChatPage({Key? key, this.message}) : super(key: key);
  Message? message;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final log = getLogger('_ChatPageState');

  void _handleMessageTap(types.Message message) async {
    if (message is types.FileMessage) {
      // await OpenFile.open(message.uri);
    }
  }

  void _handlePreviewDataFetched(types.TextMessage message,
      types.PreviewData previewData, MessageViewModel viewModel) {
    final index = viewModel.conversations
        .indexWhere((element) => element.id == message.id);
    // final updatedMessage =
    //     viewModel.conversations[index].copyWith(previewData: previewData);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        // viewModel.conversations[index] = updatedMessage;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MessageViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          appBar: ChatAppBar(
            'Flipper',
          ),
          body: ChatUi.Chat(
            disableImageGallery: true,
            isAttachmentUploading: false,
            messages: model.conversations,
            showUserAvatars: false,
            showUserNames: true,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: (message, type) {
              _handlePreviewDataFetched(message, type, model);
            },
            onSendPressed: (message) {
              model.sendMessage(
                message: message.text,
                receiverId: widget.message!.receiverId.toString(),
              );
            },
            user: types.User(id: widget.message!.receiverId.toString()),
          ),
        );
      },
      onModelReady: (model) {
        model.loadSenderBusiness(senderId: widget.message!.senderId);
        model.getConversations(senderId: widget.message!.senderId);
      },
      viewModelBuilder: () => MessageViewModel(),
    );
  }
}
