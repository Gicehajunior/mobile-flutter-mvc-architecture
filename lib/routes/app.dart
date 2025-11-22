import 'package:mvcflutter/config/app_router.dart';
import 'package:mvcflutter/app/controllers/mobile/home_controller.dart';
import 'package:mvcflutter/app/controllers/auth/auth_controller.dart';

final appRouter = AppRouter()
  ..route('/', 'home', () => HomeController().homeView())
  ..route("/api", "api", () => HomeController().apiTest())
  ..route('/login', 'login', () => AuthController().loginView());