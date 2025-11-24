import 'package:go_router/go_router.dart';
import 'package:mvcflutter/public/repos/lang/en.dart';
import 'package:mvcflutter/public/repos/global/Repository.dart';
import 'package:mvcflutter/app/controllers/auth/auth_controller.dart';

class  AuthRepository extends Repository {
    AuthRepository(super.context);

    Future<void> authLogin({required String email, required String password}) async {
        AuthController authController = new AuthController();
        final response = await authController.authenticateUser();
        
        final status = response['status'] ?? 'error';
        if (status != 'success') {
            this.alert(
                status: status,
                title: 'Login Failed',
                message: response?['message'] ?? lang['genericError']!,
            );
            return;
        }

        context.push('/dashboard');
    }

    Future<void> resetPassword({required String email}) async {
        print("Reset password in progress...");
    }
}