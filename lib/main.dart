import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'core/database/isar_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Isar Database secara asinkron sebelum menjalankan UI
  await IsarService.init();

  runApp(
    const ProviderScope(
      child: StackUpApp(),
    ),
  );
}
