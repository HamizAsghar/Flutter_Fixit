import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking_model.dart';
import 'dart:developer' as dev;

class BookingController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  final RxList<BookingModel> userBookings = <BookingModel>[].obs;
  final RxList<BookingModel> providerBookings = <BookingModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final userId = _supabase.auth.currentUser?.id;
    if (userId != null) {
      fetchUserBookings(userId);
      fetchProviderBookings(userId);
      _listenToBookings(userId);
    }
  }

  /// Fetch bookings for a user
  Future<void> fetchUserBookings(String userId) async {
    try {
      isLoading.value = true;
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      userBookings.value = (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } catch (e) {
      dev.log('❌ Error fetching user bookings: $e', name: 'BookingController');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch bookings for a provider
  Future<void> fetchProviderBookings(String providerId) async {
    try {
      isLoading.value = true;
      final response = await _supabase
          .from('bookings')
          .select()
          .eq('provider_id', providerId)
          .order('created_at', ascending: false);
      
      providerBookings.value = (response as List)
          .map((json) => BookingModel.fromJson(json))
          .toList();
    } catch (e) {
      dev.log('❌ Error fetching provider bookings: $e', name: 'BookingController');
    } finally {
      isLoading.value = false;
    }
  }

  /// Listen to real-time updates in bookings table
  void _listenToBookings(String userId) {
    // Listen for bookings where user is either customer or provider
    _supabase
        .from('bookings')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
          dev.log('🔄 Real-time update in bookings', name: 'BookingController');
          
          userBookings.value = data
              .where((item) => item['user_id'] == userId)
              .map((json) => BookingModel.fromJson(json))
              .toList();
          
          providerBookings.value = data
              .where((item) => item['provider_id'] == userId)
              .map((json) => BookingModel.fromJson(json))
              .toList();
        });
  }

  /// Create a new booking
  Future<bool> createBooking(Map<String, dynamic> bookingData) async {
    try {
      isLoading.value = true;
      await _supabase.from('bookings').insert(bookingData);
      return true;
    } catch (e) {
      dev.log('❌ Error creating booking: $e', name: 'BookingController');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Update booking status
  Future<bool> updateBookingStatus(String bookingId, String status) async {
    try {
      isLoading.value = true;
      await _supabase
          .from('bookings')
          .update({'status': status, 'updated_at': DateTime.now().toIso8601String()})
          .eq('id', bookingId);
      return true;
    } catch (e) {
      dev.log('❌ Error updating booking status: $e', name: 'BookingController');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
