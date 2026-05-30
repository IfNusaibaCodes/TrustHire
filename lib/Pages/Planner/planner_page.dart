import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'planner_controller.dart';
import 'planner_widgets.dart';

class PlannerPage extends StatelessWidget {
  const PlannerPage({super.key});

  // ── THEME ──────────────────────────────────────────────────
  static const Color primary  = Color(0xFF3B5BDB);
  static const Color bgColor  = Color(0xFFF5F6FA);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF9CA3AF);
  static const Color success  = Color(0xFF10B981);

  final List<String> priorities = const [
    'High Priority', 'Growth', 'Ready', 'Normal'
  ];

  Color _priorityColor(String p) {
    switch (p) {
      case 'High Priority': return const Color(0xFF6366F1);
      case 'Growth':        return const Color(0xFF7C3AED);
      case 'Ready':         return success;
      default:              return primary;
    }
  }

  void _snack(BuildContext context, String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg,
          style: const TextStyle(fontWeight: FontWeight.w600)),
      backgroundColor: isError ? const Color(0xFFEF4444) : success,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      margin: const EdgeInsets.all(16),
    ));
  }

  void _showAddTask(BuildContext context) {
    final c    = Get.find<PlannerController>();
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
                children: ['High Priority', 'Growth', 'Ready', 'Normal'].map((p) {
                  final bool sel = selectedPriority == p;
                  final Color col = _priorityColor(p);
                  return GestureDetector(
                    onTap: () => setSheet(() => selectedPriority = p),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 9),
                      decoration: BoxDecoration(
                        color: sel
                            ? col.withOpacity(0.12)
                            : Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: sel ? col : Colors.grey.shade200,
                          width: sel ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: BoxDecoration(
                              color: sel ? col : Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(p, style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: sel ? col : Colors.grey,
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
                    c.addTask(ctrl.text.trim(), selectedPriority);
                    _snack(context, 'Task added ✅');
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

  // ════════════════════════════════════════════════════════════
  //  BUILD
  // ════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    final c = Get.find<PlannerController>();

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Obx(() => c.isLoading.value
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
                      Text(c.todayFormatted,
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
                      '${c.tasks.length} tasks',
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
                          '${(c.progress * 100).toInt()}%',
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
                        value: c.progress,
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
                        ProgressChip('${c.completedCount} Done',
                            Icons.check_circle_outline),
                        const SizedBox(width: 10),
                        ProgressChip('${c.pendingCount} Pending',
                            Icons.radio_button_unchecked),
                        const Spacer(),
                        const Text('🔥',
                            style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 4),
                        Text('${c.streakDays.value} day streak',
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
                  final bool sel = c.filter.value == f;
                  return GestureDetector(
                    onTap: () => c.setFilter(f),
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
              if (c.filteredTasks.isEmpty)
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
                          c.filter.value == 'Done'
                              ? Icons.celebration_outlined
                              : Icons.check_circle_outline,
                          size: 52,
                          color: c.filter.value == 'Done'
                              ? success
                              : Colors.grey.shade300,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          c.filter.value == 'Done'
                              ? 'No completed tasks yet.\nStart checking things off!'
                              : c.filter.value == 'Pending'
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
                ...c.filteredTasks.map((task) {
                  final bool isDone     = task.isDone;
                  final String priority = task.priority;
                  final Color pColor    = _priorityColor(priority);

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
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      leading: GestureDetector(
                        onTap: () => c.toggleTask(task.id, isDone),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 26, height: 26,
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
                      title: Text(
                        task.title,
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: isDone
                                  ? Colors.grey.shade100
                                  : pColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              priority,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isDone ? Colors.grey : pColor,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          GestureDetector(
                            onTap: () {
                              c.deleteTask(task.id);
                              _snack(context, 'Task removed');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
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
                onTap: () => _showAddTask(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
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
                            c.streakDays.value >= 3
                                ? "You're in the top 10% this week! 🎉"
                                : 'Complete tasks to build streak',
                            style: TextStyle(
                              fontSize: 12,
                              color: c.streakDays.value >= 3
                                  ? success
                                  : textGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text('${c.streakDays.value}',
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
                      c.todayQuote['text']!,
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
                        c.todayQuote['author']!,
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
        )),
      ),
    );
  }
}