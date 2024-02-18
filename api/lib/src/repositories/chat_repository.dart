import 'package:models/models.dart';

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

  Stream<Message> createModelMessage(
    String chatRoomId,
    Map<String, dynamic> data,
  ) {
    throw UnimplementedError();
  }
}
