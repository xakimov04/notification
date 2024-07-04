import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notification/controller/motivation_controller.dart';
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
  scheduleMotivationNotification();
  scheduleDailyMotivationNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TaskController(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TaskListScreen(),
      ),
    );
  }
}

Future<void> scheduleMotivationNotification() async {
  while (true) {
    await LocalNotificationsService.showNotificationTest(
        "Siz ko'p ishlamoqdasiz!",
        "Dam olish vaqti keldi juda ko'p ishlash sizni jinni qilishi mumkin.");

    await Future.delayed(const Duration(minutes: 1));
  }
}

Future<void> scheduleDailyMotivationNotification() async {
  final motivationController = MotivationController();

  final motivations = await motivationController.getMotiv("happiness");
  if (motivations.isNotEmpty) {
    final motivation = motivations[0];
    while (true) {
      await LocalNotificationsService.scheduleDailyMotivationNotification(
          motivation.author, motivation.quote);
      await Future.delayed(const Duration(minutes: 2));
    }
  }
}
