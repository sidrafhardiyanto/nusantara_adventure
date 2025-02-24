import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../core/utils/appwrite_client.dart';
import '../features/auth/domain/user_model.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  return AuthNotifier();
});

// Provider untuk status registrasi
final registerStatusProvider = StateProvider<String?>((ref) => null);

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  AuthNotifier() : super(const AsyncValue.data(null));
  
  final account = Account(AppwriteClient.client);

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      final user = await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      
      state = const AsyncValue.data(null); // Reset state untuk login
      return true; // Return true jika registrasi berhasil
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      return false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = const AsyncValue.loading();
      
      await account.createEmailPasswordSession(
        email: email,
        password: password,
      );
      
      final user = await account.get();
      state = AsyncValue.data(UserModel.fromJson(user.toMap()));
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSessions();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> checkAuth() async {
    try {
      final user = await account.get();
      state = AsyncValue.data(UserModel.fromJson(user.toMap()));
    } catch (e) {
      state = const AsyncValue.data(null);
    }
  }
} 