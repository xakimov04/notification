import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notification/model/task_models.dart';

class TasksService {
  final _tasksCollection = FirebaseFirestore.instance.collection("tasks");

  Stream<QuerySnapshot> getTasks() async* {
    yield* _tasksCollection.snapshots();
  }

  void addTask(String title, String description, String time) {
    _tasksCollection.add({
      "title": title,
      "description": description,
      "time": time,
      "isDone": false,
    });
  }

  void deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  void updateIsDone(String taskId, bool newIsDone) {
    _tasksCollection.doc(taskId).update({"isDone": newIsDone});
  }

  void updateTask(String taskId, {String? title, String? description, String? time, bool? isDone}) {
    final data = <String, dynamic>{};
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (time != null) data['time'] = time;
    if (isDone != null) data['isDone'] = isDone;

    _tasksCollection.doc(taskId).update(data);
  }
}
