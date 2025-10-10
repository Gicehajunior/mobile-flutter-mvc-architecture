import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutterfeatures/routes/web_routes.dart';

final routerProvider = Provider((ref) {
  return appRouter.build(initialLocation: '/');
});
