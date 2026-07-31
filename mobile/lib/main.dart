import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/storage/secure_storage.dart';
import 'core/network/api_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize secure storage
  await SecureStorage.init();

  // Initialize API client (auth interceptors, token refresh)
  await ApiClient.init();

  runApp(const PlayerPathApp());
}
