import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:re_serve/presentation/theme/app_palette.dart';

enum GlobalButtonVariant { primary, secondary, tertiary, outline }

class GlobalButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final String text;
  final GlobalButtonVariant variant;
  const GlobalButton({
    super.key,
    this.onPressed,
    required this.text,
    this.width,
    this.height,
    this.variant = GlobalButtonVariant.primary,
  });

  @override
  Widget build(BuildContext context) {
    final _ButtonColors colors = _resolveColors(variant);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.background,
          foregroundColor: colors.foreground,
          overlayColor: colors.overlay,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: colors.border,
          ),
          elevation: variant == GlobalButtonVariant.outline ? 0 : 2,
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: "Outfit",
          ),
        ),
        child: Text(text),
      ),
    );
  }

  _ButtonColors _resolveColors(GlobalButtonVariant variant) {
    switch (variant) {
      case GlobalButtonVariant.primary:
        return _ButtonColors(
          background: AppPalette.primary,
          foreground: Colors.white,
          // overlay: AppPalette.secondary.withValues(alpha: 0.12),
        );
      case GlobalButtonVariant.secondary:
        return _ButtonColors(
          background: AppPalette.secondary,
          foreground: Colors.white,
          overlay: AppPalette.primary.withValues(alpha: 0.12),
        );
      case GlobalButtonVariant.tertiary:
        return _ButtonColors(
          background: AppPalette.tertiaryLight,
          foreground: AppPalette.primary,
          overlay: AppPalette.primary.withValues(alpha: 0.08),
          border: BorderSide(color: AppPalette.primary.withValues(alpha: 0.3)),
        );
      case GlobalButtonVariant.outline:
        return _ButtonColors(
          background: Colors.white,
          foreground: AppPalette.primary,
          overlay: AppPalette.primary.withValues(alpha: 0.05),
          border: BorderSide(color: AppPalette.primary, width: 1.4),
        );
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color? overlay;
  final BorderSide border;

  _ButtonColors({
    required this.background,
    required this.foreground,
    this.overlay,
    BorderSide? border,
  }) : border = border ?? BorderSide(color: Colors.transparent);
}
