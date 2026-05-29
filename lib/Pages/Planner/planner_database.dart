

import 'planner_model.dart';

class PlannerDatabase {
  Future<List<TaskModel>> loadTasks(String todayDate) async {
    return [];
  }

  Future<TaskModel?> addTask(String userId, String title,
      String priority, String todayDate) async {
    return null;
  }

  Future<void> toggleTask(String taskId, bool newValue) async {
    return;
  }

  Future<void> deleteTask(String taskId) async {
    return;
  }

  Future<int> loadStreak(String userId) async {
    return 5;
  }
}