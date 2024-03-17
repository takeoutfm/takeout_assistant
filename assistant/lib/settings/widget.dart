// Copyright 2024 defsub
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

import 'package:assistant/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistant/app/context.dart';
import 'package:assistant/home/home.dart';
import 'package:takeout_lib/settings/settings.dart';

import 'model.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final homeState = context.watch<HomeCubit>().state;
    return BlocBuilder<AssistantSettingsCubit, AssistantSettingsState>(
        builder: (context, state) {
      return Scaffold(
          appBar: AppBar(title: Text('Settings')),
          body: SingleChildScrollView(
              child: Column(children: [
            Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _switchTile(Icons.access_time, '24-hour Clock', '',
                    state.settings.use24HourClock, (value) {
                  context.assistantSettings.use24HourClock = value;
                }),
                _switchTile(Icons.play_arrow, 'Display Player', '',
                    state.settings.showPlayer, (value) {
                  context.assistantSettings.showPlayer = value;
                }),
                ListTile(
                  leading: const Icon(Icons.settings_display),
                  title: Text('Clock Display'),
                  trailing: _Dropdown(
                    DisplayType.values.map((e) => e.name).toList(),
                    selected: state.settings.displayType.name,
                    onChanged: (value) {
                      if (value != null) {
                        DisplayType.values.forEach((e) {
                          if (e.name == value) {
                            context.assistantSettings.displayType = e;
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            )),
            Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FutureBuilder(
                    future: context.home.repository.authRequired(),
                    builder: (context, snapshot) {
                      final authRequired = snapshot.data;
                      if (authRequired == true) {
                        return ListTile(
                          leading: const Icon(Icons.control_point),
                          title: Text('Hue Bridge'),
                          subtitle: _TextField(
                            hintText: 'Enter IP address or refresh',
                            initialValue: state.settings.bridgeAddress,
                            onChanged: (value) {
                              value = value.trim();
                              context.assistantSettings.bridgeAddress = value;
                              if (value.isNotEmpty) {
                                context.home.discover();
                              }
                            },
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () => context.home.discover(),
                          ),
                        );
                      } else if (authRequired == false) {
                        return ListTile(
                          leading: const Icon(Icons.control_point),
                          title: Text('Hue Bridge Found'),
                          subtitle: Text('Refresh to discover new devices'),
                          trailing: IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () => context.home.refresh(),
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    }),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: Text('Home Room'),
                  subtitle: Text('Default room in home'),
                  trailing: _Dropdown(
                    homeState.rooms,
                    selected: state.settings.homeRoom,
                    onChanged: (value) {
                      if (value != null) {
                        context.assistantSettings.homeRoom = value;
                      }
                    },
                  ),
                ),
                _switchTile(
                    Icons.music_note,
                    'Enable Music Zone',
                    'Set light color from album covers',
                    state.settings.enableMusicZone, (value) {
                  context.assistantSettings.enableMusicZone = value;
                }),
                ListTile(
                  leading: const Icon(Icons.lightbulb),
                  title: Text('Music Zone'),
                  subtitle: Text('Hue zone name for lights'),
                  trailing: _Dropdown(
                    homeState.zones,
                    selected: state.settings.musicZone,
                    onChanged: (value) {
                      if (value != null) {
                        context.assistantSettings.musicZone = value;
                      }
                    },
                  ),
                ),
              ],
            )),
            Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _switchTile(
                    state.settings.enableSpeechRecognition
                        ? Icons.mic
                        : Icons.mic_off,
                    'Speech Recognition',
                    '',
                    state.settings.enableSpeechRecognition,
                    (value) => context
                        .assistantSettings.enableSpeechRecognition = value),
                ListTile(
                  leading: const Icon(Icons.settings_voice),
                  title: Text('Wake Words'),
                  subtitle: _TextField(
                    initialValue: state.settings.wakeWords.join(' '),
                    onChanged: (value) {
                      context.assistantSettings.wakeWords =
                          value.split(RegExp(r'\s*,\s*'));
                    },
                  ),
                  trailing: Switch(
                    value: state.settings.enableWakeWords,
                    onChanged: (value) {
                      context.assistantSettings.enableWakeWords = value;
                    },
                  ),
                ),
              ],
            )),
            Card(
                child: BlocBuilder<SettingsCubit, SettingsState>(
                    builder: (context, settingsState) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: const Icon(Icons.key),
                              title: Text('ListenBrainz Token'),
                              subtitle: _TokenField(
                                initialValue:
                                    settingsState.settings.listenBrainzToken,
                                onChanged: (value) {
                                  context.settings.listenBrainzToken = value;
                                },
                              ),
                              trailing: Switch(
                                value:
                                    settingsState.settings.enableListenBrainz,
                                onChanged: (value) {
                                  context.settings.enabledListenBrainz = value;
                                },
                              ),
                            ),
                            ListTile(
                              leading: const Icon(Icons.cloud_outlined),
                              title: Text('Takeout Host'),
                              subtitle: _TextField(
                                initialValue: settingsState.settings.host,
                                readOnly: context.app.state.authenticated,
                                onChanged: (value) {
                                  context.settings.host = value.trim();
                                },
                              ),
                            ),
                          ],
                        ))),
          ])));
    });
  }

  Widget _switchTile(IconData icon, String title, String subtitle, bool value,
      ValueChanged<bool> onChanged) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
      trailing: Switch(value: value, onChanged: onChanged),
    );
  }
}

class _Dropdown extends StatelessWidget {
  final List<String> options;
  final void Function(String?)? onChanged;
  final String? selected;

  _Dropdown(this.options, {this.onChanged, this.selected});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
        onChanged: onChanged,
        value: selected,
        items: options
            .map<DropdownMenuItem<String>>(
                (e) => DropdownMenuItem<String>(value: e, child: Text(e)))
            .toList());
  }
}

class _TextField extends StatelessWidget {
  final String? initialValue;
  final void Function(String) onChanged;
  final bool readOnly;
  final String? hintText;

  const _TextField(
      {this.initialValue,
      required this.onChanged,
      this.readOnly = false,
      this.hintText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: initialValue,
      readOnly: readOnly,
      decoration: hintText != null ? InputDecoration(hintText: hintText) : null,
    );
  }
}

class _TokenField extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onChanged;

  const _TokenField({this.initialValue, required this.onChanged});

  @override
  State createState() => _TokenFieldState();
}

class _TokenFieldState extends State<_TokenField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      onTap: () {
        setState(() {
          _obscureText = false;
        });
      },
      onTapOutside: (_) {
        setState(() {
          _obscureText = true;
        });
      },
      onChanged: widget.onChanged,
      initialValue: widget.initialValue,
      // decoration: const InputDecoration(
      //   border: OutlineInputBorder(),
      // ),
    );
  }
}
