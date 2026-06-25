import 'package:supabase_flutter/supabase_flutter.dart';
import '../../Model/planner_model.dart';


class PlannerDatabase {
  static final _client = Supabase.instance.client;

  Future<List<TaskModel>> loadTasks(String userId, String todayDate) async {
    final response = await _client
        .from('planner_tasks')
        .select()
        .eq('user_id', userId)
        .eq('date', todayDate)
        .order('created_at');
    return (response as List).map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<TaskModel?> addTask(
      String userId, String title, String priority, String todayDate) async {
    final response = await _client.from('planner_tasks').insert({
      'user_id':  userId,
      'title':    title,
      'priority': priority,
      'is_done':  false,
      'date':     todayDate,
    }).select().single();
    return TaskModel.fromMap(response);
  }

  Future<void> toggleTask(String taskId, bool newValue) async {
    await _client
        .from('planner_tasks')
        .update({'is_done': newValue})
        .eq('id', taskId);
  }

  Future<void> deleteTask(String taskId) async {
    await _client.from('planner_tasks').delete().eq('id', taskId);
  }

  Future<int> loadStreak(String userId) async {
    final response = await _client
        .from('planner_streaks')
        .select('streak_days')
        .eq('user_id', userId)
        .maybeSingle();
    return (response?['streak_days'] as int?) ?? 0;
  }


  Future<int> recordActivityAndGetStreak(String userId, String today) async {
    final row = await _client
        .from('planner_streaks')
        .select('streak_days, last_date')
        .eq('user_id', userId)
        .maybeSingle();

    final lastDate   = row?['last_date']   as String?;
    final lastStreak = (row?['streak_days'] as int?) ?? 0;

    if (lastDate == today) return lastStreak;

    final yesterday = DateFormatter.yesterday();
    final newStreak = (lastDate == yesterday) ? lastStreak + 1 : 1;

    await _client.from('planner_streaks').upsert({
      'user_id':     userId,
      'streak_days': newStreak,
      'last_date':   today,
    }, onConflict: 'user_id');

    return newStreak;
  }
}

class DateFormatter {
  static String yesterday() {
    final d = DateTime.now().subtract(const Duration(days: 1));
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}
