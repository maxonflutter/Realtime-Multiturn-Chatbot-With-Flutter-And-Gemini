import 'package:flutter/material.dart';

import 'repositories/chat_repository.dart';
import 'screens/chat_screen.dart';
import 'services/web_socket_client.dart';

void main() {
  runApp(const MyApp());
}

final webSocketClient = WebSocketClient();
final chatRepository = ChatRepository(webSocketClient: webSocketClient);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const ChatScreen(),
    );
  }
}
