import 'package:flutter/material.dart';

class CompleteJobScreen extends StatelessWidget {
  final String jobId;
  const CompleteJobScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complete Job')),
      body: Center(child: Text('Complete Job Screen - Job: $jobId')),
    );
  }
}

