import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification/controller/task_controller.dart';
import 'package:notification/model/task_models.dart';
import 'package:provider/provider.dart';

class TaskDetailView extends StatelessWidget {
  final TaskModels task;

  const TaskDetailView({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskController = Provider.of<TaskController>(context);
    final TextEditingController descriptionController =
        TextEditingController(text: task.description);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
        title: Text(
          task.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.delete_solid,
              color: Colors.red,
            ),
            onPressed: () {
              taskController.deleteTask(task.id);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${task.title}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Time: ${task.time}',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: FilledButton(
                onPressed: () {
                  taskController.updateTask(
                      task.copyWith(description: descriptionController.text));
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
