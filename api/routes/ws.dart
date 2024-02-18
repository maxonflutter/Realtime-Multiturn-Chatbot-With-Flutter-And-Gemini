import 'dart:convert';

import 'package:api/src/repositories/chat_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';

Future<Response> onRequest(RequestContext context) async {
  final chatRepository = context.read<ChatRepository>();
  final handler = webSocketHandler((channel, protocol) {
    channel.stream.listen((message) {
      if (message is! String) {
        channel.sink.add('Invalid message');
        return;
      }

      try {
        Map<String, dynamic> messageJson = json.decode(message);
        final event = messageJson['event'];
        final data = messageJson['data'];

        // message.create
        switch (event) {
          case 'message.create':
            final chatroomId = '1';
            chatRepository.createUserMessage(chatroomId, data).then((value) {
              print(value);
              return;
            });

            break;
          // example
          // case 'chat.create':
          //   break;
          default:
        }
      } catch (err) {}
    });
  });

  return Response(body: 'Welcome to Dart Frog!');
}
