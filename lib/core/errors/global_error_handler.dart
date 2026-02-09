import 'package:flutter/foundation.dart';

/// Global error handler to capture uncaught Flutter and Dart errors.
///
/// In debug mode this will log errors to the console. In production, you can
/// extend this to report errors to a crash reporting service.
class GlobalErrorHandler {
  const GlobalErrorHandler._();

  static void init() {
    // Handle Flutter framework errors.
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      _report(details.exception, details.stack);
    };

    // Handle uncaught asynchronous errors.
    PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
      _report(error, stack);
      // Returning true prevents the error from being propagated further.
      return true;
    };
  }

  static void _report(Object error, StackTrace? stack) {
    if (kDebugMode) {
      // For now just log to console; hook into Sentry/Crashlytics here later.
      debugPrint('Uncaught error: $error');
      if (stack != null) {
        debugPrint(stack.toString());
      }
    }
  }
}

