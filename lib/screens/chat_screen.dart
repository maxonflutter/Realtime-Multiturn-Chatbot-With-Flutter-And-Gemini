import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../colors.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
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
      body: Container(),
    );
  }
}
