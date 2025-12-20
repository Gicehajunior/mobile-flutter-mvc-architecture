import 'package:logger/logger.dart';
import 'package:mvcflutter/config/app_config.dart';

class Log extends Logger {
  Log._internal()
      : super(
          printer: PrettyPrinter(),
        );

  static final Log _instance = Log._internal();

  static bool _canLog() {
    if (configList['enableDebug'] == true &&
        configList['enableLogging'] == true &&
        configList['appEnv'] == 'development') {
      return true;
    }

    return false;
  }

  static void debug(dynamic message) {
    if (_canLog()) _instance.d(message);
  }

  static void info(dynamic message) {
    if (_canLog()) {
      final Logger loggerNoStack =
          Logger(printer: PrettyPrinter(methodCount: 0));
      loggerNoStack.i(message);
    }
  }

  static void warning(dynamic message) {
    if (_canLog()) {
      final Logger loggerNoStack =
          Logger(printer: PrettyPrinter(methodCount: 0));
      loggerNoStack.w(message);
    }
  }

  static void error(dynamic message,
      {dynamic error, StackTrace? stackTrace, DateTime? timestamp}) {
    if (_canLog()) {
      _instance.e(message,
          error: error, stackTrace: stackTrace, time: timestamp);
    }
  }

  static void trace(dynamic message) {
    if (_canLog()) {
      final Logger loggerNoStack =
          Logger(printer: PrettyPrinter(methodCount: 0));
      loggerNoStack.t(message);
    }
  }

  static void simple(dynamic message) {
    if (_canLog()) {
      Logger(printer: SimplePrinter(colors: true)).t(message);
    }
  }
}
