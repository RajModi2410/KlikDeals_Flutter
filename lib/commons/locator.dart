

import 'package:get_it/get_it.dart';
import 'package:vendor/commons/NavigationService.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
}