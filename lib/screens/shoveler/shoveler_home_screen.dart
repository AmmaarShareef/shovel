import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class ShovelerHomeScreen extends StatelessWidget {
  const ShovelerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome, ${authProvider.user?.name ?? "Shoveler"}!'),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go('/shoveler/available-jobs'),
                  child: const Text('View Available Jobs'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

