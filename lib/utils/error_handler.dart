import 'package:flutter/material.dart';

class ErrorHandler {
  static void showErrorSnackbar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static void showSuccessSnackbar(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  static String getErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();
    
    // Appwrite specific errors
    if (errorString.contains('appwriteexception')) {
      if (errorString.contains('invalid credentials') || 
          errorString.contains('user invalid credentials') ||
          errorString.contains('401')) {
        return 'Email atau password salah';
      } else if (errorString.contains('user not found')) {
        return 'Email belum terdaftar';
      } else if (errorString.contains('email already exists')) {
        return 'Email sudah terdaftar';
      } else if (errorString.contains('invalid email')) {
        return 'Format email tidak valid';
      } else if (errorString.contains('weak password')) {
        return 'Password terlalu lemah, minimal 8 karakter';
      } else if (errorString.contains('rate limit')) {
        return 'Terlalu banyak percobaan. Silakan coba lagi nanti';
      }
    }

    // Network errors
    if (errorString.contains('network')) {
      return 'Gagal terhubung ke server. Periksa koneksi internet Anda';
    }
    
    // General errors
    if (errorString.contains('timeout')) {
      return 'Koneksi timeout. Silakan coba lagi';
    }
    
    // Default error message
    return 'Terjadi kesalahan. Silakan coba lagi nanti';
  }
} 