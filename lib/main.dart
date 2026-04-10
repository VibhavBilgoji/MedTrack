import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'app.dart';
import 'package:medtrack/firebase_options.dart';

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
  // await Hive.openBox('medicines_cache');
  // await Hive.openBox('settings');

  // ── Firebase ──────────────────────────────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MedTrackApp(),
    ),
  );
}
