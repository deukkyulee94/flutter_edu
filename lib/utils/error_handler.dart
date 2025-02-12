import 'package:flutter/material.dart';

class AppError implements Exception {
  final String message;
  final int? statusCode;

  AppError(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ErrorHandler {
  static void handleError(BuildContext context, dynamic error) {
    String message = '오류가 발생했습니다.';

    if (error is AppError) {
      message = error.message;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
