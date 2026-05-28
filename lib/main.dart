import 'package:flutter/material.dart';
import 'package:medtrack/core/data/medicine_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'package:medtrack/core/config/supabase_config.dart';
import 'package:medtrack/core/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── System UI ─────────────────────────────────────────────────────────────
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  // ── Hive (local cache) ───────────────────────────────────────────────────
  await Hive.initFlutter();

  // ── Supabase ─────────────────────────────────────────────────────────────
  await Supabase.initialize(
    url: SupabaseConfig.url,
    anonKey: SupabaseConfig.anonKey,
  );

  // ── Notifications ─────────────────────────────────────────────────────────
  await NotificationService().init();
  await NotificationService().requestPermissions();

  // ── Medicine Database ─────────────────────────────────────────────────────
  await MedicineDatabase.init();

  runApp(
    const ProviderScope(
      child: MedTrackApp(),
    ),
  );
}
