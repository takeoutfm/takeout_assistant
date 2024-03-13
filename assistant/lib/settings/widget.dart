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
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              _switchTile(Icons.access_time, '24-hour Clock', '',
                  state.settings.use24HourClock, (value) {
                context.assistantSettings.use24HourClock = value;
              }),
            ])),
            Card(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              _switchTile(Icons.play_arrow, 'Display Player', '',
                  state.settings.showPlayer, (value) {
                context.assistantSettings.showPlayer = value;
              }),
            ])),
            Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
              ],
            )),
            Card(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
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
                ListTile(
                  leading: const Icon(Icons.mic),
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
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.key),
                  title: Text('ListenBrainz Token'),
                  subtitle: _TokenField(
                    initialValue:
                        context.settings.state.settings.listenBrainzToken,
                    onChanged: (value) {
                      context.settings.listenBrainzToken = value;
                    },
                  ),
                  trailing: Switch(
                    value: context.settings.state.settings.enableListenBrainz,
                    onChanged: (value) {
                      context.settings.enabledListenBrainz = value;
                    },
                  ),
                ),
              ],
            )),
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

  const _TextField({this.initialValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      initialValue: initialValue,
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
