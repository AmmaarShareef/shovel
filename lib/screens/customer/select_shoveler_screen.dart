import 'package:flutter/material.dart';

class SelectShovelerScreen extends StatelessWidget {
  final String jobId;
  const SelectShovelerScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Shoveler')),
      body: Center(child: Text('Select Shoveler Screen - Job: $jobId')),
    );
  }
}

