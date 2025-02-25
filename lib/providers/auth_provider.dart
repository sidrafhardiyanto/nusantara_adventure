import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appwrite/appwrite.dart';
import '../core/utils/appwrite_client.dart';
import '../features/auth/domain/user_model.dart';
import '../utils/error_handler.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<UserModel?>>((ref) {
  final client = Client()
      .setEndpoint('https://cloud.appwrite.io/v1')
      .setProject('your-project-id');

  final account = Account(client);
  final databases = Databases(client);

  return AuthNotifier(
    account: account,
    databases: databases,
    client: client,
  );
});

// Provider untuk status registrasi
final registerStatusProvider = StateProvider<String?>((ref) => null);

class AuthNotifier extends StateNotifier<AsyncValue<UserModel?>> {
  final Account account;
  final Databases databases;
  final Client client;

  AuthNotifier({
    required this.account,
    required this.databases,
    required this.client,
  }) : super(const AsyncValue.data(null));

  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      state = const AsyncValue.loading();

      await account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );

      state = const AsyncValue.data(null);
      return true;
    } catch (e) {
      final errorMessage = ErrorHandler.getErrorMessage(e);
      state = AsyncValue.error(errorMessage, StackTrace.current);
      return false;
    }
  }

  Future<bool> login({
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
      return true;
    } catch (e) {
      final errorMessage = ErrorHandler.getErrorMessage(e);
      state = AsyncValue.error(errorMessage, StackTrace.current);
      return false;
    }
  }

  Future<void> logout() async {
    try {
      await account.deleteSessions();
      state = const AsyncValue.data(null);
    } catch (e) {
      final errorMessage = ErrorHandler.getErrorMessage(e);
      state = AsyncValue.error(errorMessage, StackTrace.current);
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
