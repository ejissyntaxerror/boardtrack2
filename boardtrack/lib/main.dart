import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_app/services/database_service.dart';
import 'package:my_app/providers/boarder_provider.dart';
import 'package:my_app/screens/dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService.initializeHive();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BoarderProvider()),
      ],
      child: MaterialApp(
        title: 'BoardTrack',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
