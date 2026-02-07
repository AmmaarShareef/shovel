import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/job_provider.dart';

class CustomerHomeScreen extends StatelessWidget {
  const CustomerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer2<AuthProvider, JobProvider>(
        builder: (context, authProvider, jobProvider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, ${authProvider.user?.name ?? "Customer"}!'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/customer/create-job'),
                  child: const Text('Create New Job'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

