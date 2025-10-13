import 'package:tech_proof/core/error/logger_service.dart';
import 'package:dartz/dartz.dart'; // Assuming you're using dartz for Either

// Define a base Failure class and some concrete Failure types

abstract class Failure {
  final String message;
  Failure(this.message);
}

class UnexpectedFailure extends Failure {
  UnexpectedFailure(super.message);
}

class SharedPreferencesFailure extends Failure {
  SharedPreferencesFailure(super.message);
}

/// Safely executes a synchronous SharedPreferences operation.
///
/// Returns a [Right] containing the result [T] on success,
/// or a [Left] containing a [Failure] on error.
Either<Failure, T> safeSharedPreferencesCall<T>(T Function() request) {
  try {
    final result = request();
    return Right(result);
  } catch (e, st) {
    LoggerService.error("SharedPreferences", e.toString(), st);
    // You could try to parse the error type if you expect specific SharedPreferences errors,
    // but for now, a generic UnexpectedFailure is a good starting point.
    return Left(
      SharedPreferencesFailure(
        "Error accessing SharedPreferences: ${e.toString()}",
      ),
    );
  }
}
