import 'package:mvcflutter/config/controller.dart';
import 'package:mvcflutter/config/view_request.dart';

class AuthController extends CI {
    String? email;
    String? password;
    Map<String, dynamic>? data;

    AuthController({this.data});
    
    MVCFRequest loginView({String? prefilledEmail, String? prefilledPassword}) {
        return MVCFRequest( 'auth/login_screen', data: {
            'email': prefilledEmail,
            'password': prefilledPassword
        });
    }
    
    MVCFRequest forgotPassView({String? prefilledEmail}) {
        return MVCFRequest( 'auth/forgot_password', data: {
            'email': prefilledEmail
        });
    }

    Future<Map<String, dynamic>> authenticateUser() async {
        return {'status': 'error'};
    }
}