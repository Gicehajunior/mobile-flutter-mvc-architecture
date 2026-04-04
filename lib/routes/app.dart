import 'package:nexus/config/app_router.dart';  
import 'package:nexus/app/controllers/mobile/home_controller.dart';
import 'package:nexus/app/controllers/auth/auth_controller.dart';

final appRouter = AppRouter()
  ..route('/', 'home', (request) => HomeController().homeView(request)) 
  ..route('/login', 'login', (request) => AuthController().loginView())
  ..route('/forgot-password', 'forgotPassword', (request) => AuthController().forgotPassView());