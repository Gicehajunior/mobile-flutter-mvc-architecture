import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/features/routes/web_routes.dart';

final routerProvider = Provider((ref) {
  return appRouter.build(initialLocation: '/');
});
