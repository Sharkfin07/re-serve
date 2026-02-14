import 'package:flutter/material.dart';
import 'package:re_serve/presentation/widgets/global/global_button.dart';
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity),
              Text(
                "Widget Showcase",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              SizedBox(height: 30),
              GlobalButton(
                text: "Register",
                variant: GlobalButtonVariant.primary,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
