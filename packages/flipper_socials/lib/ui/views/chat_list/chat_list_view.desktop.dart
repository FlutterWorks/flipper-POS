import 'package:flipper_socials/ui/widgets/chat_model.dart';
import 'package:flipper_socials/ui/widgets/chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'chat_list_viewmodel.dart';

class ChatListViewDesktop extends ViewModelWidget<ChatListViewModel> {
  ChatListViewDesktop({super.key});
  final _routerService = locator<RouterService>();
  final List<Chat> chats = [
    Chat(
      from: "me",
      name: 'Alice',
      message: 'Hi, how are you?',
      avatar: 'https://randomuser.me/api/portraits/women/1.jpg',
      source:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/1200px-WhatsApp.svg.png',
    ),
    Chat(
      from: "other",
      name: 'Bob',
      message: 'Hello, nice to meet you.',
      avatar: 'https://randomuser.me/api/portraits/men/2.jpg',
      source:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e7/Instagram_logo_2016.svg/1200px-Instagram_logo_2016.svg.png',
    ),
    Chat(
      from: "me",
      name: 'Charlie',
      message: 'Hey, whats up?',
      avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
      source:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Facebook_icon_2013.svg/1200px-Facebook_icon_2013.svg.png',
    ),
  ];
  @override
  Widget build(BuildContext context, ChatListViewModel viewModel) {
    // Get the size of the screen
    final size = MediaQuery.of(context).size;
    // Use a row widget to split the screen into two parts
    return Scaffold(
      body: Row(
        children: [
          // The left part with the list of messages
          SizedBox(
            width: size.width * 0.3,
            child: ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ListTile(
                  leading: Stack(
                    children: [
                      // A circle avatar that shows the chat image
                      CircleAvatar(
                        backgroundImage: NetworkImage(chat.avatar),
                        radius: 20,
                      ),
                      // A positioned widget that shows the source image at the bottom right corner
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Image.network(
                          chat.source,
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ],
                  ),
                  title: Text(chat.name),
                  subtitle: Text(chat.message),
                  trailing: const Text("11:12"),
                  onTap: () {
                    // Select the chat and update the state
                  },
                );
              },
            ),
          ),
          // The right part with the selected chat details and messages
          SizedBox(
            width: size.width * 0.7,
            child: Column(
              children: [
                // The app bar with profile picture, username, and status
                AppBar(
                  automaticallyImplyLeading: false,
                  title: Padding(
                    padding: const EdgeInsets.only(left: 28.0),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            // A circle avatar that shows the chat image
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://randomuser.me/api/portraits/women/1.jpg'),
                              radius: 20,
                            ),
                            // A positioned widget that shows the source image at the bottom right corner
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Image.network(
                                'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/WhatsApp.svg/1200px-WhatsApp.svg.png',
                                width: 16,
                                height: 16,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  actions: const [],
                ),
                // The list of messages for the selected chat
                Flexible(
                  child: ListView.builder(
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      // Use the ChatWidget to display the message
                      return ChatWidget(chat: chats[index]);
                    },
                  ),
                ),
                // The text field for sending messages
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, right: 10),
                  child: TextFormField(
                      decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Type a message',
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
