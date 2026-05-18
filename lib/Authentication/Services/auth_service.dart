
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
      String fName, String lName, String email, String password) async {
    return await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'F_name': fName,
          'L_name': lName,
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
  String? getCurrentName() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.userMetadata?['F_name L_name'];
  }

}
