import 'package:arnaldo/core/database_helper.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'features/home/home_module.dart';

class AppModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(DatabaseHelper.new);
  }

  @override
  void routes(r) {
    r.module('/', module: HomeModule());
  }
}
