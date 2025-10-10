import 'package:mvcflutterconfig/routes/app_router.dart';
import 'package:mvcflutterpresentation/screens/home/home_screen.dart';
import 'package:mvcflutterpresentation/screens/auth/login_screen.dart';

final appRouter = AppRouter()
  ..route('/', 'home', const HomeScreen())
  ..route('/login', 'login', const LoginScreen());
