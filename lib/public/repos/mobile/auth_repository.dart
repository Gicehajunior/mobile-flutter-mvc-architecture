import 'package:mvcflutter/public/repos/global/Repository.dart';

class  AuthRepository extends Repository {
    Future<void> authLogin({required String email, required String password}) async {
        print("Login in Progress..."); 
    }
}