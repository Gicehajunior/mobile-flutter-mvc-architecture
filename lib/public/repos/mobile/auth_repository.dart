import 'package:go_router/go_router.dart'; 
// import 'package:mvcflutter/config/app_logger.dart';
import 'package:mvcflutter/config/mvc_exception.dart';
import 'package:mvcflutter/public/repos/lang/en.dart'; 
// import 'package:mvcflutter/public/repos/methods/global.dart';
import 'package:mvcflutter/public/repos/global/repository.dart'; 
import 'package:mvcflutter/app/controllers/auth/auth_controller.dart';

class AuthRepository extends Repository {
  late final AuthController _authController;

  AuthRepository(super.context, super.ref, super.registry) { 
    _authController = AuthController(); 
  }
  
  Future<void> authLogin({
    required String email, 
    required String password
  }) async {
    try {
      if (email.isEmpty) {
        throw CustomException(
            message: lang['empty_email'] ?? 'Email cannot be empty.');
      }

      if (password.isEmpty) {
        throw CustomException(
            message: lang['empty_password'] ?? 'Password cannot be empty.');
      }

      final response = await _authController.authenticateUser(
        email: email, 
        password: password
      );

      final status = response['status'] ?? 'error';
      if (status != 'success') {
        throw CustomException(message: response['message'] ?? lang['genericError']!);
      }
      
      registry.updateStateProvider(ref, 'session', response['data']); 
      
      // Show success message
      alert(
        status: response['status'], 
        title: 'Account Login', 
        message: response['message'] ?? 'Your have been logged in successfully. Please wait as we take you to the dashboard!',
      );

      await Future.delayed(const Duration(seconds: 3));

      if (!context.mounted) return;
      final String? targetRoute = response['route'];
      if (targetRoute != null && targetRoute.isNotEmpty) {
        context.push(targetRoute);
      }
    } catch (error) { 
      final userError = CustomException.translate(error);
      alert(status: 'error', title: 'Login Failed', message: userError.message);
    }
  }

  Future<void> authSignup({ 
    required String name, 
    required String email, 
    required String password,
    required String accountType,
    bool termsAccepted = false,
  }) async {
    try {
      // Validate termsAccepted
      if (!termsAccepted) {
        throw CustomException(
          message: lang['terms_required'] ?? 'Please accept the Terms and Conditions to continue.',
        );
      }

      if (name.isEmpty) {
        throw CustomException(
          message: lang['empty_name'] ?? 'Full name cannot be empty.',
        );
      }

      if (name.length < 3) {
        throw CustomException(
          message: lang['name_too_short'] ?? 'Name must be at least 3 characters.',
        );
      }

      // Validate email
      if (email.isEmpty) {
        throw CustomException(
          message: lang['empty_email'] ?? 'Email cannot be empty.',
        );
      }

      // Basic email format validation
      if (!email.contains('@') || !email.contains('.')) {
        throw CustomException(
          message: lang['invalid_email'] ?? 'Please enter a valid email address.',
        );
      }

      // Validate password
      if (password.isEmpty) {
        throw CustomException(
          message: lang['empty_password'] ?? 'Password cannot be empty.',
        );
      }

      if (password.length < 8) {
        throw CustomException(
          message: lang['password_too_short'] ?? 'Password must be at least 8 characters.',
        );
      }

      // Check for uppercase letter
      if (!RegExp(r'[A-Z]').hasMatch(password)) {
        throw CustomException(
          message: lang['password_uppercase'] ?? 'Password must contain at least one uppercase letter.',
        );
      }

      // Check for number
      if (!RegExp(r'[0-9]').hasMatch(password)) {
        throw CustomException(
          message: lang['password_number'] ?? 'Password must contain at least one number.',
        );
      }

      // Call your signup API 
      final response = await _authController.registerUser(
        name: name,
        email: email,
        password: password,
        accountType: accountType,
        termsAccepted: termsAccepted
      );

      final status = response['status'] ?? 'error';
      if (status != 'success') {
        throw CustomException(
          message: response['message'] ?? lang['genericError']!,
        );
      }

      if (!context.mounted) return;
      
      // Show success message
      alert(
        status: response['status'], 
        title: 'Account Created', 
        message: response['message'] ?? 'Your account has been created successfully. Please login to access your account!',
      );
      
      await Future.delayed(const Duration(seconds: 3));

      // Navigate to dashboard or login
      if (!context.mounted) return;
      final String? targetRoute = response['route'];
      if (targetRoute != null && targetRoute.isNotEmpty) {
        context.push(targetRoute);
      }
    } catch (error) {
      final userError = CustomException.translate(error);
      alert(
        status: 'error', 
        title: 'Signup Failed', 
        message: userError.message,
      );
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      if (email.isEmpty) {
        throw CustomException(
            message: lang['empty_email'] ?? 'Email cannot be empty.');
      }

      final response = await _authController.sendResetPasswordRequest(email: email);

      final status = response['status'] ?? 'error';
      if (status != 'success') {
        throw CustomException(
            message: response['message'] ?? lang['genericError']!);
      }

      if (!context.mounted) return;
      context.push('/login');
    } catch (error) {
      final userError = CustomException.translate(error);
      alert(
          status: 'error', title: 'Reset Password', message: userError.message);
    }
  }
}
