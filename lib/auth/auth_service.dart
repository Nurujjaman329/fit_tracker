import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

final SupabaseClient _supabase = Supabase.instance.client;

Future<AuthResponse> signInWithEmailPassword(String email, String password) async {
  try {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
    return response;
  } catch (e) {
    throw Exception('Failed to sign in: $e');
  }
}

Future<AuthResponse> signUpWithEmailPassword(String email, String password) async {
  try {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
    );
    return response;
  } catch (e) {
    throw Exception('Failed to sign up: $e');
  }
}

Future<void> signOut() async {
  try {
    await _supabase.auth.signOut();
  } catch (e) {
    throw Exception('Failed to sign out: $e');
  }
}

Future<User?> getCurrentUser() async {
  try {
    final user = _supabase.auth.currentUser;
    return user;
  } catch (e) {
    throw Exception('Failed to get current user: $e');
  }

}

}