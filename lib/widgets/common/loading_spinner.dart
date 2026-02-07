import 'package:flutter/material.dart';

class LoadingSpinner extends StatelessWidget {
  final String? message;
  final bool fullScreen;

  const LoadingSpinner({
    super.key,
    this.message,
    this.fullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        if (message != null) ...[
          const SizedBox(height: 16),
          Text(
            message!,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ],
    );

    if (fullScreen) {
      return Scaffold(
        body: Center(child: content),
      );
    }

    return content;
  }
}

