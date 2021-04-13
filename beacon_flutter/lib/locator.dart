import 'package:beacon_flutter/services/local_storage.dart';
import 'package:beacon_flutter/services/navigation_service.dart';
import 'package:beacon_flutter/viewmodels/leader/location_leader_viewmodel.dart';
import 'package:beacon_flutter/viewmodels/login_viewmodel.dart';
import 'package:beacon_flutter/viewmodels/startup_viewmodel.dart';
import 'package:beacon_flutter/viewmodels/traveller/location_traveller_viewmodel.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setUpLocator() async {
  locator.registerLazySingleton(() => NavigationService());

  var localStorageService = await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(localStorageService);

  locator.registerFactory(() => StartUpViewModel());
  locator.registerFactory(() => LoginViewModel());
  locator.registerFactory(() => LocationLeaderViewModel());
  locator.registerFactory(() => LocationTravellerViewModel());
}
