import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:models/models.dart';
import 'package:uuid/uuid.dart';

import '../env/env.dart';

class ChatRepository {
  // Store all the messages in a map with the chatroom id as the key
  final Map<String, List<Message>> _chatrooms = {};

  Future<List<Message>> fetchMessages() async {
    throw UnimplementedError();
  }

  Future<Message> createUserMessage(
    String chatRoomId, // Hardcoded
    Map<String, dynamic> data,
  ) async {
    final message = Message.fromJson(data);
    _chatrooms.putIfAbsent(chatRoomId, () => []);
    _chatrooms[chatRoomId]?.add(message);
    return message;
  }

  Stream<(Message, String)> createModelMessage(
    String chatRoomId,
    Map<String, dynamic> data,
  ) {
    final model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: Env.GEMINI_API_KEY,
    );

    final messageId = Uuid().v4();

    List<Content> history = [];

    for (var message in _chatrooms[chatRoomId]!) {
      if (message.id == data['id']) {
        print('message already exists');
        continue;
      }
      if (message.sourceType == MessageSourceType.user) {
        history.add(Content.text(message.content));
      } else {
        history.add(Content.model([TextPart(message.content)]));
      }
    }

    final chat = model.startChat(history: history.isEmpty ? null : history);
    final content = Content.text(data['content']);
    return chat.sendMessageStream(content).asyncMap((response) {
      final newMessage = Message(
        id: messageId,
        content: response.text ?? '',
        sourceType: MessageSourceType.model,
        createdAt: DateTime.now(),
      );
      return _updateMessage(chatRoomId, newMessage.toJson()).then((value) {
        if (value != null) {
          _chatrooms[chatRoomId]?.removeWhere(
            (element) => element.id == messageId,
          );

          _chatrooms[chatRoomId]?.add(value);
          return (value, 'message.updated'); // Message
        } else {
          _chatrooms[chatRoomId]?.add(newMessage);
          return (newMessage, 'message.created');
        }
      });
    });
  }

  Future<Message?> _updateMessage(chatroomId, data) async {
    if (!_chatrooms.containsKey(chatroomId)) {
      return null;
    }

    final messages = _chatrooms[chatroomId];
    final messageIndex = messages?.indexWhere(
      (message) => message.id == data['id'],
    );

    if (messageIndex != null && messageIndex >= 0) {
      final message = messages![messageIndex];
      final updateMessage = message.copyWith(
        content: message.content + data['content'],
      );
      return updateMessage;
    } else {
      return null;
    }
  }
}
