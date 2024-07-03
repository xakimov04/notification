import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification/controller/task_controller.dart';
import 'package:notification/model/task_models.dart';
import 'package:notification/service/notification_service.dart';
import 'package:notification/views/screens/task_detail_view.dart';
import 'package:provider/provider.dart';

class TaskListView extends StatefulWidget {
  const TaskListView({super.key});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCheckingTasks();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCheckingTasks() {
    _timer = Timer.periodic(
      const Duration(minutes: 1),
      (timer) => _checkTasks(),
    );
  }

  Future<void> _checkTasks() async {
    final taskController = Provider.of<TaskController>(context, listen: false);
    final tasks = await taskController.getAllTasks();
    final now = DateTime.now();

    for (var task in tasks) {
      final taskTime = DateTime.parse(task.time);
      final difference = taskTime.difference(now);
      print(taskTime);
      print(difference.inMinutes);

      if (difference.inMinutes == 5) {
        LocalNotificationsService.showScheduledNotificationForTask(task.title);
      } else if (difference.inMinutes == 0 && difference.inSeconds <= 60) {
        LocalNotificationsService.showTaskDueNotification(task.title);
      }
    }
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, TaskController taskController, String taskId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Delete Task',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.red),
            ),
            onPressed: () {
              taskController.deleteTask(taskId);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    return StreamBuilder<List<TaskModels>>(
      stream: taskController.taskStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error loading tasks"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No tasks available"));
        } else {
          final tasks = snapshot.data!;
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final item = tasks[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: ListTile(
                    trailing: GestureDetector(
                      onTap: () => _showDeleteConfirmationDialog(
                          context, taskController, item.id),
                      child: const Icon(
                        CupertinoIcons.delete_solid,
                        color: Colors.red,
                      ),
                    ),
                    leading: GestureDetector(
                      onTap: () =>
                          taskController.updateIsDone(item.id, !item.isDone),
                      child: Icon(
                        item.isDone
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: item.isDone ? Colors.green : Colors.black,
                      ),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        decoration:
                            item.isDone ? TextDecoration.lineThrough : null,
                        color: item.isDone ? Colors.grey : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          item.time,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailView(task: item),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
