import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SmallLogo extends StatelessWidget {
  static const emblemPath = "assets/images/general/logo-emblem.svg";
  final double width;
  final double? height;
  final Color? color;
  const SmallLogo({super.key, this.width = 48, this.height, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      emblemPath,
      colorFilter: ColorFilter.mode(
        color ??
            (Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black),
        BlendMode.srcIn,
      ),
      width: width,
      height: height ?? width,
    );
  }
}

class LargeLogo extends StatelessWidget {
  static const emblemPath = "assets/images/general/logo-typography.svg";
  final double width;
  final Color? color;
  const LargeLogo({super.key, this.width = 324, this.color});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      emblemPath,
      colorFilter: ColorFilter.mode(
        color ??
            (Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black),
        BlendMode.srcIn,
      ),
      width: width,
    );
  }
}
