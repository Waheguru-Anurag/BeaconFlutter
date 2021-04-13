import 'package:beacon_flutter/locator.dart';
import 'package:beacon_flutter/services/local_storage.dart';
import 'package:beacon_flutter/services/navigation_service.dart';
import 'package:beacon_flutter/viewmodels/base_viewmodel.dart';

class LocationTravellerViewModel extends BaseViewModel {
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void navigate(String id) {
    _navigationService.pushNamedAndRemoveUntil(id);
  }

  String getUsername() {
    return _localStorageService.username;
  }
}
