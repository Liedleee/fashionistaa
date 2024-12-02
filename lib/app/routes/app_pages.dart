import '../modules/home/views/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.home;

  static final routes = {
    AppRoutes.home: (context) => HomeView(),
  };
}
