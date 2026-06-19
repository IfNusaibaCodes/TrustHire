import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:trust_hire_app/Authentication/Services/auth_service.dart';
import 'package:trust_hire_app/admin/admin_service.dart';
import 'package:trust_hire_app/profile/profile_database.dart';
import '../../Model/notification_model.dart';
import '../../Pages/Notifications/notification_database.dart';

class NotificationController extends GetxController {
  final _authService = AuthService();
  final _profileDb   = ProfileDatabase();

  String get _uid => _authService.getCurrentUid() ?? '';

  List<NotificationModel> _all = [];

  var isLoading    = false.obs;
  var hasError     = false.obs;
  var activeFilter = Rxn<String>(); 
  var _tick        = 0.obs;         

  RealtimeChannel? _channel;

  List<NotificationModel> get filtered {
    _tick.value; // subscribe
    final f = activeFilter.value;
    if (f == null) return List.from(_all);
    return _all.where((n) => n.type == f).toList();
  }

  int get unreadCount {
    _tick.value; // subscribe
    return _all.where((n) => !n.isRead).length;
  }

  @override
  void onInit() {
    super.onInit();
    load();
    _startRealtime();
  }

  @override
  void onClose() {
    if (_channel != null) NotificationService.unsubscribe(_channel!);
    super.onClose();
  }

  Future<void> load() async {
    isLoading.value = true;
    hasError.value  = false;
    try {
      final uid     = _uid;
      final profile = await _profileDb.loadProfile();
      final isAdmin = await AdminService.isAdmin();

      _all = await NotificationService.fetchNotifications(
        uid:        uid,
        userRole:   isAdmin ? 'admin' : null,
        university: profile.university,
        studyYear:  profile.studyYear,
      );
      _tick.value++;
    } catch (_) {
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  void _startRealtime() {
    try {
      _channel = NotificationService.subscribeToInserts(load);
    } catch (_) {
      
    }
  }

  void setFilter(String? type) {
    activeFilter.value = type;
    _tick.value++;
  }

  Future<void> markRead(String id) async {
    final i = _all.indexWhere((n) => n.id == id);
    if (i == -1 || _all[i].isRead) return;

    _all[i].isRead = true;
    _tick.value++;

    try {
      await NotificationService.markAsRead(_uid, id);
    } catch (_) {
      _all[i].isRead = false; // rollback
      _tick.value++;
    }
  }

  Future<void> markAllRead() async {
    final unreadIds = _all.where((n) => !n.isRead).map((n) => n.id).toList();
    if (unreadIds.isEmpty) return;

    for (final n in _all) n.isRead = true;
    _tick.value++;

    try {
      await NotificationService.markAllAsRead(_uid, unreadIds);
    } catch (_) {
      for (final n in _all.where((n) => unreadIds.contains(n.id))) {
        n.isRead = false; // rollback
      }
      _tick.value++;
    }
  }
}
