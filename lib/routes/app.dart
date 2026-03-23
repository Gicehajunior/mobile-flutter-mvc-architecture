import 'package:mvcflutter/config/app_router.dart'; 
import 'package:mvcflutter/config/app_request.dart';
import 'package:mvcflutter/app/controllers/mobile/home_controller.dart';
import 'package:mvcflutter/app/controllers/auth/auth_controller.dart';

final appRouter = AppRouter()
  ..route('/', 'home', (request) => HomeController().homeView()) 
  ..route('/login', 'login', (request) => AuthController().loginView())
  ..route('/forgot-password', 'forgotPassword', (request) => AuthController().forgotPassView());