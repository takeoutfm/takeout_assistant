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

import 'package:colornames/colornames.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:assistant/app/context.dart';
import 'package:assistant/home/home.dart';
import 'package:flex_color_picker/flex_color_picker.dart';

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
                    leading: Column(children: [
                      light.on
                          ? Icon(Icons.lightbulb, size: 48, color: light.color)
                          : Icon(Icons.lightbulb_outline,
                              size: 48, color: light.color),
                      Text(light.color.colorName),
                    ]),
                    title: Text('${light.name} (${light.room})'),
                    subtitle: Text('${light.zones.join(", ")}'),
                    trailing: Switch(
                        value: light.on,
                        onChanged: (_) => context.home.toggleLight(light)),
                    onTap: () async {
                      final color =
                          await showColorPickerDialog(context, light.color);
                      if (color != light.color) {
                        context.home.lightColor(light, color);
                      }
                    },
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
