import 'package:nexus/config/controller.dart';
import 'package:nexus/config/app_request.dart';
import 'package:nexus/config/view_request.dart';

class HomeController extends CI { 
    ViewRequest homeView(Request request) { 
        final String target = request.input('id') ?? 
                request.input('categoryName') ?? ''; // Must be passed on the route as param(s)
        
        final Map<String, dynamic> uiDataToRender = {'data': {}}; // filter out data using the target param key

        return ViewRequest(
            'home/home_screen', 
            data: {
                'uiData': uiDataToRender,
                'targetKey': target, 
            }
        );
    }
    
}
