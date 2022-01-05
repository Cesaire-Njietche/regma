import 'package:get_it/get_it.dart';

import '../providers/auth_service_provider.dart';
import '../services/file.dart';
import '../services/regma_services.dart';

GetIt instance = GetIt.I;

void setUpDependency() {
  instance.registerLazySingleton(() => RegmaServices());
  instance.registerLazySingleton(() => MFile());
  instance.registerFactory(() => AuthServiceProvider());
}
