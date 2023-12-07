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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await AppBloc.initStorage();
  runApp(const AssistantApp());
}

class AssistantApp extends StatelessWidget {
  const AssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBloc().init(context,
        child: MaterialApp(
            home: Stack(fit: StackFit.expand, children: [
          AssistantClock(),
        ])));
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
