// Copyright 2023 defsub
//
// This file is part of TakeoutFM.
//
// TakeoutFM is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
//
// TakeoutFM is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for
// more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with TakeoutFM.  If not, see <https://www.gnu.org/licenses/>.

import 'package:assistant/app/app.dart';
import 'package:assistant/app/bloc.dart';
import 'package:assistant/app/context.dart';
import 'package:assistant/home/widget.dart';
import 'package:assistant/settings/settings.dart';
import 'package:assistant/settings/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:takeout_lib/context/bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'connect.dart';
import 'player.dart';

Future ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await TakeoutBloc.initStorage();
}

void main() async {
  await ensureInitialized();
  runApp(const AssistantApp());
}

class AssistantApp extends StatefulWidget {
  const AssistantApp({super.key});

  @override
  AssistantAppState createState() => AssistantAppState();
}

class AssistantAppState extends State<AssistantApp> {
  bool _configButtonShown = false;

  @override
  Widget build(BuildContext context) {
    return AppBloc().init(context,
        child: MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
            ],
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            home: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _configButtonShown = !_configButtonShown;
                          });
                        },
                        child: Stack(children: [
                          AssistantDisplay(),
                          if (_configButtonShown)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Opacity(
                                opacity: 0.7,
                                child: _configButton(),
                              ),
                            ),
                        ]))))));
  }

  Widget _configButton() {
    return Builder(
      builder: (BuildContext context) {
        final state = context.watch<AppCubit>().state;
        return PopupMenuButton(
          icon: Icon(Icons.more_vert),
          itemBuilder: (_) {
            return <PopupMenuEntry<dynamic>>[
              PopupMenuItem(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (_) => SettingsWidget())),
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(context.strings.settingsLabel),
                  )),
              PopupMenuItem(
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute<void>(builder: (_) => LightsWidget())),
                  child: ListTile(
                    leading: Icon(Icons.lightbulb),
                    title: Text(context.strings.lights),
                  )),
              if (state.authenticated == true)
                PopupMenuItem(
                    onTap: () => context.logout(),
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(context.strings.logoutLabel),
                    )),
              if (state.authenticated == false)
                PopupMenuItem(
                    onTap: () => showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(child: ConnectPage());
                        }),
                    child: ListTile(
                      leading: Icon(Icons.login),
                      title: Text(context.strings.loginLabel),
                    )),
              PopupMenuDivider(),
              PopupMenuItem(
                  onTap: () => showAboutDialog(
                          context: context,
                          applicationName: appName,
                          applicationVersion: appVersion,
                          applicationLegalese:
                              'Copyleft \u00a9 2023-2024 defsub',
                          children: <Widget>[
                            InkWell(
                                child: const Text(
                                  appSource,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blueAccent),
                                ),
                                onTap: () => launchUrl(Uri.parse(appSource))),
                            InkWell(
                                child: const Text(
                                  appHome,
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.blueAccent),
                                ),
                                onTap: () => launchUrl(Uri.parse(appHome))),
                          ]),
                  child: ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text(context.strings.aboutLabel),
                  )),
            ];
          },
        );
      },
    );
  }
}

class AssistantDisplay extends StatefulWidget {
  const AssistantDisplay({super.key});

  @override
  AssistantDisplayState createState() => AssistantDisplayState();
}

class AssistantDisplayState extends State<AssistantDisplay> with AppBlocState {
  @override
  void initState() {
    super.initState();
    appInitState(context);

    // final settings = context.settings.state.settings;
    // if (settings.host == 'https://example.com') {
    //   // TODO need UI to enter host
    //   context.settings.host = 'https://takeout.fm';
    // }
  }

  @override
  void dispose() {
    appDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WakelockPlus.enable(); // consider settings
    final state = context.watch<AssistantSettingsCubit>().state;
    return context.clock.build(
          context,
          child: state.settings.showPlayer ? PlayerWidget() : null,
        ) ??
        SizedBox.shrink();
  }
}
