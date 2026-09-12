import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/navigation/main_scaffold.dart';
import 'l10n/app_localizations.dart';
import 'providers/locale_provider.dart';

class StackUpApp extends ConsumerWidget {
  const StackUpApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'StackUp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      locale: ref.watch(localeProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const MainScaffold(),
    );
  }
}
