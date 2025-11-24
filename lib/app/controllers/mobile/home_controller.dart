import 'package:mvcflutter/config/controller.dart';
import 'package:mvcflutter/config/view_request.dart';

class HomeController extends CI { 
    ViewRequest homeView() {
        print('HomeController: preparing home screen...');
        return ViewRequest('home/home_screen');
    }

    Map<String, dynamic> apiTest() {
        return {"status": "ok", "time": DateTime.now().toString()};
    }
}
