import 'package:mvcflutter/config/controller.dart';
import 'package:mvcflutter/config/view_request.dart';

class AuthController extends CI {
    
    MVCFRequest loginView({String? prefilledEmail, String? prefilledPassword}) {
        return MVCFRequest( 'auth/login_screen', data: {
            'email': prefilledEmail,
            'password': prefilledPassword
        });
    }
}