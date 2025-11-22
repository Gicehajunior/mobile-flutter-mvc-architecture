import 'package:mvcflutter/config/view_request.dart';

class AuthController {
    const AuthController();
  
    MVCFRequest loginView({String? prefilledEmail}) {
        return MVCFRequest( 'auth/login_screen', data: {
            'email': prefilledEmail
        });
    }
}