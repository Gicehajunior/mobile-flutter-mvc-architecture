import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:mvcflutter/config/session_manager.dart';

class CI {
  /// Pretty prints JSON data with indentation
  String prettyJson(dynamic data) {
    const encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(data);
  }

  /// Retrieves the current user session as a Map
  Future<Map<String, dynamic>> session() async {
    SessionManager sm = SessionManager();
    final sessionObj = await sm.getSession();

    // Ensure it's a Map, fallback to empty
    final Map<String, dynamic> session = sessionObj ?? {};

    return session;
  }
  
  /// Returns current date in MySQL datetime format (Y-m-d H:i:s)
  String getTodayDateTime() {
    final now = DateTime.now();
    return _formatToMySQLDateTime(now);
  }

  /// Returns current date in MySQL date format (Y-m-d)
  String getTodayDate() {
    final now = DateTime.now();
    return _formatToMySQLDate(now);
  }

  /// Returns date time from X days ago in MySQL format
  String getDateTimeFromDaysAgo(int days) {
    final date = DateTime.now().subtract(Duration(days: days));
    return _formatToMySQLDateTime(date);
  }

  /// Returns date from X days ago in MySQL date format
  String getDateFromDaysAgo(int days) {
    final date = DateTime.now().subtract(Duration(days: days));
    return _formatToMySQLDate(date);
  }

  /// Format DateTime to MySQL datetime string (Y-m-d H:i:s)
  String _formatToMySQLDateTime(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')} '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}:'
        '${dateTime.second.toString().padLeft(2, '0')}';
  }

  /// Format DateTime to MySQL date string (Y-m-d)
  String _formatToMySQLDate(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.day.toString().padLeft(2, '0')}';
  }

  /// Convert ISO string to MySQL datetime format
  String isoToMySQLDateTime(String isoString) {
    final dateTime = DateTime.parse(isoString);
    return _formatToMySQLDateTime(dateTime);
  }

  /// Convert ISO string to MySQL date format
  String isoToMySQLDate(String isoString) {
    final dateTime = DateTime.parse(isoString);
    return _formatToMySQLDate(dateTime);
  }

  String currencyFormatter(
    num amount, {
    String symbol = 'KES',
    String locale = 'en_KE',
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: '$symbol ',
      decimalDigits: decimalDigits,
    );

    return formatter.format(amount);
  }
}
