// Copyright 2023 defsub
//
// This file is part of Takeout.
//
// Takeout is free software: you can redistribute it and/or modify it under the
// terms of the GNU Affero General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
//
// Takeout is distributed in the hope that it will be useful, but WITHOUT ANY
// WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
// FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for
// more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with Takeout.  If not, see <https://www.gnu.org/licenses/>.

import 'package:assistant/app/app.dart';
import 'package:assistant/app/bloc.dart';
import 'package:assistant/app/context.dart';
import 'package:assistant/home/widget.dart';
import 'package:assistant/settings/model.dart';
import 'package:assistant/settings/settings.dart';
import 'package:assistant/settings/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_clock/one_clock.dart';
import 'package:takeout_lib/art/cover.dart';
import 'package:takeout_lib/player/player.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'connect.dart';

Future ensureInitialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await AppBloc.initStorage();
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
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => SettingsWidget()));
                  },
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                  )),
              PopupMenuItem(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                            builder: (_) => LightsWidget()));
                  },
                  child: ListTile(
                    leading: Icon(Icons.lightbulb),
                    title: Text('Lights'),
                  )),
              if (state.authenticated == true)
                PopupMenuItem(
                    onTap: () {
                      context.logout();
                    },
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Logout'),
                    )),
              if (state.authenticated == false)
                PopupMenuItem(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return Dialog(child: ConnectPage());
                          });
                    },
                    child: ListTile(
                      leading: Icon(Icons.login),
                      title: Text('Login'),
                    )),
              PopupMenuDivider(),
              PopupMenuItem(
                  onTap: () {
                    showAboutDialog(
                        context: context,
                        applicationName: 'Takeout Assistant',
                        applicationVersion: appVersion,
                        applicationLegalese: 'Copyleft \u00a9 2023-2024 defsub',
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
                        ]);
                  },
                  child: ListTile(
                    leading: Icon(Icons.info_outline),
                    title: Text('About'),
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

    final settings = context.settings.state.settings;
    if (settings.host == 'https://example.com') {
      // TODO need UI to enter host
      context.settings.host = 'https://takeout.fm';
    }
  }

  @override
  void dispose() {
    appDispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      final state = context.watch<AssistantSettingsCubit>().state;
      WakelockPlus.disable();
      switch (state.settings.displayType) {
        case DisplayType.clock:
          WakelockPlus.enable();
          return context.clock.repository.build(context);
        case DisplayType.basic:
          // final Brightness brightness = MediaQuery.platformBrightnessOf(context);
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.shrink(),
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DigitalClock(
                      digitalClockTextColor: Colors.white70,
                      format: state.settings.use24HourClock ? 'HH:mm' : 'h:mm',
                      textScaleFactor:
                          orientation == Orientation.landscape ? 8 : 5,
                      isLive: true,
                    ),
                    DigitalClock(
                      digitalClockTextColor: Colors.white30,
                      format: 'EEE, MMM d',
                      textScaleFactor: 2,
                      isLive: true,
                    )
                  ]),
              if (state.settings.showPlayer)
                PlayerWidget()
              else
                SizedBox.shrink(),
            ],
          ));
      }
    });
  }
}

class PlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<Player>().state;
    final appState = context.watch<AppCubit>().state;
    if (state is PlayerInit || state is PlayerReady || state is PlayerStop) {
      return const SizedBox.shrink();
    }
    final title = state.currentTrack?.title ?? '';
    final creator = state.currentTrack?.creator ?? '';
    final image = state.currentTrack?.image ?? '';
    final double? progress =
        state is PlayerPositionState ? state.progress : null;
    if (state is PlayerProcessingState) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Ink(
            color: appState.backgroundColor,
            child: ListTile(
                leading: image.isNotEmpty ? tileCover(context, image) : null,
                title: title.isNotEmpty ? Text(title) : null,
                subtitle: creator.isNotEmpty ? Text(creator) : null,
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                      icon: state.playing
                          ? Icon(Icons.pause)
                          : Icon(Icons.play_arrow),
                      onPressed: () {
                        if (state.playing) {
                          context.player.pause();
                        } else {
                          context.player.play();
                        }
                      }),
                  IconButton(
                      icon: Icon(Icons.skip_next),
                      onPressed: state.hasNext
                          ? () => context.player.skipToNext()
                          : null),
                ]))),
        LinearProgressIndicator(value: progress),
      ]);
    }
    return SizedBox.shrink();
  }
}
