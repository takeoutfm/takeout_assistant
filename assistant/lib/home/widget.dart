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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistant/context/context.dart';
import 'package:assistant/home/home.dart';

class LightsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(builder: (context, state) {
      return Scaffold(
          appBar: AppBar(title: Text('Lights')),
          body: SingleChildScrollView(
              child: Column(children: [
            ...state.lights.map((light) => Card(
                    child: Column(children: [
                  ListTile(
                    leading: light.on
                        ? Icon(Icons.lightbulb, size: 64, color: light.color)
                        : Icon(Icons.lightbulb_outline, size: 64),
                    title: Text('${light.name} (${light.room})'),
                    subtitle: Text('Zones: ${light.zones.join(", ")}'),
                    trailing: Switch(
                        value: light.on,
                        onChanged: (_) => context.home.toggleLight(light)),
                  ),
                  Slider(
                    value: light.brightness,
                    min: 0,
                    max: 100,
                    onChanged: (_) {},
                    onChangeEnd: (value) =>
                        context.home.lightBrightness(light, value),
                  ),
                ]))),
          ])));
    });
  }
}
