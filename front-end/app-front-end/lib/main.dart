import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:khaddo/app.dart';
import 'core/config/env_config.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await EnvConfig.load();
  
  // Initialize SharedPreferences before dependency injection
  final sharedPreferences = await SharedPreferences.getInstance();
  
  // Initialize dependency injection
  await di.init(sharedPreferences);
  
  runApp(const MyApp());
}