import 'package:api/src/repositories/chat_repository.dart';
import 'package:dart_frog/dart_frog.dart';

final _chatRepository = ChatRepository();

Middleware chatRepositoryProvider() {
  return provider<ChatRepository>((_) => _chatRepository);
}
