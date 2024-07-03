import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notification/model/task_models.dart';
import 'package:notification/service/tasks_service.dart';

class TaskController extends ChangeNotifier {
  final TasksService _tasksService = TasksService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<TaskModels> _tasks = [];
  List<TaskModels> get tasks => List.unmodifiable(_tasks);
  late final StreamSubscription _taskSubscription;

  TaskController() {
    _init();
  }

  void updateTask(TaskModels task) {
    _tasksService.updateTask(
      task.id,
      title: task.title,
      description: task.description,
      time: task.time,
      isDone: task.isDone,
    );
  }

  void _init() {
    _taskSubscription = _tasksService.getTasks().listen(
      (snapshot) {
        _tasks =
            snapshot.docs.map((doc) => TaskModels.fromSnapshot(doc)).toList();
        notifyListeners();
      },
      onError: (error) {
        print('Error loading tasks: $error');
      },
    );
  }

  Stream<List<TaskModels>> get taskStream => _tasksService.getTasks().map(
        (snapshot) =>
            snapshot.docs.map((doc) => TaskModels.fromSnapshot(doc)).toList(),
      );

  Future<List<TaskModels>> getAllTasks() async {
    final snapshot = await _firestore.collection('tasks').get();
    return snapshot.docs.map((doc) => TaskModels.fromSnapshot(doc)).toList();
  }

  void addTask(String title, String description, String time) {
    _tasksService.addTask(title, description, time);
  }

  void deleteTask(String taskId) {
    _tasksService.deleteTask(taskId);
  }

  void updateIsDone(String taskId, bool newIsDone) {
    _tasksService.updateIsDone(taskId, newIsDone);
  }

  @override
  void dispose() {
    _taskSubscription.cancel();
    super.dispose();
  }
}
