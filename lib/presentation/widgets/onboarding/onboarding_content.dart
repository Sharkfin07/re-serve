import 'package:flutter/material.dart';
import 'package:re_serve/presentation/widgets/onboarding/onboarding_page.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({super.key, required this.page});

  final OnboardingPageData page;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(page.image, fit: BoxFit.cover),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(180, 0, 0, 0),
                Color.fromARGB(120, 0, 0, 0),
                Color.fromARGB(200, 0, 0, 0),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 48, 140),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              page.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
