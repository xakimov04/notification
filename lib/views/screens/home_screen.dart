import 'package:flutter/material.dart';
import 'package:notification/service/notification_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (!LocalNotificationsService.notificationsEnabled)
              const Text(
                "Siz xabarnomaga ruxsat bermadingiz shu sabab sizga xabarnomalar kelmaydi."
                "\nBuni to'g'irlash uchun sozlamalarga borib to'girlang",
              ),
            FilledButton(
              onPressed: () {
                LocalNotificationsService.showNotification();
              },
              child: const Text("Oddiy Xabarnoma"),
            ),
            FilledButton(
              onPressed: () {
                LocalNotificationsService.showScheduledNotification();
              },
              child: const Text("Rejali Xabarnoma"),
            ),
            FilledButton(
              onPressed: () {
                LocalNotificationsService.showPeriodicNotification();
              },
              child: const Text("Davomiy Xabarnoma"),
            ),
          ],
        ),
      ),
    );
  }
}
