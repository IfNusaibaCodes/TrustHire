// ============================================================
//  FILE: lib/Pages/planner_page.dart
// ============================================================
//
//  ── CURRENT MODE: FRONTEND / UI TESTING ──────────────────
//  No Supabase calls active. Everything works locally.
//  Data resets when you close the app — that's normal.
//
//  ── WHEN BACKEND IS READY ────────────────────────────────
//  Step 1: Create table in Supabase SQL Editor:
//
//  create table tasks (
//    id         uuid default gen_random_uuid() primary key,
//    user_id    uuid references auth.users(id),
//    title      text not null,
//    is_done    boolean default false,
//    priority   text default 'Normal',
//    date       date default current_date,
//    created_at timestamp default now()
//  );
//
//  Step 2: Add RLS policies:
//
//  create policy "Users can read own tasks"
//    on tasks for select using (auth.uid() = user_id);
//  create policy "Users can insert own tasks"
//    on tasks for insert with check (auth.uid() = user_id);
//  create policy "Users can update own tasks"
//    on tasks for update using (auth.uid() = user_id);
//  create policy "Users can delete own tasks"
//    on tasks for delete using (auth.uid() = user_id);
//
//  Step 3: Find every comment that says
//          🔵 BACKEND — uncomment those lines
//          🟡 FRONTEND — delete or comment those lines
//
//  TABLE WILL LOOK LIKE THIS:
//  ┌──────────┬─────────────────────┬─────────┬───────────────┬────────────┐
//  │ user_id  │ title               │ is_done │ priority      │ date       │
//  ├──────────┼─────────────────────┼─────────┼───────────────┼────────────┤
//  │ abc-123  │ Apply to 2 jobs     │ false   │ High Priority │ 2026-05-25 │
//  │ abc-123  │ Learn a new skill   │ true    │ Growth        │ 2026-05-25 │
//  └──────────┴─────────────────────┴─────────┴───────────────┴────────────┘
//
// ============================================================

import 'package:flutter/material.dart';
// 🔵 BACKEND: uncomment this when wiring Supabase
// import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});
  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {

  // 🔵 BACKEND: uncomment when wiring Supabase
  // final supabase = Supabase.instance.client;

  // ── STATE ──────────────────────────────────────────────────
  // 🟡 FRONTEND: starts with dummy tasks so UI looks good
  List<Map<String, dynamic>> tasks = [
    {
      'id': '1',
      'title': 'Apply to 2 jobs',
      'priority': 'High Priority',
      'is_done': false,
    },
    {
      'id': '2',
      'title': 'Learn a new skill',
      'priority': 'Growth',
      'is_done': true,
    },
    {
      'id': '3',
      'title': 'Practice mock interview',
      'priority': 'Ready',
      'is_done': false,
    },
  ];

  bool isLoading = false; // 🟡 FRONTEND: no loading needed locally
  int streakDays = 5;     // 🟡 FRONTEND: dummy streak number
  String _filter = 'All';

  // ── THEME ──────────────────────────────────────────────────
  static const Color primary  = Color(0xFF3B5BDB);
  static const Color bgColor  = Color(0xFFF5F6FA);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF9CA3AF);
  static const Color success  = Color(0xFF10B981);

  final List<String> priorities = [
    'High Priority', 'Growth', 'Ready', 'Normal'
  ];

  final List<Map<String, String>> quotes = [
    {'text': '"The secret of getting ahead is getting started."',   'author': '— Mark Twain'},
    {'text': '"Believe you can and you\'re halfway there."',         'author': '— Theodore Roosevelt'},
    {'text': '"It always seems impossible until it\'s done."',       'author': '— Nelson Mandela'},
    {'text': '"Push yourself, because no one else will."',           'author': '— Unknown'},
    {'text': '"Great things never come from comfort zones."',        'author': '— Unknown'},
    {'text': '"Dream it. Wish it. Do it."',                          'author': '— Unknown'},
    {'text': '"Success doesn\'t just find you. Go out and get it."', 'author': '— Unknown'},
  ];

  Map<String, String> get todayQuote =>
      quotes[DateTime.now().weekday % quotes.length];

  String get todayFormatted =>
      DateFormat('EEEE, MMM d').format(DateTime.now());

  String get todayDate =>
      DateFormat('yyyy-MM-dd').format(DateTime.now());

  List<Map<String, dynamic>> get filteredTasks {
    if (_filter == 'Pending') return tasks.where((t) => t['is_done'] != true).toList();
    if (_filter == 'Done')    return tasks.where((t) => t['is_done'] == true).toList();
    return tasks;
  }

  int get completedCount => tasks.where((t) => t['is_done'] == true).length;
  int get pendingCount   => tasks.where((t) => t['is_done'] != true).length;
  double get progress    => tasks.isEmpty ? 0 : completedCount / tasks.length;

  @override
  void initState() {
    super.initState();
    // 🔵 BACKEND: uncomment these when wiring Supabase
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   loadTasks();
    //   loadStreak();
    // });
  }

  // ════════════════════════════════════════════════════════════
  //  🟡 FRONTEND: TOGGLE TASK (local only)
  //  🔵 BACKEND:  delete this method and uncomment toggleTask()
  //               below it
  // ════════════════════════════════════════════════════════════
  void toggleTask(String taskId, bool currentValue) {
    setState(() {
      final i = tasks.indexWhere((t) => t['id'] == taskId);
      if (i != -1) tasks[i]['is_done'] = !currentValue;
    });
  }

  // 🔵 BACKEND: uncomment this when wiring Supabase
  // Future<void> toggleTask(String taskId, bool currentValue) async {
  //   setState(() {
  //     final i = tasks.indexWhere((t) => t['id'] == taskId);
  //     if (i != -1) tasks[i]['is_done'] = !currentValue;
  //   });
  //   try {
  //     await supabase
  //         .from('tasks')
  //         .update({'is_done': !currentValue})  // updates is_done column
  //         .eq('id', taskId);
  //     loadStreak();
  //   } catch (e) {
  //     setState(() {
  //       final i = tasks.indexWhere((t) => t['id'] == taskId);
  //       if (i != -1) tasks[i]['is_done'] = currentValue;
  //     });
  //     _snack('Could not update task', isError: true);
  //   }
  // }

  // ════════════════════════════════════════════════════════════
  //  🟡 FRONTEND: ADD TASK (local only)
  //  🔵 BACKEND:  delete this method and uncomment addTask() below
  // ════════════════════════════════════════════════════════════
  void addTask(String title, String priority) {
    setState(() => tasks.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'priority': priority,
      'is_done': false,
      'date': todayDate,
    }));
    _snack('Task added ✅');
  }

  // 🔵 BACKEND: uncomment this when wiring Supabase
  // Future<void> addTask(String title, String priority) async {
  //   try {
  //     final userId = supabase.auth.currentUser?.id;
  //     if (userId == null) return;
  //     final response = await supabase
  //         .from('tasks')
  //         .insert({
  //           'user_id':  userId,    // COLUMN: who owns this task
  //           'title':    title,     // COLUMN: task text
  //           'priority': priority,  // COLUMN: High Priority/Growth/Ready/Normal
  //           'is_done':  false,     // COLUMN: starts unchecked
  //           'date':     todayDate, // COLUMN: today's date
  //         })
  //         .select()
  //         .single();
  //     setState(() => tasks.add(response));
  //     _snack('Task added ✅');
  //   } catch (e) {
  //     _snack('Could not add task: $e', isError: true);
  //   }
  // }

  // ════════════════════════════════════════════════════════════
  //  🟡 FRONTEND: DELETE TASK (local only)
  //  🔵 BACKEND:  delete this method and uncomment deleteTask()
  // ════════════════════════════════════════════════════════════
  void deleteTask(String taskId) {
    setState(() => tasks.removeWhere((t) => t['id'] == taskId));
    _snack('Task removed');
  }

  // 🔵 BACKEND: uncomment this when wiring Supabase
  // Future<void> deleteTask(String taskId) async {
  //   setState(() => tasks.removeWhere((t) => t['id'] == taskId));
  //   try {
  //     await supabase
  //         .from('tasks')
  //         .delete()
  //         .eq('id', taskId); // deletes this row from tasks table
  //   } catch (e) {
  //     _snack('Could not delete', isError: true);
  //     loadTasks();
  //   }
  // }

  // 🔵 BACKEND: uncomment this when wiring Supabase
  // Future<void> loadTasks() async {
  //   setState(() => isLoading = true);
  //   try {
  //     final userId = supabase.auth.currentUser?.id;
  //     if (userId == null) {
  //       if (mounted) setState(() { isLoading = false; tasks = []; });
  //       return;
  //     }
  //     final response = await supabase
  //         .from('tasks')
  //         .select()
  //         .eq('user_id', userId)   // only this user's tasks
  //         .eq('date', todayDate)   // only today's tasks
  //         .order('created_at');
  //     if (mounted) setState(() {
  //       tasks = List<Map<String, dynamic>>.from(response);
  //       isLoading = false;
  //     });
  //   } catch (e) {
  //     if (mounted) setState(() => isLoading = false);
  //     _snack('Could not load tasks', isError: true);
  //   }
  // }

  // 🔵 BACKEND: uncomment this when wiring Supabase
  // Future<void> loadStreak() async {
  //   try {
  //     final userId = supabase.auth.currentUser?.id;
  //     if (userId == null) return;
  //     final response = await supabase
  //         .from('tasks')
  //         .select('date')
  //         .eq('user_id', userId)
  //         .eq('is_done', true);
  //     final Set<String> doneDates = (response as List)
  //         .map((r) => r['date'].toString().substring(0, 10))
  //         .toSet();
  //     int streak = 0;
  //     DateTime day = DateTime.now();
  //     while (doneDates.contains(DateFormat('yyyy-MM-dd').format(day))) {
  //       streak++;
  //       day = day.subtract(const Duration(days: 1));
  //     }
  //     if (mounted) setState(() => streakDays = streak);
  //   } catch (_) {}
  // }

  // ── ADD TASK BOTTOM SHEET ──────────────────────────────────
  void _showAddTask() {
    final ctrl = TextEditingController();
    String selectedPriority = 'Normal';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Container(
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              )),
              const SizedBox(height: 20),
              const Text('New Task',
                  style: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold, color: textDark)),
              const SizedBox(height: 4),
              const Text('What do you want to accomplish today?',
                  style: TextStyle(fontSize: 13, color: textGrey)),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'e.g. Apply to 2 jobs',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: const Icon(Icons.edit_outlined,
                      color: primary, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Set Priority',
                  style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700, color: textDark)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8, runSpacing: 8,
                children: priorities.map((p) {
                  final bool sel = selectedPriority == p;
                  final Color c = _priorityColor(p);
                  return GestureDetector(
                    onTap: () => setSheet(() => selectedPriority = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: sel
                            ? c.withOpacity(0.12)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: sel ? c : Colors.grey.shade200,
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: sel ? c : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(p, style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: sel ? c : Colors.grey,
                          )),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (ctrl.text.trim().isEmpty) return;
                    Navigator.pop(ctx);
                    addTask(ctrl.text.trim(), selectedPriority);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                    elevation: 0,
                  ),
                  child: const Text('Add Task',
                      style: TextStyle(color: Colors.white,
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _priorityColor(String p) {
    switch (p) {
      case 'High Priority': return const Color(0xFF6366F1);
      case 'Growth':        return const Color(0xFF7C3AED);
      case 'Ready':         return success;
      default:              return primary;
    }
  }

  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: isError ? const Color(0xFFEF4444) : success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }

  // ════════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator(color: primary))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── TOP BAR ─────────────────────────────
              Row(
                children: [
                  const Icon(Icons.shield, color: primary, size: 28),
                  const SizedBox(width: 6),
                  const Text('TrustHire',
                      style: TextStyle(
                          color: primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  const Spacer(),
                  const Icon(Icons.search, color: primary),
                ],
              ),
              const SizedBox(height: 22),

              // ── TITLE ────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Today's Plan",
                          style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: textDark)),
                      const SizedBox(height: 2),
                      Text(todayFormatted,
                          style: const TextStyle(
                              color: textGrey, fontSize: 13)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${tasks.length} tasks',
                      style: const TextStyle(
                          color: primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── PROGRESS CARD ─────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B5BDB), Color(0xFF4C6EF5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primary.withOpacity(0.25),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text('Daily Progress',
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor:
                        Colors.white.withOpacity(0.2),
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                            Colors.white),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _progressChip('$completedCount Done',
                            Icons.check_circle_outline),
                        const SizedBox(width: 10),
                        _progressChip('$pendingCount Pending',
                            Icons.radio_button_unchecked),
                        const Spacer(),
                        const Text('🔥',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text('$streakDays day streak',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── FILTER TABS ───────────────────────────
              Row(
                children: ['All', 'Pending', 'Done'].map((f) {
                  final bool sel = _filter == f;
                  return GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 8),
                      decoration: BoxDecoration(
                        color: sel ? primary : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: sel
                            ? [
                          BoxShadow(
                              color: primary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3))
                        ]
                            : null,
                      ),
                      child: Text(f,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : textGrey,
                          )),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // ── TASK LIST ─────────────────────────────
              if (filteredTasks.isEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 36, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          _filter == 'Done'
                              ? Icons.celebration_outlined
                              : Icons.check_circle_outline,
                          size: 52,
                          color: _filter == 'Done'
                              ? success
                              : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _filter == 'Done'
                              ? 'No completed tasks yet.\nStart checking things off!'
                              : _filter == 'Pending'
                              ? 'All tasks done! Great job! 🎉'
                              : 'No tasks yet.\nTap + to get started.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: textGrey,
                              fontSize: 14,
                              height: 1.5),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...filteredTasks.map((task) {
                  final bool isDone = task['is_done'] == true;
                  final String priority =
                      task['priority'] ?? 'Normal';
                  final Color pColor = _priorityColor(priority);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: isDone
                          ? Colors.grey.shade50
                          : Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border(
                        left: BorderSide(
                          color: isDone
                              ? Colors.grey.shade300
                              : pColor,
                          width: 4,
                        ),
                      ),
                      boxShadow: isDone
                          ? null
                          : [
                        BoxShadow(
                          color:
                          Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),

                      // ── Checkbox ────────────────────────
                      leading: GestureDetector(
                        onTap: () => toggleTask(task['id'], isDone),
                        child: AnimatedContainer(
                          duration:
                          const Duration(milliseconds: 200),
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: isDone
                                ? pColor
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                              color: isDone
                                  ? pColor
                                  : Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          child: isDone
                              ? const Icon(Icons.check,
                              size: 16, color: Colors.white)
                              : null,
                        ),
                      ),

                      // Task title — strikethrough when done
                      title: Text(
                        task['title'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDone
                              ? Colors.grey.shade400
                              : textDark,
                          decoration: isDone
                              ? TextDecoration.lineThrough
                              : null,
                          decorationColor: Colors.grey.shade400,
                        ),
                      ),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Priority tag
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? Colors.grey.shade100
                                  : pColor.withOpacity(0.1),
                              borderRadius:
                              BorderRadius.circular(20),
                            ),
                            child: Text(
                              priority,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDone
                                    ? Colors.grey
                                    : pColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          // ── DELETE button (works on web + phone)
                          GestureDetector(
                            onTap: () => deleteTask(task['id']),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.08),
                                borderRadius:
                                BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.delete_outline,
                                size: 16,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              const SizedBox(height: 6),

              // ── ADD TASK BUTTON ───────────────────────
              GestureDetector(
                onTap: _showAddTask,
                child: Container(
                  width: double.infinity,
                  padding:
                  const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: primary.withOpacity(0.25),
                      width: 1.5,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline,
                          color: primary, size: 20),
                      SizedBox(width: 8),
                      Text('Add task',
                          style: TextStyle(
                              color: primary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── STREAK CARD ───────────────────────────
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text('🔥',
                          style: TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Daily Streak',
                              style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: textDark)),
                          const SizedBox(height: 3),
                          Text(
                            streakDays >= 3
                                ? "You're in the top 10% this week! 🎉"
                                : 'Complete tasks to build streak',
                            style: TextStyle(
                              fontSize: 12,
                              color: streakDays >= 3
                                  ? success
                                  : textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text('$streakDays',
                            style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                color: textDark)),
                        const Text('days',
                            style: TextStyle(
                                fontSize: 11, color: textGrey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ── QUOTE CARD ────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primary.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                              Icons.format_quote_rounded,
                              color: primary, size: 18),
                        ),
                        const SizedBox(width: 8),
                        const Text('Daily Motivation',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: textDark)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      todayQuote['text']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: textDark,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        todayQuote['author']!,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}