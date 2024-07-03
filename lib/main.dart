import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notification/controller/task_controller.dart';
import 'package:notification/firebase_options.dart';
import 'package:notification/service/notification_service.dart';
import 'package:notification/views/screens/home_screen.dart';
import 'package:notification/views/screens/task_list.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalNotificationsService.start();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      if (!LocalNotificationsService.notificationsEnabled) {
        await LocalNotificationsService.requestPermission();
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskController(),
        )
      ],
      builder: (context, snapshot) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: TaskListScreen(),
        );
      },
    );
  }
}
