import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';

import '../colors.dart';
import '../main.dart';
import '../widgets/message_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController controller = TextEditingController();
  List<Message> messages = [];

  @override
  void initState() {
    _startWebSocket();

    chatRepository.subscribeToMessageUpdates((message) {
      // Update an existing message
      if (message['event'] == 'message.updated') {
        final updatedMessage = Message.fromJson(message['data']);
        setState(() {
          messages = messages.map((message) {
            if (message.id == updatedMessage.id) {
              return updatedMessage;
            }
            return message;
          }).toList();
        });
        return;
      }

      // New message
      final newMessage = Message.fromJson(message['data']);
      setState(() {
        messages.add(newMessage);
      });
    });
    super.initState();
  }

  _startWebSocket() {
    webSocketClient.connect(
      'ws://localhost:8080/ws',
      {
        'Authorization': 'Bearer ...',
      },
    );
  }

  Future<void> _createMessage(Message message) async {
    await chatRepository.createMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: RichText(
          text: TextSpan(
            text: 'Build with ',
            style: textTheme.titleLarge,
            children: [
              TextSpan(
                text: 'Gemini',
                style: textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              )
            ],
          ),
        )
            .animate(
              onComplete: (controller) => controller.repeat(),
            )
            .shimmer(
              duration: const Duration(milliseconds: 2000),
              delay: const Duration(milliseconds: 1000),
            ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          return MessageCard(message: message);
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                final message = Message(
                  id: const Uuid().v4(),
                  content: controller.text,
                  sourceType: MessageSourceType.user,
                  createdAt: DateTime.now(),
                );

                setState(() {
                  messages.add(message);
                });

                _createMessage(message);
                controller.clear();
              },
              icon: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
