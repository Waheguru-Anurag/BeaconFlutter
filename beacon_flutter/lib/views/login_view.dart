import 'package:beacon_flutter/enums/view_state.dart';
import 'package:beacon_flutter/viewmodels/login_viewmodel.dart';
import 'package:beacon_flutter/views/traveller/location_traveller_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:uuid/uuid.dart';

import 'base_view.dart';
import 'leader/location_leader_view.dart';

class LoginView extends StatefulWidget {
  static const String id = 'login_view_id';
  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  TextEditingController _usernameController, _passwordController;
  String _usernameKey, _passwordKey;
  bool _passwordInvalid;

  final _errorStyle =
      TextStyle(color: Colors.red, fontSize: ScreenUtil().setHeight(16));

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordKey = '';
    _usernameKey = '';
    _passwordInvalid = false;
  }

  Future<void> _firestoreLogin(LoginViewModel model) async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(_usernameKey)
        .get();
    var document = documentSnapshot.data();
    if (document != null && _passwordKey == document['password']) {
      model.setIsLoggedIn();
      model.setTraveller(document['is_traveller']);
      model.setPassKey(document['id']);
      model.setUsername(_usernameKey);
      _passwordInvalid = false;
    } else {
      setState(() {
        _passwordInvalid = true;
      });
    }
  }

  Future<void> _firestoreRegister(LoginViewModel model) async {
    Map<String, dynamic> map = Map();
    var uuid = Uuid();
    String id = uuid.v4();
    map['password'] = _passwordKey;
    map['pass_key'] = id;
    map['is_traveller'] = true;
    model.setIsLoggedIn();
    model.setPassKey(id.substring(0, 8));
    model.setTraveller(true);
    model.setUsername(_usernameKey);
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(_usernameKey)
        .set(map);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      builder: (context, model, child) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            'Beacon Flutter',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: SafeArea(
          child: model.state == ViewState.Busy
              ? Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(
                          value: null,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ]),
                )
              : Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: _passwordInvalid
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(20),
                                    ScreenUtil().setHeight(0),
                                    ScreenUtil().setWidth(20),
                                    0),
                                child: TextFormField(
                                  controller: _usernameController,
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
                                      labelText: 'Username'),
                                  onTap: (){
                                    setState(() {
                                      _passwordInvalid = false;
                                    });
                                  },
                                  onFieldSubmitted: (_) {
                                    setState(() {
                                      _usernameKey = _usernameController.text;
                                      _passwordInvalid = false;
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                  onEditingComplete: () {
                                    setState(() {
                                      _usernameKey = _usernameController.text;
                                      _passwordInvalid = false;
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(20),
                                    ScreenUtil().setHeight(0),
                                    ScreenUtil().setWidth(20),
                                    0),
                                child: TextFormField(
                                  controller: _passwordController,
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
                                      labelText: 'Password'),
                                  onTap: (){
                                    _passwordInvalid = false;
                                  },
                                  onFieldSubmitted: (_) {
                                    setState(() {
                                      _usernameKey = _usernameController.text;
                                      _passwordKey = _passwordController.text;
                                      _passwordInvalid = false;
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                  onEditingComplete: () {
                                    setState(() {
                                      _usernameKey = _usernameController.text;
                                      _passwordKey = _passwordController.text;
                                      _passwordInvalid = false;
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setWidth(20),
                              ),
                              Text(
                                'Invalid Credentials!',
                                textAlign: TextAlign.center,
                                style: _errorStyle,
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
                                            await _firestoreLogin(model);
                                            if(!_passwordInvalid) {
                                              model.setStateBusy();
                                              if (model.getTraveller() ==
                                                  true) {
                                                model.navigate(
                                                    LocationTravellerView.id);
                                              } else {
                                                model.navigate(
                                                    LocationLeaderView.id);
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(0),
                                                ScreenUtil().setHeight(8),
                                                ScreenUtil().setWidth(0),
                                                ScreenUtil().setHeight(8)),
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil().setSp(
                                                      20,
                                                      allowFontScalingSelf:
                                                          true)),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    Expanded(
                                      child: FlatButton(
                                          color: Theme.of(context).primaryColor,
                                          onPressed: () async {
                                            await _firestoreRegister(model);
                                            if(!_passwordInvalid) {
                                              model.setStateBusy();
                                              if (model.getTraveller() ==
                                                  true) {
                                                model.navigate(
                                                    LocationTravellerView.id);
                                              } else {
                                                model.navigate(
                                                    LocationLeaderView.id);
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(0),
                                                ScreenUtil().setHeight(8),
                                                ScreenUtil().setWidth(0),
                                                ScreenUtil().setHeight(8)),
                                            child: Text(
                                              'Register',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil().setSp(
                                                      20,
                                                      allowFontScalingSelf:
                                                          true)),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      ScreenUtil().setWidth(20),
                                      ScreenUtil().setHeight(0),
                                      ScreenUtil().setWidth(20),
                                      0),
                                  child: TextFormField(
                                    controller: _usernameController,
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
                                        labelText: 'Username'),
                                    onTap: (){
                                      setState(() {
                                        _passwordInvalid = false;
                                      });
                                    },
                                    onFieldSubmitted: (_) {
                                      setState(() {
                                        _usernameKey = _usernameController.text;
                                        _passwordInvalid = false;
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                    onEditingComplete: () {
                                      setState(() {
                                        _usernameKey = _usernameController.text;
                                        _passwordInvalid = false;
                                      });
                                      FocusScope.of(context).unfocus();
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: ScreenUtil().setHeight(20),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    ScreenUtil().setWidth(20),
                                    ScreenUtil().setHeight(0),
                                    ScreenUtil().setWidth(20),
                                    0),
                                child: TextFormField(
                                  controller: _passwordController,
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
                                      labelText: 'Password'),
                                  onTap: (){
                                    setState(() {
                                      _passwordInvalid = false;
                                    });
                                  },
                                  onFieldSubmitted: (_) {
                                    setState(() {
                                      _passwordInvalid = false;
                                      _usernameKey = _usernameController.text;
                                      _passwordKey = _passwordController.text;
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                  onEditingComplete: () {
                                    setState(() {
                                      _passwordInvalid = false;
                                      _usernameKey = _usernameController.text;
                                      _passwordKey = _passwordController.text;
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
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
                                            await _firestoreLogin(model);
                                            if(!_passwordInvalid) {
                                              model.setStateBusy();
                                              if (model.getTraveller() ==
                                                  true) {
                                                model.navigate(
                                                    LocationTravellerView.id);
                                              } else {
                                                model.navigate(
                                                    LocationLeaderView.id);
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(0),
                                                ScreenUtil().setHeight(8),
                                                ScreenUtil().setWidth(0),
                                                ScreenUtil().setHeight(8)),
                                            child: Text(
                                              'Login',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil().setSp(
                                                      20,
                                                      allowFontScalingSelf:
                                                          true)),
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
                                            await _firestoreRegister(model);
                                            if(!_passwordInvalid) {
                                              model.setStateBusy();
                                              if (model.getTraveller() ==
                                                  true) {
                                                model.navigate(
                                                    LocationTravellerView.id);
                                              } else {
                                                model.navigate(
                                                    LocationLeaderView.id);
                                              }
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                ScreenUtil().setWidth(0),
                                                ScreenUtil().setHeight(8),
                                                ScreenUtil().setWidth(0),
                                                ScreenUtil().setHeight(8)),
                                            child: Text(
                                              'Register',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil().setSp(
                                                      20,
                                                      allowFontScalingSelf:
                                                          true)),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
        ),
      ),
    );
  }
}
