import 'package:beacon_flutter/views/leader/location_leader_view.dart';
import 'package:beacon_flutter/views/traveller/location_traveller_view.dart';
import 'package:flutter/material.dart';
import 'login_view.dart';

class CustomRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case LoginView.id:
        return MaterialPageRoute(builder: (_) => LoginView());
      case LocationLeaderView.id:
        return MaterialPageRoute(builder: (_) => LocationLeaderView());
      case LocationTravellerView.id:
        return MaterialPageRoute(builder: (_) => LocationTravellerView());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
