import 'package:flutter/material.dart';
import 'package:re_serve/presentation/theme/app_palette.dart';

class GlobalInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;

  const GlobalInput({
    super.key,
    this.controller,
    this.hintText,
    this.prefixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.focusNode,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(28);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style:
          Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: scheme.onSurface) ??
          TextStyle(color: scheme.onSurface),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: scheme.onSurface.withValues(alpha: 0.6),
        ),
        filled: true,
        fillColor: scheme.surface,
        prefixIcon: prefixIcon == null
            ? null
            : IconTheme(
                data: IconThemeData(color: AppPalette.primary, size: 22),
                child: prefixIcon!,
              ),
        prefixIconConstraints: const BoxConstraints(minWidth: 56),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.outline.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: borderRadius,
          borderSide: BorderSide(color: scheme.error, width: 1.6),
        ),
      ),
    );
  }
}
