import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user.dart';
import '../../widgets/common/custom_input.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/error_message.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  UserRole _role = UserRole.customer;
  bool _acceptTerms = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final roleParam = GoRouterState.of(context).uri.queryParameters['role'];
    if (roleParam != null) {
      _role = roleParam == 'shoveler' ? UserRole.shoveler : UserRole.customer;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (authProvider.error != null) ...[
                    ErrorMessage(
                      message: authProvider.error!,
                      onClose: () => authProvider.clearError(),
                    ),
                    const SizedBox(height: 16),
                  ],
                  CustomInput(
                    controller: _nameController,
                    label: 'Full Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    controller: _emailController,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    controller: _phoneController,
                    label: 'Phone',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Phone is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    controller: _passwordController,
                    label: 'Password',
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomInput(
                    controller: _confirmPasswordController,
                    label: 'Confirm Password',
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    title: const Text('I accept the terms and conditions'),
                    value: _acceptTerms,
                    onChanged: (value) => setState(() => _acceptTerms = value ?? false),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Sign Up',
                    onPressed: _acceptTerms
                        ? () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                await authProvider.register(
                                  RegisterData(
                                    name: _nameController.text,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    phone: _phoneController.text,
                                    role: _role,
                                  ),
                                );
                                if (context.mounted) {
                                  if (_role == UserRole.customer) {
                                    context.go('/customer/home');
                                  } else {
                                    context.go('/shoveler/home');
                                  }
                                }
                              } catch (e) {
                                // Error handled by provider
                              }
                            }
                          }
                        : null,
                    isDisabled: !_acceptTerms,
                    isLoading: authProvider.isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

