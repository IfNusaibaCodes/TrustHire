import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trust_hire_app/Utilities/Constants/colors.dart';
import 'package:trust_hire_app/Utilities/Constants/responsive.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/app_snackbar.dart';
import 'package:trust_hire_app/Utilities/Customs/Reuseable_Widgets/trust_hire_app_bar.dart';
import '../../Authentication/Controllers/planner_controller.dart';
import '../../Utilities/Customs/Reuseable_Widgets/planner_widgets.dart';
import '../Burnout/burnout_check_page.dart';

class PlannerPage extends StatefulWidget {
  const PlannerPage({super.key});

  @override
  State<PlannerPage> createState() => _PlannerPageState();
}

class _PlannerPageState extends State<PlannerPage> {
  final _taskCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<PlannerController>()) {
      Get.put(PlannerController());
    }
  }

  @override
  void dispose() {
    _taskCtrl.dispose();
    super.dispose();
  }

  final List<String> priorities = const [
    'High Priority', 'Growth', 'Ready', 'Normal'
  ];

  Color _priorityColor(String p) {
    switch (p) {
      case 'High Priority': return const Color(0xFF6366F1);
      case 'Growth':        return const Color(0xFF7C3AED);
      case 'Ready':         return TColors.appSuccess;
      default:              return TColors.appPrimary;
    }
  }

  void _snack(BuildContext context, String msg, {bool isError = false}) {
    showAppSnackBar(context, msg, isError: isError);
  }

  void _showAddTask(BuildContext context) {
    final c = Get.find<PlannerController>();
    _taskCtrl.clear();
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
                      fontWeight: FontWeight.bold, color: TColors.appTextDark)),
              const SizedBox(height: 4),
              const Text('What do you want to accomplish today?',
                  style: TextStyle(fontSize: 13, color: TColors.appTextGrey)),
              const SizedBox(height: 16),
              TextField(
                controller: _taskCtrl,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'e.g. Apply to 2 jobs',
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  prefixIcon: const Icon(Icons.edit_outlined,
                      color: TColors.appPrimary, size: 20),
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
                    borderSide: const BorderSide(color: TColors.appPrimary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text('Set Priority',
                  style: TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700, color: TColors.appTextDark)),
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
                  onPressed: () async {
                    if (_taskCtrl.text.trim().isEmpty) return;
                    final messenger = ScaffoldMessenger.of(context);
                    Navigator.pop(ctx);
                    final ok = await c.addTask(_taskCtrl.text.trim(), selectedPriority);
                    if (!ok) return;
                    messenger.showSnackBar(SnackBar(
                      content: const Text('Task added ✅',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      backgroundColor: TColors.appSuccess,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      margin: const EdgeInsets.all(16),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.appPrimary,
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


  void _confirmDelete(BuildContext context, String taskId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Task?',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        content: const Text('This task will be permanently removed.',
            style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF9CA3AF))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Get.find<PlannerController>().deleteTask(taskId);
              _snack(context, 'Task removed');
            },
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
     Responsive().init(context); 
    final c = Get.find<PlannerController>();

    return Scaffold(
      backgroundColor: TColors.appBackground,
      appBar: const TrustHireAppBar(title: 'Your Daily Plan'),
      body: SafeArea(
        child: Obx(() => c.isLoading.value
            ? const Center(child: CircularProgressIndicator(color: TColors.appPrimary))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

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
                              color: TColors.appTextDark)),
                      const SizedBox(height: 2),
                      Text(c.todayFormatted,
                          style: const TextStyle(
                              color: TColors.appTextGrey, fontSize: 13)),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: TColors.appPrimary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${c.tasks.length} tasks',
                      style: const TextStyle(
                          color: TColors.appPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A1F36), Color(0xFF4F6EF7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1A1F36).withOpacity(0.25),
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ProgressChip('${c.completedCount} Done',
                            Icons.check_circle_outline),
                        const SizedBox(width: 10),
                        ProgressChip('${c.pendingCount} Pending',
                            Icons.radio_button_unchecked),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),


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
                        color: sel ? TColors.appPrimary : Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: sel
                            ? [
                          BoxShadow(
                              color: TColors.appPrimary.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3))
                        ]
                            : null,
                      ),
                      child: Text(f,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: sel ? Colors.white : TColors.appTextGrey,
                          )),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),


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
                              ? TColors.appSuccess
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
                              color: TColors.appTextGrey,
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
                              : TColors.appTextDark,
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
                            onTap: () => _confirmDelete(context, task.id),
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

              GestureDetector(
                onTap: () => _showAddTask(context),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: TColors.appPrimary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: TColors.appPrimary.withOpacity(0.25),
                      width: 1.5,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle_outline,
                          color: TColors.appPrimary, size: 20),
                      SizedBox(width: 8),
                      Text('Add task',
                          style: TextStyle(
                              color: TColors.appPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: 14)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

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
                                  color: TColors.appTextDark)),
                          const SizedBox(height: 3),
                          Text(
                            c.streakDays.value >= 3
                                ? "You're in the top 10% this week! 🎉"
                                : 'Complete tasks to build streak',
                            style: TextStyle(
                              fontSize: 12,
                              color: c.streakDays.value >= 3
                                  ? TColors.appSuccess
                                  : TColors.appTextGrey,
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
                                color: TColors.appTextDark)),
                        const Text('days',
                            style: TextStyle(
                                fontSize: 11, color: TColors.appTextGrey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              const _BurnoutBanner(),
              const SizedBox(height: 16),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: TColors.appPrimary.withOpacity(0.1),
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
                            color: TColors.appPrimary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                              Icons.format_quote_rounded,
                              color: TColors.appPrimary, size: 18),
                        ),
                        const SizedBox(width: 8),
                        const Text('Daily Motivation',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: TColors.appTextDark)),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Text(
                      c.todayQuote['text']!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        color: TColors.appTextDark,
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
                            color: TColors.appPrimary),
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

class _BurnoutBanner extends StatelessWidget {
  const _BurnoutBanner();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const BurnoutPage()),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1A1F36), Color(0xFF4F6EF7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A1F36).withOpacity(0.28),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('🧠', style: TextStyle(fontSize: 26)),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feeling overwhelmed?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Take a quick burnout check-in\nand get personalised tips.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}