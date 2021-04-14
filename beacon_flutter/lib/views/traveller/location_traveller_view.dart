import 'dart:async';
import 'package:beacon_flutter/viewmodels/traveller/location_traveller_viewmodel.dart';
import 'package:beacon_flutter/views/base_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';

class LocationTravellerView extends StatefulWidget {
  static const String id = 'location_traveller_view_id';

  @override
  LocationTravellerViewState createState() => LocationTravellerViewState();
}

class LocationTravellerViewState extends State<LocationTravellerView> {
  TextEditingController _controller = TextEditingController();
  StreamSubscription<QuerySnapshot> _streamSubscription;
  String latitude, longitude;
  String _passKey;

  @override
  void initState() {
    super.initState();
    latitude = '';
    longitude = '';
    _passKey = '';
  }

  void subscribe() {
    _streamSubscription = FirebaseFirestore.instance
        .collection('Users')
        .get()
        .asStream()
        .listen((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.data()['pass_key'] == _passKey) {
          setState(() {
            latitude = doc.data()['latitude'];
            longitude = doc.data()['longitude'];
          });
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LocationTravellerViewModel>(
        builder: (context, model, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                  child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            ScreenUtil().setWidth(20),
                            ScreenUtil().setHeight(0),
                            ScreenUtil().setWidth(20),
                            0),
                        child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Color.fromRGBO(0, 0, 0, 0.4),
                                  width: ScreenUtil().setWidth(1),
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: ScreenUtil().setWidth(1),
                                )),
                                labelText: 'Pass Key'),
                            onFieldSubmitted: (_) {
                              FocusScope.of(context).unfocus();
                            },
                            onEditingComplete: () {
                              FocusScope.of(context).unfocus();
                            }),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(30),
                      ),
                      Text(
                        'Latitude    $latitude',
                        style: TextStyle(
                            fontSize: ScreenUtil()
                                .setSp(15, allowFontScalingSelf: true)),
                      ),
                      SizedBox(
                        height: ScreenUtil().setHeight(10),
                      ),
                      Text(
                        'Longitude    $longitude',
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
                                    setState(() {
                                      _passKey = _controller.text;
                                    });
                                    subscribe();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(8),
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(8)),
                                    child: Text(
                                      'Search',
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
                                    setState(() {
                                      latitude = '';
                                      longitude = '';
                                      _passKey = '';
                                      _controller.text = '';
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(8),
                                        ScreenUtil().setWidth(0),
                                        ScreenUtil().setHeight(8)),
                                    child: Text(
                                      'Clear',
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
