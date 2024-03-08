import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  IOWebSocketChannel? channel;
  late StreamController<Map<String, dynamic>> messagesController;

  WebSocketClient() {
    initializeController();
  }

  initializeController() {
    messagesController = StreamController<Map<String, dynamic>>.broadcast();
  }

  void connect(String url, Map<String, String> headers) {
    if (channel != null && channel!.closeCode == null) {
      debugPrint('Already connected');
      return;
    }

    channel = IOWebSocketChannel.connect(url, headers: headers);
    channel!.stream.listen(
      (event) {
        Map<String, dynamic> message = jsonDecode(event);

        if (message['event'] == 'message.created') {
          messagesController.add(message);
        }
        if (message['event'] == 'message.updated') {
          messagesController.add(message);
        }
      },
      onDone: () {
        debugPrint('Disconnected');
      },
      onError: (error) {
        debugPrint('Error: $error');
      },
    );
  }

  void send(String data) {
    if (channel == null && channel!.closeCode != null) {
      debugPrint('Not connected');
      return;
    }
    // Send the data to the /ws endpoint
    channel!.sink.add(data);
  }

  Stream<Map<String, dynamic>> messageUpdates() {
    return messagesController.stream;
  }

  void disconnect() {
    if (channel == null && channel!.closeCode != null) {
      debugPrint('Not connected');
      return;
    }
    channel!.sink.close();
    messagesController.close();
    initializeController();
  }
}
