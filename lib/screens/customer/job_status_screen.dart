import 'package:flutter/material.dart';

class JobStatusScreen extends StatelessWidget {
  final String jobId;
  const JobStatusScreen({super.key, required this.jobId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Job Status')),
      body: Center(child: Text('Job Status Screen - Job: $jobId')),
    );
  }
}

