import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  static final _client = Supabase.instance.client;

  static Future<bool> isAdmin() async {
    try {
      final uid = _client.auth.currentUser?.id;
      if (uid == null) return false;
      final res = await _client
          .from('profiles')
          .select('is_admin')
          .eq('id', uid)
          .single();
      return res['is_admin'] == true;
    } catch (_) {
      return false;
    }
  }
}
