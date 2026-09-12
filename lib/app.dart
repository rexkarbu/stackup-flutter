import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_scaffold.dart';

class StackUpApp extends StatelessWidget {
  const StackUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StackUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainScaffold(),
    );
  }
}
