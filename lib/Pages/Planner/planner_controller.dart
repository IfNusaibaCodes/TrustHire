import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'planner_model.dart';
import 'planner_database.dart';

class PlannerController extends GetxController {

  final PlannerDatabase _db          = PlannerDatabase();
  final AuthService     _authService = AuthService();

  // FIX 1: throw if not logged in instead of silently using empty string
  String get _uid {
    final uid = _authService.getCurrentUid();
    if (uid == null || uid.isEmpty) throw Exception('User not logged in');
    return uid;
  }

  var tasks      = <TaskModel>[].obs;
  var isLoading  = false.obs;
  var streakDays = 0.obs;
  var filter     = 'All'.obs;

  // FIX 2: computed once on init so date never changes mid-session
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
    // FIX 2: set date once here
    todayDate      = DateFormat('yyyy-MM-dd').format(DateTime.now());
    todayFormatted = DateFormat('EEEE, MMM d').format(DateTime.now());
    loadTasks();
    loadStreak();
  }

  Future<void> loadTasks() async {
    isLoading.value = true;
    tasks.value = await _db.loadTasks(_uid, todayDate);
    isLoading.value = false;
  }

  Future<void> loadStreak() async {
    streakDays.value = await _db.loadStreak(_uid);
  }

  void toggleTask(String taskId, bool current) {
    final i = tasks.indexWhere((t) => t.id == taskId);
    if (i != -1) {
      tasks[i].isDone = !current;
      tasks.refresh();
    }
    _db.toggleTask(taskId, !current);

    // FIX 3: only call streak update on the FIRST completed task of the session
    // avoids redundant Supabase calls (backend already guards duplicate days)
    final markingDone = !current;
    if (markingDone && completedCount == 1) {
      _db.recordActivityAndGetStreak(_uid, todayDate).then((newStreak) {
        streakDays.value = newStreak;
      });
    }
  }

  Future<void> addTask(String title, String priority) async {
    final task = await _db.addTask(_uid, title, priority, todayDate);
    if (task != null) tasks.add(task);
  }

  void deleteTask(String taskId) {
    tasks.removeWhere((t) => t.id == taskId);
    _db.deleteTask(taskId);
  }
}