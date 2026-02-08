import 'package:flutter/material.dart';

class RateShovelerScreen extends StatelessWidget {
  final String jobId;
  const RateShovelerScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rate Shoveler')),
      body: Center(child: Text('Rate Shoveler Screen - Job: $jobId')),
    );
  }
}

