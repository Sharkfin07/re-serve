import 'package:flutter/material.dart';
import 'package:re_serve/presentation/widgets/global/global_button.dart';
import 'package:re_serve/presentation/widgets/global/global_input.dart';
import 'presentation/theme/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Widget Showcase",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                ),
                SizedBox(height: 30),
                GlobalButton(
                  text: "Primary Button",
                  variant: GlobalButtonVariant.primary,
                  onPressed: () {},
                ),
                SizedBox(height: 20),
                GlobalButton(
                  text: "Secondary Button",
                  variant: GlobalButtonVariant.secondary,
                  onPressed: () {},
                ),
                SizedBox(height: 20),
                GlobalButton(
                  text: "Button with Icon",
                  variant: GlobalButtonVariant.outline,
                  onPressed: () {},
                  icon: Icon(Icons.account_balance_wallet),
                ),
                SizedBox(height: 30),
                GlobalInput(
                  hintText: "Email",
                  prefixIcon: const Icon(Icons.mail),
                  keyboardType: TextInputType.emailAddress,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
