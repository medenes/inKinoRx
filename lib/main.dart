import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inkinoRx/app/main_page.dart';
import 'package:inkinoRx/data/loading_status.dart';
import 'package:inkinoRx/managers/app_manager.dart';
import 'package:inkinoRx/service_locator.dart';
import 'package:inkinoRx/widgets/common/info_message_view.dart';
import 'package:inkinoRx/widgets/common/loading_view.dart';
import 'package:inkinoRx/widgets/common/platform_adaptive_progress_indicator.dart';

Future<Null> main() async {

  setUpServiceLocator(rootBundle);

  runApp(new InKinoAppSFull());
}

class InKinoAppSFull extends StatefulWidget {

  @override
  _InKinoAppState createState() => new _InKinoAppState();
}


class _InKinoAppState extends State<InKinoAppSFull> {

  LoadingStatus _status = LoadingStatus.loading;

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'inKino MVVM RX',
      debugShowCheckedModeBanner: false,
      theme:  ThemeData(
        primaryColor: Color(0xFF1C306D),
        accentColor:  Color(0xFFFFAD32),
      ),

      home: LoadingView(
        status: _status,
        loadingContent: new PlatformAdaptiveProgressIndicator(),
        errorContent: new ErrorView(
          description: 'Error loading events.',
          //ToDO why pass the date that is a member of AppManager?
          onRetry: () => {},
        ),
        successContent:  MainPage(),
      ),
    );
  }

  @override
  void initState() {
    sl.get<AppManager>()
        .init()
        .then( (value) {
          print("main.initState OK");
          this.setState( () { _status = LoadingStatus.success;} );
        })
        .catchError((error)  => print('main.initState ERROR $error'))
        .whenComplete(() =>  print("main.initState COMPLETE"));

    super.initState();
  }

}