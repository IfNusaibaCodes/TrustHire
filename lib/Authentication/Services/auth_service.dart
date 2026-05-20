
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;


  Future<AuthResponse> signInWithEmailAndPassword(
      String email, String password) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<AuthResponse> signUpWithEmailAndPassword(
      String first_name, String last_name, String email, String password) async {
    return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': first_name,
          'last_name': last_name
        }

    );

}

  Future<void> signOut() async {
    return await _supabase.auth.signOut();
  }

  String? getCurrentEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
  String? getCurrentFName() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.userMetadata?['first_name'];
  }
  String? getCurrentLName() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.userMetadata?['last_name'];
  }

}
