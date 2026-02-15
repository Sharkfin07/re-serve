import 'package:flutter/material.dart';
import 'package:re_serve/presentation/widgets/global/global_button.dart';
import 'package:re_serve/presentation/widgets/onboarding/onboarding_content.dart';
import 'package:re_serve/presentation/widgets/onboarding/onboarding_dots_indicator.dart';
import 'package:re_serve/presentation/widgets/onboarding/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> pages = const [
    OnboardingPageData(
      image: 'assets/images/onboarding/onboarding-1.png',
      title:
          'Every day, surplus food that\'s still safe and delicious is thrown away.',
    ),
    OnboardingPageData(
      image: 'assets/images/onboarding/onboarding-2.png',
      title:
          'We connect surplus meals with people who can enjoy them at a better price.',
    ),
    OnboardingPageData(
      image: 'assets/images/onboarding/onboarding-3.png',
      title: 'Discover surplus meals and help reduce food waste.',
    ),
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == pages.length - 1;
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) =>
                OnboardingContent(page: pages[index]),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 64,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: GlobalButton(
                    text: isLastPage ? 'Get Started' : 'Next',
                    variant: GlobalButtonVariant.secondary,
                    onPressed: () {
                      if (isLastPage) {
                        // TODO: navigate to login/home
                        return;
                      }
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 64),
                OnboardingDotsIndicator(
                  count: pages.length,
                  activeIndex: _currentPage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
