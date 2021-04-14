import 'package:beacon_flutter/viewmodels/startup_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'base_view.dart';

class StartUpView extends StatefulWidget {
  @override
  StartUpViewState createState() => StartUpViewState();
}

class StartUpViewState extends State<StartUpView> {
  @override
  Widget build(BuildContext context) {
    return BaseView<StartUpViewModel>(
      onModelReady: (model) {
        model.onModelReady();
      },
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Center(
                child: Text(
              'Beacon App',
              style: TextStyle(
                  fontSize: ScreenUtil().setSp(24, allowFontScalingSelf: true)),
            )),
          )),
    );
  }
}
