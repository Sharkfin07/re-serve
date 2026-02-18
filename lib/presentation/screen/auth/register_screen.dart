import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/presentation/bloc/auth/auth_bloc.dart';
import 'package:re_serve/presentation/bloc/auth/auth_event.dart';
import 'package:re_serve/presentation/bloc/auth/auth_state.dart';
import 'package:re_serve/presentation/widgets/auth/auth_header.dart';
import 'package:re_serve/presentation/widgets/auth/auth_tab_switcher.dart';
import 'package:re_serve/presentation/widgets/global/global_button.dart';
import 'package:re_serve/presentation/widgets/global/global_input.dart';

class RegisterScreen extends StatefulWidget {
  static const backgroundImagePath = 'assets/images/auth/register-bg.png';
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordRepeat: _passwordController.text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.failure &&
                state.errorMessage != null) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            }
            if (state.status == AuthStatus.authenticated) {
              Navigator.pushReplacementNamed(context, '/home');
            }
          },
          builder: (context, state) {
            final isLoading = state.status == AuthStatus.loading;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AuthHeader(
                    imagePath: RegisterScreen.backgroundImagePath,
                    showLogo: true,
                    title: 'rescue starts here.',
                    rounded: false,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthTabSwitcher(
                              activeIndex: 1,
                              onChanged: (i) {
                                if (i == 0) {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/login',
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 18),
                            GlobalInput(
                              controller: _nameController,
                              hintText: 'Username',
                              prefixIcon: const Icon(Icons.person_outline),
                            ),
                            const SizedBox(height: 12),
                            GlobalInput(
                              controller: _emailController,
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(Icons.email_outlined),
                            ),
                            const SizedBox(height: 12),
                            GlobalInput(
                              controller: _passwordController,
                              hintText: 'Password',
                              obscureText: true,
                              prefixIcon: const Icon(Icons.lock_outline),
                            ),
                            const SizedBox(height: 48),
                            GlobalButton(
                              text: isLoading ? 'Registering...' : 'Register',
                              onPressed: isLoading
                                  ? null
                                  : () => _submit(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
