import 'package:go_router/go_router.dart';
import 'package:mvcflutter/config/mvc_exception.dart';
import 'package:mvcflutter/public/repos/lang/en.dart';
import 'package:mvcflutter/public/repos/global/Repository.dart';
import 'package:mvcflutter/app/controllers/auth/auth_controller.dart';

class  AuthRepository extends Repository {
    AuthRepository(super.context);

    Future<void> authLogin({required String email, required String password}) async {
        try {
            if (email.isEmpty) { 
                throw CustomException(message: lang['empty_email'] ?? 'Email cannot be empty.');
            }

            if (password.isEmpty) {
                throw CustomException(message: lang['empty_password'] ?? 'Password cannot be empty.');
            }

            AuthController authController = new AuthController();
            final response = await authController.authenticateUser();
            
            final status = response['status'] ?? 'error';
            if (status != 'success') { 
                throw CustomException(message: response?['message'] ?? lang['genericError']!);
            }

            context.push('/dashboard');
        } catch (error) {
            final userError = CustomException.translate(error); 
            this.alert(status: 'error', title: 'Login Failed', message: userError.message);
        }
    }

    Future<void> resetPassword({required String email}) async {
        try {
            if (email.isEmpty) {
                throw CustomException(message: lang['empty_email'] ?? 'Email cannot be empty.');
            } 

            AuthController authController = new AuthController();
            final response = await authController.sendResetPasswordRequest();
            
            final status = response['status'] ?? 'error';
            if (status != 'success') { 
                throw CustomException(message: response?['message'] ?? lang['genericError']!);
            }

            context.push('/login');
        } catch (error) {
            final userError = CustomException.translate(error); 
            this.alert(status: 'error', title: 'Reset Password', message: userError.message);
        }
    }
}