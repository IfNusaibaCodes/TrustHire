import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import '../../Model/planner_model.dart';
import '../../Pages/Planner/planner_database.dart';

class PlannerController extends GetxController {

  final PlannerDatabase _db          = PlannerDatabase();
  final AuthService     _authService = AuthService();


  String get _uid {
    final uid = _authService.getCurrentUid();
    if (uid == null || uid.isEmpty) throw Exception('User not logged in');
    return uid;
  }

  var tasks      = <TaskModel>[].obs;
  var isLoading  = false.obs;
  var streakDays = 0.obs;
  var filter     = 'All'.obs;


  late final String todayDate;
  late final String todayFormatted;

  static const List<Map<String, String>> _quotes = [
    {'text': 'The secret of getting ahead is getting started.', 'author': '— Mark Twain'},
    {'text': 'Small steps every day lead to big results.',       'author': '— Unknown'},
    {'text': 'Your only limit is your mind.',                    'author': '— Unknown'},
    {'text': 'Push yourself, because no one else will do it for you.', 'author': '— Unknown'},
    {'text': 'Dream it. Wish it. Do it.',                        'author': '— Unknown'},
  ];

  Map<String, String> get todayQuote {
    final index = DateTime.now().day % _quotes.length;
    return _quotes[index];
  }

  List<TaskModel> get filteredTasks {
    if (filter.value == 'Pending') return tasks.where((t) => !t.isDone).toList();
    if (filter.value == 'Done')    return tasks.where((t) =>  t.isDone).toList();
    return tasks.toList();
  }

  int    get completedCount => tasks.where((t) =>  t.isDone).length;
  int    get pendingCount   => tasks.where((t) => !t.isDone).length;
  double get progress       => tasks.isEmpty ? 0 : completedCount / tasks.length;

  void setFilter(String f) => filter.value = f;

  @override
  void onInit() {
    super.onInit();
    todayDate      = DateFormat('yyyy-MM-dd').format(DateTime.now());
    todayFormatted = DateFormat('EEEE, MMM d').format(DateTime.now());
    loadTasks();
    loadStreak();
  }

  Future<void> loadTasks() async {
    isLoading.value = true;
    try {
      tasks.value = await _db.loadTasks(_uid, todayDate);
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStreak() async {
    try {
      streakDays.value = await _db.loadStreak(_uid);
    } catch (_) {

    }
  }

  
  Future<void> toggleTask(String taskId, bool current) async {
    final i = tasks.indexWhere((t) => t.id == taskId);
    if (i != -1) {
      tasks[i].isDone = !current;
      tasks.refresh();
    }
    try {
      await _db.toggleTask(taskId, !current);

      final markingDone = !current;
      if (markingDone && completedCount == 1) {
        streakDays.value =
            await _db.recordActivityAndGetStreak(_uid, todayDate);
      }
    } catch (e) {
      if (i != -1) {
        tasks[i].isDone = current;
        tasks.refresh();
      }
      Get.snackbar('Could not update task', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }


  Future<bool> addTask(String title, String priority) async {
    try {
      final task = await _db.addTask(_uid, title, priority, todayDate);
      if (task != null) tasks.add(task);
      return true;
    } catch (e) {
      Get.snackbar('Could not add task', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }


  Future<void> deleteTask(String taskId) async {
    final index = tasks.indexWhere((t) => t.id == taskId);
    if (index == -1) return;
    final removed = tasks[index];
    tasks.removeAt(index);
    try {
      await _db.deleteTask(taskId);
    } catch (e) {
      tasks.insert(index, removed);
      Get.snackbar('Could not delete task', e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}