import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // REGISTER + insert into users table
  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
  }) async {
    // Sign up user with metadata
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: 'fixit://login-callback',
      data: {
        'name': name,
        'phone': phone,
        'role': role,
      },
    );

    final user = response.user;
    if (user == null) {
      throw Exception("Failed to create user");
    }

    try {
      await _supabase.from('users').upsert({
        'id': user.id,
        'name': name,
        'email': email,
        'phone': phone,
        'role': role,
      });
    } catch (e) {
      print("Error inserting into users table: $e");
    }
  }

  // LOGIN
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    return await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // GOOGLE LOGIN (Supabase Native OAuth - NO FIREBASE)
  Future<void> signInWithGoogle() async {
    try {
      // This will open the browser for Google Login
      // After login, it will redirect back to the app using fixit://login-callback
      await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: kIsWeb ? null : 'fixit://login-callback',
      );
    } catch (e) {
      rethrow;
    }
  }

  // SEND PASSWORD RESET EMAIL
  Future<void> sendResetEmail(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: 'fixit://reset-password',
    );
  }

  // UPDATE PASSWORD
  Future<void> updatePassword(String newPassword) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
  }

  // LOGOUT
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  User? get currentUser => _supabase.auth.currentUser;
}
