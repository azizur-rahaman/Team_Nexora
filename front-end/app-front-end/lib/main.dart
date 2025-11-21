import 'package:flutter/material.dart';
import 'package:khaddo/app.dart';
import 'core/config/env_config.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await EnvConfig.load();
  
  // Initialize dependency injection
  await di.init();
  
  runApp(const MyApp());
}