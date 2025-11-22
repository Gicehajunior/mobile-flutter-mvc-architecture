import 'package:mvcflutter/config/view_request.dart';

class HomeController {
    const HomeController();

    MVCFRequest homeView() {
        print('HomeController: preparing home screen...');
        return MVCFRequest('home/home_screen');
    }
}
