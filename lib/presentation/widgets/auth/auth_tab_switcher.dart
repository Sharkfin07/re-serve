import 'package:flutter/material.dart';
import 'package:re_serve/core/utils/is_dark.dart';
import 'package:re_serve/presentation/theme/app_palette.dart';

class AuthTabSwitcher extends StatelessWidget {
  const AuthTabSwitcher({
    super.key,
    required this.activeIndex,
    required this.onChanged,
  });

  final int activeIndex; // 0 login, 1 register
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isDark(context) ? Colors.white70 : Colors.black12,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildTab(context, label: 'Login', index: 0),
          _buildTab(context, label: 'Register', index: 1),
        ],
      ),
    );
  }

  Expanded _buildTab(
    BuildContext context, {
    required String label,
    required int index,
  }) {
    final bool isActive = activeIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppPalette.primary.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: isActive ? AppPalette.primary : Colors.grey.shade600,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
