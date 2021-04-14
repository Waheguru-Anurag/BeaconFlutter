import 'package:beacon_flutter/enums/view_state.dart';
import 'package:beacon_flutter/services/local_storage.dart';
import 'package:beacon_flutter/services/navigation_service.dart';
import 'package:beacon_flutter/viewmodels/base_viewmodel.dart';
import 'package:beacon_flutter/locator.dart';

class LoginViewModel extends BaseViewModel {
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  final NavigationService _navigationService = locator<NavigationService>();

  void navigate(String id) {
    _navigationService.pushNamedAndRemoveUntil(id);
  }

  void setPassKey(String key) {
    _localStorageService.userPassKey = key;
  }

  void setIsLoggedIn() {
    _localStorageService.isLoggedIn = true;
  }

  void setTraveller(bool isTraveller) {
    _localStorageService.isTraveller = isTraveller;
  }

  bool getTraveller() {
    return _localStorageService.isTraveller;
  }

  void setStateBusy() {
    setState(ViewState.Busy);
  }

  void setUsername(String username) {
    _localStorageService.username = username;
  }
}
