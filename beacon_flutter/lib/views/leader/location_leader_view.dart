import 'dart:async';

import 'package:beacon_flutter/viewmodels/leader/location_leader_viewmodel.dart';
import 'package:beacon_flutter/viewmodels/traveller/location_traveller_viewmodel.dart';
import 'package:beacon_flutter/views/base_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:geolocator/geolocator.dart';

class LocationLeaderView extends StatefulWidget {
  static const String id = 'location_leader_view_id';

  @override
  LocationTravellerViewState createState() => LocationTravellerViewState();
}

class LocationTravellerViewState extends State<LocationLeaderView> {
  StreamSubscription<Position> positionStream;
  String latitude, longitude;

  @override
  void initState() {
    super.initState();
    latitude = '';
    longitude = '';
  }

  @override
  void dispose() {
    super.dispose();
    positionStream.cancel();
  }

  Future<void> _updateFirestore(
      Position position, LocationLeaderViewModel model) async {
    Map<String, dynamic> map = Map();
    map['latitude'] = position.latitude.toString();
    map['longitude'] = position.longitude.toString();
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(model.getUsername())
        .update(map);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LocationLeaderViewModel>(
        onModelReady: (model) {
          positionStream = Geolocator.getPositionStream(
                  desiredAccuracy: LocationAccuracy.high)
              .listen((Position position) {
            _updateFirestore(position, model);
          });
        },
        builder: (context, model, child) => Scaffold(
              body: SafeArea(
                  child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Latitude    ${latitude}',
                        style: TextStyle(
                            fontSize: ScreenUtil()
                                .setSp(15, allowFontScalingSelf: true)),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Text(
                        'Longitude    ${longitude}',
                        style: TextStyle(
                            fontSize: ScreenUtil()
                                .setSp(15, allowFontScalingSelf: true)),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(60),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(20),
                            ScreenUtil().setHeight(0),
                            ScreenUtil().setWidth(20),
                            0),
                        child: Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () async {
                                    positionStream.resume();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(8),
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(8)),
                                    child: Text(
                                      'Enable',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(20,
                                              allowFontScalingSelf: true)),
                                    ),
                                  )),
                            ),
                            SizedBox(
                              width: ScreenUtil().setWidth(20),
                            ),
                            Expanded(
                              child: FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  onPressed: () async {
                                    positionStream.pause();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(8),
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(8)),
                                    child: Text(
                                      'Disable',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(20,
                                              allowFontScalingSelf: true)),
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ));
  }
}
