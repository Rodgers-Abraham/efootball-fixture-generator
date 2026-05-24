import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.cache({
    required String message,
  }) = CacheFailure;

  const factory Failure.validation({
    required String message,
    Map<String, String>? fieldErrors,
  }) = ValidationFailure;

  const factory Failure.ocr({
    required String message,
    @Default(0.0) double confidence,
  }) = OcrFailure;

  const factory Failure.auth({
    required String message,
  }) = AuthFailure;

  const factory Failure.network({
    required String message,
  }) = NetworkFailure;
}

extension FailureX on Failure {
  String get displayMessage {
    return when(
      server: (message, _) => message,
      cache: (message) => message,
      validation: (message, _) => message,
      ocr: (message, _) => message,
      auth: (message) => message,
      network: (message) => message,
    );
  }
}
