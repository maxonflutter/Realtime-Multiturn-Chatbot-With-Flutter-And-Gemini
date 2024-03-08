import 'dart:async';
import 'dart:convert';

import 'package:models/models.dart';

import '../services/web_socket_client.dart';

class ChatRepository {
  // final ApiClient apiClient;
  final WebSocketClient webSocketClient;
  StreamSubscription? _messagesSubscription;

  ChatRepository({
    required this.webSocketClient,
  });

  Future<void> createMessage(Message message) async {
    final payload = {
      'event': 'message.create',
      'data': message.toJson(),
    };
    print('Sending message: $payload');
    webSocketClient.send(jsonEncode(payload));
  }

  void subscribeToMessageUpdates(
    void Function(Map<String, dynamic> message) onMessageReceived,
  ) {
    _messagesSubscription = webSocketClient.messageUpdates().listen(
      (message) {
        onMessageReceived(message);
      },
    );
  }

  void unsubscribeFromMessageUpdates() {
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
  }
}
