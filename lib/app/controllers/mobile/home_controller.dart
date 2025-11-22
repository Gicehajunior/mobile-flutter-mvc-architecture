import 'package:mvcflutter/config/controller.dart';
import 'package:mvcflutter/config/view_request.dart';

class HomeController extends CI { 
    MVCFRequest homeView() {
        print('HomeController: preparing home screen...');
        return MVCFRequest('home/home_screen');
    }

    Map<String, dynamic> apiTest() {
        return {"status": "ok", "time": DateTime.now().toString()};
    }
}
