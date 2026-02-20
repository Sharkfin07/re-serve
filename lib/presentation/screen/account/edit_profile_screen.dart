import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/presentation/bloc/auth/auth_bloc.dart';
import 'package:re_serve/presentation/bloc/auth/auth_event.dart';
import 'package:re_serve/presentation/bloc/auth/auth_state.dart';
import 'package:re_serve/presentation/widgets/global/global_input.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _profilePicController;

  bool _initialized = false;
  bool _submitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _profilePicController.dispose();
    super.dispose();
  }

  void _initControllers(AuthState state) {
    if (_initialized) return;
    final user = state.user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _profilePicController =
        TextEditingController(text: user?.profilePictureUrl ?? '');
    _initialized = true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStatus.authenticated && _submitting) {
            _submitting = false;
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            Navigator.pop(context);
          } else if (state.status == AuthStatus.failure && _submitting) {
            _submitting = false;
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Update failed'),
                  backgroundColor: Colors.red,
                ),
              );
          }
        },
        builder: (context, state) {
          _initControllers(state);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlobalInput(
                    controller: _nameController,
                    label: 'Name',
                    hintText: 'Enter your name',
                    prefixIcon: const Icon(Icons.person_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GlobalInput(
                    controller: _emailController,
                    label: 'Email',
                    hintText: 'Enter your email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GlobalInput(
                    controller: _phoneController,
                    label: 'Phone Number',
                    hintText: 'Enter your phone number',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  GlobalInput(
                    controller: _profilePicController,
                    label: 'Profile Picture URL',
                    hintText: 'Enter image URL',
                    prefixIcon: const Icon(Icons.image_outlined),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: state.status == AuthStatus.loading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                _submitting = true;
                                context.read<AuthBloc>().add(
                                  AuthUpdateProfileRequested(
                                    name: _nameController.text.trim(),
                                    email: _emailController.text.trim(),
                                    phoneNumber:
                                        _phoneController.text.trim().isEmpty
                                            ? null
                                            : _phoneController.text.trim(),
                                    profilePictureUrl: _profilePicController
                                            .text
                                            .trim()
                                            .isEmpty
                                        ? null
                                        : _profilePicController.text.trim(),
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE74C3C),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: state.status == AuthStatus.loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
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
