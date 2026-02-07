import 'package:flutter/material.dart';

class AvailableJobsScreen extends StatelessWidget {
  const AvailableJobsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Available Jobs')),
      body: const Center(child: Text('Available Jobs Screen')),
    );
  }
}

