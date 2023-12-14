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

import 'package:assistant/context/bloc.dart';
import 'package:assistant/context/context.dart';
import 'package:assistant/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await AppBloc.initStorage();
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
            home: Scaffold(
                resizeToAvoidBottomInset: false,
                endDrawer: ConfigDrawer(),
                body: SafeArea(
                    child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          setState(() {
                            _configButtonShown = !_configButtonShown;
                          });
                        },
                        child: Stack(children: [
                          AssistantClock(),
                          if (_configButtonShown)
                            Positioned(
                              top: 0,
                              right: 0,
                              child: Opacity(
                                opacity: 0.7,
                                child: _configButton(),
                              ),
                            ),
                          if (_configButtonShown)
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Padding(
                                  padding:
                                      EdgeInsetsDirectional.only(bottom: 16),
                                  child: Opacity(
                                    opacity: 0.3,
                                    child: Text('Takeout',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  )),
                            )
                        ]))))));
  }

  Widget _configButton() {
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {
            Scaffold.of(context).openEndDrawer();
            setState(() {
              _configButtonShown = false;
            });
          },
        );
      },
    );
  }
}

class ConfigDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsCubit>().state.settings;
    return SafeArea(
        child: Drawer(
            child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  _switch('24-hour Clock', settings.use24HourClock,
                      (bool value) {
                    context.settings.use24HourClock = value;
                  }),
                  _textField(settings.wakeWords.join(', '), 'Wake Words',
                      (value) {
                    context.settings.wakeWords =
                        value.split(RegExp(r'\s*,\s*'));
                  })
                ],
              ),
            ),
          ),
          Container(child: Text('Takeout Assistant 0.1.0')), // #version#
        ],
      ),
    )));
  }

  Widget _switch(String label, bool value, ValueChanged<bool> onChanged) {
    return Row(
      children: <Widget>[
        Expanded(child: Text(label)),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }

  // Widget _enumMenu<T>(
  //     String label, T value, List<T> items, ValueChanged<T?> onChanged) {
  //   return InputDecorator(
  //     decoration: InputDecoration(
  //       labelText: label,
  //     ),
  //     child: DropdownButtonHideUnderline(
  //       child: DropdownButton<T>(
  //         value: value,
  //         isDense: true,
  //         onChanged: onChanged,
  //         items: items.map((T item) {
  //           return DropdownMenuItem<T>(
  //             value: item,
  //             child: Text(enumToString(item.toString())),
  //           );
  //         }).toList(),
  //       ),
  //     ),
  //   );
  // }

  Widget _textField(
      String currentValue, String label, ValueChanged<String> onChanged) {
    return TextField(
      decoration: InputDecoration(
        hintText: currentValue,
        helperText: label,
      ),
      onChanged: onChanged,
    );
  }
}

class SpeechButton extends StatelessWidget {
  final String text;
  final void Function(BuildContext) onPressed;

  SpeechButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Chip(
        onDeleted: () {},
        avatar: Icon(Icons.place_outlined),
        label: Text(text));
    // onPressed: () => onPressed(context));
  }
}

class AssistantClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return context.clock.repository.build(context);
  }
}
