import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mvcflutter/routes/app.dart';

final routerProvider = Provider((ref) {
  return appRouter.build(initialLocation: '/');
});
