import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:realtime_multiturn_chatbot_with_flutter_and_gemini/colors.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message});

  final Message message;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.sizeOf(context);

    final color =
        message.sourceType == MessageSourceType.user ? primary : secondary;

    final alignment = message.sourceType == MessageSourceType.user
        ? MainAxisAlignment.end
        : MainAxisAlignment.start;

    final avatar = CircleAvatar(
      backgroundColor: color,
      child: Text(
        message.sourceType == MessageSourceType.user ? 'U' : 'M',
        style: textTheme.bodyLarge,
      ),
    );
    return Row(
      mainAxisAlignment: alignment,
      children: [
        if (message.sourceType == MessageSourceType.model) avatar,
        Container(
          padding: const EdgeInsets.all(8.0),
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8.0),
          ),
          constraints: BoxConstraints(maxWidth: size.width * 0.6),
          child: Text(
            message.content,
          ),
        ),
        if (message.sourceType == MessageSourceType.user) avatar,
      ],
    );
  }
}
