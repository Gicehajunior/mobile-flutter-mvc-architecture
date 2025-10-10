import 'package:mvcflutter/config/routes/app_router.dart';
import 'package:mvcflutter/presentation/screens/home/home_screen.dart';
import 'package:mvcflutter/presentation/screens/auth/login_screen.dart';

final appRouter = AppRouter()
  ..route('/', 'home', const HomeScreen())
  ..route('/login', 'login', const LoginScreen());
