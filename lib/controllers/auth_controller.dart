import 'dart:async';
import 'dart:developer' as dev;
import 'dart:io';
import 'package:fixit/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../screens/home_screen.dart';
import '../screens/provider/provider_main_screen.dart';


class AuthController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Observable variables
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
    _checkCurrentUser();
  }

  /// Initialize auth state listener
  void _initAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final event = data.event;
      final session = data.session;

      dev.log('🔐 Auth Event: $event', name: 'AuthController');

      if (event == AuthChangeEvent.signedIn && session != null) {
        _handleSignedIn(session.user);
      } else if (event == AuthChangeEvent.signedOut) {
        _handleSignedOut();
      } else if (event == AuthChangeEvent.tokenRefreshed) {
        dev.log('✅ Token refreshed', name: 'AuthController');
      }
    });
  }

  /// Check if user is already logged in
  Future<void> _checkCurrentUser() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session != null) {
        await _loadUserData(session.user.id);
      }
    } catch (e) {
      dev.log('❌ Error checking current user: $e', name: 'AuthController');
    }
  }

  /// Handle user signed in
  Future<void> _handleSignedIn(User user) async {
    dev.log('✅ User signed in: ${user.email}', name: 'AuthController');
    await _loadUserData(user.id);

    // Navigate based on role after loading user data
    if (currentUser.value != null) {
      _navigateBasedOnRole();
    }
  }

  /// Handle user signed out
  void _handleSignedOut() {
    dev.log('🚪 User signed out', name: 'AuthController');
    currentUser.value = null;
    isAuthenticated.value = false;
    Get.offAll(() => const LoginScreen());
  }

  /// Load user data from database
  Future<void> _loadUserData(String userId) async {
    try {
      dev.log('📥 Loading user data for: $userId', name: 'AuthController');

      final response = await _supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();

      currentUser.value = UserModel.fromJson(response);
      isAuthenticated.value = true;

      dev.log(
        '✅ User data loaded: ${currentUser.value?.name}',
        name: 'AuthController',
      );
    } catch (e) {
      dev.log('❌ Error loading user data: $e', name: 'AuthController');
      // If user doesn't exist in database, create from auth metadata
      await _createUserFromAuth(userId);
    }
  }

  /// Create user in database from auth metadata
  Future<void> _createUserFromAuth(String userId) async {
    try {
      final authUser = _supabase.auth.currentUser;
      if (authUser == null) return;

      dev.log('📝 Creating user in database', name: 'AuthController');

      // Extract name from Google metadata or email
      String userName = 'User';
      if (authUser.userMetadata?['name'] != null) {
        userName = authUser.userMetadata!['name'];
      } else if (authUser.userMetadata?['full_name'] != null) {
        userName = authUser.userMetadata!['full_name'];
      } else if (authUser.email != null) {
        userName = authUser.email!.split('@')[0];
      }

      // Extract phone from metadata
      String? userPhone =
          authUser.userMetadata?['phone'] ??
          authUser.userMetadata?['phone_number'];

      // Extract avatar URL from Google metadata
      String? avatarUrl =
          authUser.userMetadata?['avatar_url'] ??
          authUser.userMetadata?['picture'];

      final userData = {
        'id': userId,
        'name': userName,
        'email': authUser.email!,
        'phone': userPhone,
        'role': authUser.userMetadata?['role'] ?? 'User',
        'avatar_url': avatarUrl,
      };

      dev.log('📝 User data to insert: $userData', name: 'AuthController');

      await _supabase.from('users').upsert(userData);

      // Reload user data
      await _loadUserData(userId);
    } catch (e) {
      dev.log('❌ Error creating user: $e', name: 'AuthController');
    }
  }

  /// Reload current user data from database
  Future<void> reloadUserData() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('No user logged in');
      }
      await _loadUserData(userId);
    } catch (e) {
      dev.log('❌ Error reloading user data: $e', name: 'AuthController');
      rethrow;
    }
  }

  /// Register with email and password
  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String role,
    String? category,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      dev.log('📝 Registering user: $email', name: 'AuthController');

      // Sign up user with retry logic
      AuthResponse? response;
      int retryCount = 0;
      const maxRetries = 3;

      while (retryCount < maxRetries) {
        try {
          response = await _supabase.auth
              .signUp(
                email: email,
                password: password,
                data: {'name': name, 'phone': phone, 'role': role},
              )
              .timeout(
                const Duration(seconds: 30),
                onTimeout: () {
                  throw TimeoutException('Registration request timed out');
                },
              );
          break; // Success, exit retry loop
        } on SocketException catch (e) {
          retryCount++;
          dev.log(
            '⚠️ Network error (attempt $retryCount/$maxRetries): $e',
            name: 'AuthController',
          );
          if (retryCount >= maxRetries) {
            throw Exception(
              'Network connection failed. Please check your internet and try again.',
            );
          }
          await Future.delayed(Duration(seconds: retryCount * 2));
        } on TimeoutException catch (e) {
          retryCount++;
          dev.log(
            '⚠️ Timeout error (attempt $retryCount/$maxRetries): $e',
            name: 'AuthController',
          );
          if (retryCount >= maxRetries) {
            throw Exception(
              'Request timed out. Please check your internet connection.',
            );
          }
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      }

      if (response?.user == null) {
        throw Exception('Failed to create user');
      }

      dev.log('✅ User registered successfully in auth', name: 'AuthController');

      // Create user record in database immediately
      try {
        final userData = {
          'id': response!.user!.id,
          'name': name,
          'email': email,
          'phone': phone,
          'role': role,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };

        dev.log(
          '📝 Creating user record in database: $userData',
          name: 'AuthController',
        );

        await _supabase.from('users').insert(userData);

        // If provider, create a default service entry
        if (role == 'Provider' && category != null) {
          // Get category ID
          final catResponse = await _supabase
              .from('categories')
              .select('id')
              .eq('name', category)
              .single();
          
          final categoryId = catResponse['id'];

          await _supabase.from('services').insert({
            'provider_id': response!.user!.id,
            'category_id': categoryId,
            'name': '$category Service',
            'description': 'Professional $category service by $name',
            'base_price': 500, // Default price
            'is_active': true,
          });
          dev.log('✅ Provider service created', name: 'AuthController');
        }

        dev.log('✅ User record created in database', name: 'AuthController');
      } catch (e) {
        dev.log('❌ Error creating user record: $e', name: 'AuthController');
        // Continue even if database insert fails - user can still login
      }

      // Sign out the user immediately after registration
      await _supabase.auth.signOut();

      dev.log(
        'ℹ️ User signed out after registration, redirecting to login',
        name: 'AuthController',
      );

      Get.snackbar(
        '✅ Success',
        'Account created! Please login',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      dev.log('❌ Registration error: $e', name: 'AuthController');
      errorMessage.value = e.toString();

      Get.snackbar(
        '❌ Registration Failed',
        _parseError(e.toString()),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Login with email and password
  Future<bool> login({required String email, required String password}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      dev.log('🔐 Logging in: $email', name: 'AuthController');

      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Login failed');
      }

      // Load user data
      await _loadUserData(response.user!.id);

      dev.log('✅ Login successful', name: 'AuthController');

      // Navigate based on role
      _navigateBasedOnRole();

      Get.snackbar(
        '✅ Welcome Back',
        'Logged in successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      dev.log('❌ Login error: $e', name: 'AuthController');
      errorMessage.value = e.toString();

      Get.snackbar(
        '❌ Login Failed',
        _parseError(e.toString()),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    GoogleSignIn? googleSignIn;

    try {
      isLoading.value = true;
      errorMessage.value = '';

      dev.log('🔐 Starting Google Sign-In', name: 'AuthController');

      // Initialize Google Sign In
      // Note: For production, add serverClientId from Google Cloud Console
      googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId:
            '317808486208-ht8mo4priqda0va8kumcfhkp9mtps0k5.apps.googleusercontent.com',
      );

      // Sign out first to ensure clean state and force account picker
      try {
        await googleSignIn.signOut();
        dev.log('✅ Cleared previous Google session', name: 'AuthController');
      } catch (e) {
        dev.log('⚠️ Sign out error (ignored): $e', name: 'AuthController');
      }

      // Show account picker and get selected account
      dev.log('📱 Showing Google account picker', name: 'AuthController');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        dev.log('❌ Google sign-in cancelled by user', name: 'AuthController');
        isLoading.value = false;
        return false;
      }

      dev.log(
        '✅ Google account selected: ${googleUser.email}',
        name: 'AuthController',
      );

      // Get authentication tokens
      dev.log('🔑 Requesting authentication tokens', name: 'AuthController');

      GoogleSignInAuthentication? googleAuth;
      try {
        // Clear any cached authentication first
        await googleUser.clearAuthCache();
        dev.log('✅ Cleared auth cache', name: 'AuthController');

        // Get fresh authentication
        googleAuth = await googleUser.authentication;

        dev.log(
          '🔍 Token status - AccessToken: ${googleAuth.accessToken != null ? "✓" : "✗"}, IdToken: ${googleAuth.idToken != null ? "✓" : "✗"}',
          name: 'AuthController',
        );
      } catch (e) {
        dev.log('❌ Token retrieval error: $e', name: 'AuthController');

        // Try one more time with a fresh sign-in
        dev.log('🔄 Attempting fresh sign-in', name: 'AuthController');
        await googleSignIn.signOut();
        final retryUser = await googleSignIn.signIn();

        if (retryUser == null) {
          throw Exception('Failed to sign in on retry');
        }

        googleAuth = await retryUser.authentication;
      }

      // Validate tokens
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        dev.log(
          '❌ Missing tokens - AccessToken: ${googleAuth.accessToken}, IdToken: ${googleAuth.idToken}',
          name: 'AuthController',
        );
        throw Exception(
          'Failed to get authentication tokens. Please try again or check your Google Play Services.',
        );
      }

      dev.log('✅ Successfully retrieved Google tokens', name: 'AuthController');

      // Sign in to Supabase with Google tokens
      dev.log('🔐 Signing in to Supabase', name: 'AuthController');
      final response = await _supabase.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken!,
      );

      if (response.user == null) {
        throw Exception('Supabase authentication failed');
      }

      dev.log(
        '✅ Google sign-in successful: ${response.user!.email}',
        name: 'AuthController',
      );

      // Check if user already exists and their role
      final userData = await _supabase
          .from('users')
          .select('role')
          .eq('id', response.user!.id)
          .maybeSingle();

      if (userData != null && userData['role'] == 'Provider') {
        // Sign out if provider tries to login via Google
        await _supabase.auth.signOut();
        Get.snackbar(
          '❌ Access Denied',
          'Google Login is only for Users. Providers must use Email/Password.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }

      // If new user via Google, they will be created as 'User' by _createUserFromAuth
      return true;
    } catch (e) {
      dev.log('❌ Google sign-in error: $e', name: 'AuthController');
      errorMessage.value = e.toString();

      // Clean up on error
      try {
        await googleSignIn?.signOut();
      } catch (_) {}

      String errorMsg = _parseError(e.toString());

      // Provide helpful error messages
      if (e.toString().contains('SIGN_IN_FAILED') ||
          e.toString().contains('network')) {
        errorMsg = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('authentication tokens')) {
        errorMsg =
            'Failed to get Google tokens. Please update Google Play Services.';
      }

      Get.snackbar(
        '❌ Google Sign-In Failed',
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      dev.log(
        '📧 Sending password reset email to: $email',
        name: 'AuthController',
      );

      await _supabase.auth.resetPasswordForEmail(
        email,
        redirectTo: 'fixit://reset-password',
      );

      dev.log('✅ Password reset email sent', name: 'AuthController');

      Get.snackbar(
        '✅ Email Sent',
        'Check your email for password reset link',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      dev.log('❌ Password reset error: $e', name: 'AuthController');
      errorMessage.value = e.toString();

      Get.snackbar(
        '❌ Failed',
        _parseError(e.toString()),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update password
  Future<bool> updatePassword(String newPassword) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      dev.log('🔒 Updating password', name: 'AuthController');

      await _supabase.auth.updateUser(UserAttributes(password: newPassword));

      dev.log('✅ Password updated', name: 'AuthController');

      Get.snackbar(
        '✅ Success',
        'Password updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      dev.log('❌ Password update error: $e', name: 'AuthController');
      errorMessage.value = e.toString();

      Get.snackbar(
        '❌ Failed',
        _parseError(e.toString()),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      isLoading.value = true;

      dev.log('🚪 Signing out', name: 'AuthController');

      await _supabase.auth.signOut();

      dev.log('✅ Signed out successfully', name: 'AuthController');

      Get.snackbar(
        '👋 Goodbye',
        'Signed out successfully',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      dev.log('❌ Sign out error: $e', name: 'AuthController');

      Get.snackbar(
        '❌ Error',
        'Failed to sign out',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Navigate based on user role
  void _navigateBasedOnRole() {
    if (currentUser.value == null) return;

    if (currentUser.value!.isProvider) {
      Get.offAll(() => const ProviderMainScreen());
    } else {
      Get.offAll(() => const HomeScreen());
    }
  }

  /// Parse error message
  String _parseError(String error) {
    if (error.contains('Invalid login credentials')) {
      return 'Invalid email or password';
    } else if (error.contains('Email not confirmed')) {
      return 'Please verify your email first';
    } else if (error.contains('User already registered')) {
      return 'This email is already registered';
    } else if (error.contains('Network') ||
        error.contains('SocketException') ||
        error.contains('Connection reset')) {
      return 'Network error. Please check your internet connection';
    } else if (error.contains('timed out') || error.contains('Timeout')) {
      return 'Request timed out. Please try again';
    } else if (error.contains('Failed host lookup')) {
      return 'Cannot connect to server. Check your internet';
    } else {
      return 'An error occurred. Please try again';
    }
  }

  /// Update user profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? city,
    String? avatarUrl,
  }) async {
    try {
      if (currentUser.value == null) return false;

      isLoading.value = true;

      dev.log('📝 Updating profile', name: 'AuthController');

      final updates = <String, dynamic>{};
      if (name != null) updates['name'] = name;
      if (phone != null) updates['phone'] = phone;
      if (address != null) updates['address'] = address;
      if (city != null) updates['city'] = city;
      if (avatarUrl != null) updates['avatar_url'] = avatarUrl;

      await _supabase
          .from('users')
          .update(updates)
          .eq('id', currentUser.value!.id);

      // Reload user data
      await _loadUserData(currentUser.value!.id);

      dev.log('✅ Profile updated', name: 'AuthController');

      Get.snackbar(
        '✅ Success',
        'Profile updated successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return true;
    } catch (e) {
      dev.log('❌ Profile update error: $e', name: 'AuthController');

      Get.snackbar(
        '❌ Failed',
        'Failed to update profile',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );

      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
