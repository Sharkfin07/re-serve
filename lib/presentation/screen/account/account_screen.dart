import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:re_serve/presentation/bloc/auth/auth_bloc.dart';
import 'package:re_serve/presentation/bloc/auth/auth_event.dart';
import 'package:re_serve/presentation/bloc/auth/auth_state.dart';
import 'package:re_serve/presentation/bloc/food/food_bloc.dart';
import 'package:re_serve/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:re_serve/presentation/screen/account/edit_profile_screen.dart';
import 'package:re_serve/presentation/screen/account/liked_foods_screen.dart';
import 'package:re_serve/presentation/screen/account/transaction_history_screen.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Account',
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
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final user = state.user;

          if (state.status == AuthStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (user == null) {
            return const Center(child: Text('User not found'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Header
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.onSurface.withValues(
                    alpha: 0.1,
                  ),
                  backgroundImage:
                      user.profilePictureUrl != null &&
                          user.profilePictureUrl!.isNotEmpty
                      ? CachedNetworkImageProvider(user.profilePictureUrl!)
                      : null,
                  child:
                      user.profilePictureUrl == null ||
                          user.profilePictureUrl!.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 50,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 16),
                Text(
                  user.name,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 14,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                if (user.phoneNumber != null &&
                    user.phoneNumber!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    user.phoneNumber!,
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
                const SizedBox(height: 32),

                // Menu Items
                _AccountMenuItem(
                  icon: Icons.edit_outlined,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    final authBloc = context.read<AuthBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: authBloc,
                          child: const EditProfileScreen(),
                        ),
                      ),
                    );
                  },
                ),
                _AccountMenuItem(
                  icon: Icons.favorite_outline,
                  title: 'Liked Foods',
                  subtitle: 'View your favorite dishes',
                  onTap: () {
                    final foodBloc = context.read<FoodBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: foodBloc,
                          child: const LikedFoodsScreen(),
                        ),
                      ),
                    );
                  },
                ),
                _AccountMenuItem(
                  icon: Icons.receipt_long_outlined,
                  title: 'Transaction History',
                  subtitle: 'View your past orders',
                  onTap: () {
                    final transactionBloc = context.read<TransactionBloc>();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: transactionBloc,
                          child: const TransactionHistoryScreen(),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Logout'),
                          content: const Text(
                            'Are you sure you want to logout?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext);
                                context.read<AuthBloc>().add(
                                  const AuthLogoutRequested(),
                                );
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AccountMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AccountMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE74C3C).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFE74C3C), size: 22),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
