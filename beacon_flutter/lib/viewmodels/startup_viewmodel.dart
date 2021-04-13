import 'package:beacon_flutter/locator.dart';
import 'package:beacon_flutter/services/local_storage.dart';
import 'package:beacon_flutter/services/navigation_service.dart';
import 'package:beacon_flutter/views/leader/location_leader_view.dart';
import 'package:beacon_flutter/views/login_view.dart';
import 'package:beacon_flutter/views/traveller/location_traveller_view.dart';

import 'base_viewmodel.dart';

class StartUpViewModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  Future<void> onModelReady() async {
    await Future.delayed(Duration(seconds: 2));
    return !_localStorageService.isLoggedIn
        ? _navigationService.pushNamedAndRemoveUntil(LoginView.id)
        : _localStorageService.isTraveller
            ? _navigationService
                .pushNamedAndRemoveUntil(LocationTravellerView.id)
            : _navigationService.pushNamedAndRemoveUntil(LocationLeaderView.id);
  }
}
