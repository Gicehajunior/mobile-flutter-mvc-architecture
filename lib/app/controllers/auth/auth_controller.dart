import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:nexus/config/app_logger.dart'; 
import 'package:jwt_decoder/jwt_decoder.dart'; 
import 'package:nexus/config/app_config.dart';
import 'package:nexus/config/controller.dart';
import 'package:nexus/config/view_request.dart';
import 'package:nexus/config/session_manager.dart';
import 'package:nexus/public/repos/lang/en.dart';
import 'package:nexus/config/mvc_exception.dart'; 

class AuthController extends CI {
    String? email;

    String? password;

    final Dio dio = Dio(); 
    
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

    Future<Map<String, dynamic>> authenticateUser({
        required String email,
        required String password
    }) async {
        try {
            final String clientToken = configList['clientToken'];
            final String apiBaseUrl = configList['apiBaseUrl'];
            final String endpoint = '$apiBaseUrl/api/admin/login';

            final response = await dio.post(
                endpoint,
                data: {'email': email, 'password': password},
                options: Options(
                    headers: {
                    'Content-Type': 'application/json',
                    'X-Server-Token': clientToken,
                    },
                ),
            );

            final Map<String, dynamic> responseData = response.data is String 
                ? jsonDecode(response.data) 
                : response.data;

            if (response.statusCode != 200 || responseData['status'] == 'error') {
                throw CustomException(message: responseData['message'] ?? lang['genericError']);
            }

            final String token = responseData['token'] ?? '';
            if (token.isEmpty || JwtDecoder.isExpired(token)) {
                throw CustomException(message: lang['tokenExpired'] ?? 'Invalid session.');
            }
            
            final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

            final String userId = decodedToken['user_id']?.toString() ?? '';
            final String userName = decodedToken['name'] ?? 'User';
            
            SessionManager sessionManager = SessionManager();
            await sessionManager.createSession(
                token: token,
                userId: userId,
                extra: decodedToken, 
            );
            
            return {
                'status': 'success',
                'message': lang['loginSuccess'] ?? 'Welcome back, $userName',
                'route': responseData['route'] ?? '/dashboard',
                'data': decodedToken,
            };
        } on CustomException catch (ce) {
            return {'status': 'error', 'message': ce.message};
        } catch (e) {
            Log.error('Auth Error: $e');
            return {'status': 'error', 'message': lang['genericError']};
        }
    }
   
    Future<Map<String, dynamic>> registerUser({
        required String name,
        required String email, 
        required String password,
        required String accountType,
        required bool termsAccepted
    }) async {
        try {
            final String clientToken = configList['clientToken'];
            final String apiBaseUrl = configList['apiBaseUrl'];
            final String endpoint = '$apiBaseUrl/api/admin/register';
            final String generatedUsername = name.toLowerCase().replaceAll(' ', '');

            final response = await dio.post(
                endpoint,
                data: {
                    'name': name,
                    'email': email, 
                    'password': password,
                    'terms': termsAccepted,
                    'accountType': accountType,
                    'username': generatedUsername,
                },
                options: Options(
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Server-Token': clientToken,
                    },
                ),
            );

            final Map<String, dynamic> responseData = response.data is String 
                ? jsonDecode(response.data) 
                : response.data;

            if (response.statusCode != 200 && response.statusCode != 201 || responseData['status'] == 'error') {
                throw CustomException(message: responseData['message'] ?? lang['registrationError'] ?? 'Registration failed.');
            }
            
            final String token = responseData['token'] ?? '';
            
            if (token.isNotEmpty && !JwtDecoder.isExpired(token)) {
                final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
                
                SessionManager sessionManager = SessionManager();
                await sessionManager.createSession(
                    token: token,
                    userId: decodedToken['user_id']?.toString() ?? '',
                    extra: decodedToken, 
                );

                return {
                    'status': 'success',
                    'message': responseData['message'] ?? lang['registrationSuccess'] ?? 'Account created successfully!',
                    'route': responseData['route'] ?? '/dashboard',
                    'data': decodedToken,
                };
            }

            return {
                'status': 'success',
                'message': responseData['message'] ?? 'Account created! Please log in.',
                'route': '/login',
            };

        } on CustomException catch (ce) {
            return {'status': 'error', 'message': ce.message};
        } catch (e) {
            Log.error('Registration Error: $e');
            return {'status': 'error', 'message': lang['genericError']};
        }
    }

    Future<Map<String, dynamic>> sendResetPasswordRequest({required String email}) async {
        return {'status': 'error'};
    }
}