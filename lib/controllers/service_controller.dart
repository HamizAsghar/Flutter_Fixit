import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/service_model.dart';
import 'dart:developer' as dev;

class ServiceController extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  final RxList<ServiceModel> allServices = <ServiceModel>[].obs;
  final RxList<ServiceModel> providerServices = <ServiceModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllServices();
    _listenToServices();
  }

  /// Fetch all active services for users
  Future<void> fetchAllServices() async {
    try {
      isLoading.value = true;
      final response = await _supabase
          .from('services')
          .select()
          .eq('is_active', true)
          .order('created_at', ascending: false);
      
      allServices.value = (response as List)
          .map((json) => ServiceModel.fromJson(json))
          .toList();
    } catch (e) {
      dev.log('❌ Error fetching services: $e', name: 'ServiceController');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch services for a specific provider
  Future<void> fetchProviderServices(String providerId) async {
    try {
      isLoading.value = true;
      final response = await _supabase
          .from('services')
          .select()
          .eq('provider_id', providerId)
          .order('created_at', ascending: false);
      
      providerServices.value = (response as List)
          .map((json) => ServiceModel.fromJson(json))
          .toList();
    } catch (e) {
      dev.log('❌ Error fetching provider services: $e', name: 'ServiceController');
    } finally {
      isLoading.value = false;
    }
  }

  /// Listen to real-time updates in services table
  void _listenToServices() {
    _supabase
        .from('services')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
          dev.log('🔄 Real-time update in services', name: 'ServiceController');
          allServices.value = data
              .where((item) => item['is_active'] == true)
              .map((json) => ServiceModel.fromJson(json))
              .toList();
          
          // If we are tracking provider services, update that too
          final currentUserId = _supabase.auth.currentUser?.id;
          if (currentUserId != null) {
            providerServices.value = data
                .where((item) => item['provider_id'] == currentUserId)
                .map((json) => ServiceModel.fromJson(json))
                .toList();
          }
        });
  }

  /// Add a new service (for providers)
  Future<bool> addService(Map<String, dynamic> serviceData) async {
    try {
      isLoading.value = true;
      await _supabase.from('services').insert(serviceData);
      return true;
    } catch (e) {
      dev.log('❌ Error adding service: $e', name: 'ServiceController');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
