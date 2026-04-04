import 'package:nexus/config/session_manager.dart';

class CI { 
  /// Retrieves the current user session as a Map
  Future<Map<String, dynamic>> session() async {
    SessionManager sm = SessionManager();
    final sessionObj = await sm.getSession();

    // Ensure it's a Map, fallback to empty
    final Map<String, dynamic> session = sessionObj ?? {};

    return session;
  }

  /// Add more implementations below
}
