import 'package:mvcflutter/config/controller.dart';
import 'package:mvcflutter/config/view_request.dart';

class AuthController extends CI {
    String? email;
    String? password;
    Map<String, dynamic>? data;

    AuthController({this.data});
    
    ViewRequest loginView({String? prefilledEmail, String? prefilledPassword}) {
        return ViewRequest( 'auth/login_screen', data: {
            'email': prefilledEmail,
            'password': prefilledPassword
        });
    }
    
    ViewRequest forgotPassView({String? prefilledEmail}) {
        return ViewRequest( 'auth/forgot_password', data: {
            'email': prefilledEmail
        });
    }

    Future<Map<String, dynamic>> authenticateUser() async {
        return {'status': 'error'};
    }
}