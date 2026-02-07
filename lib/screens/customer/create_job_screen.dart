import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateJobScreen extends StatelessWidget {
  const CreateJobScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Job')),
      body: const Center(child: Text('Create Job Screen')),
    );
  }
}

