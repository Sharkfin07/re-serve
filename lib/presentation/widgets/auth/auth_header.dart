import 'package:flutter/material.dart';
import 'package:re_serve/presentation/theme/app_palette.dart';
import 'package:re_serve/presentation/widgets/global/global_logo.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.imagePath,
    this.title,
    this.subtitle,
    this.showLogo = false,
    this.rounded = false,
  });

  final String imagePath;
  final String? title;
  final String? subtitle;
  final bool showLogo;
  final bool rounded;

  @override
  Widget build(BuildContext context) {
    final borderRadius = rounded
        ? const BorderRadius.vertical(top: Radius.circular(32))
        : BorderRadius.zero;
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: borderRadius,
            child: Image.asset(imagePath, fit: BoxFit.cover),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(120, 0, 0, 0),
                  Color.fromARGB(200, 0, 0, 0),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 64),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showLogo) ...[
                  const SmallLogo(width: 60),
                  const SizedBox(height: 12),
                ],
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(
                      height: 0,
                      color: Colors.white,
                      fontSize: 46,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                if (subtitle != null) ...[
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: AppPalette.primary,
                      fontSize: 46,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
