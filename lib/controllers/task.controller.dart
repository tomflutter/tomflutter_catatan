import 'package:get/get.dart';
import 'package:tomflutter_catatan/db/db.helper.dart';
import 'package:tomflutter_catatan/models/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task!);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTask(int id) async {
    await DBHelper.delete(id);
    getTasks();
  }

  void markTaskAsCompleted(int id) async {
    await DBHelper.updateTask(id);
    getTasks();
  }

  Future<void> updateTaskInfo(Task task) async {
    await DBHelper.updateTaskInfo(task);
    getTasks();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    getTasks(); // Fetch all tasks when the controller is ready
  }
}
