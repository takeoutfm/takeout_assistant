// Copyright 2024 defsub
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

import 'package:assistant/app/context.dart';
import 'package:assistant/battery/battery.dart';
import 'package:assistant/battery/icon.dart';
import 'package:assistant/settings/settings.dart';
import 'package:assistant/torch/light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:one_clock/one_clock.dart';
import 'package:takeout_lib/player/player.dart';

import 'clock.dart';

class BasicClockProvider extends ClockProvider {
  @override
  void setPaused(bool paused) {}

  @override
  Widget build(BuildContext context, {Widget? child}) {
    return OrientationBuilder(builder: (context, orientation) {
      final state = context.watch<AssistantSettingsCubit>().state;
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
                  textScaleFactor: orientation == Orientation.landscape ? 8 : 5,
                  isLive: true,
                ),
                DigitalClock(
                  digitalClockTextColor: Colors.white30,
                  format: 'EEE, MMM d',
                  textScaleFactor: 2,
                  isLive: true,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  IconButton(
                      icon: Icon(state.settings.enableSpeechRecognition
                          ? Icons.mic
                          : Icons.mic_off),
                      onPressed: () =>
                          context.assistantSettings.toggleSpeechRecognition()),
                  BlocBuilder<BatteryCubit, BatteryState>(
                      builder: (context, state) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        batteryIcon(state),
                        Text('${state.batteryLevel}%'),
                      ],
                    );
                  }),
                  BlocBuilder<Player, PlayerState>(builder: (context, state) {
                    if (state is PlayerInit ||
                        state is PlayerReady ||
                        state is PlayerStop) {
                      return const SizedBox.shrink();
                    }
                    bool playing = false;
                    if (state is PlayerPositionState) {
                      playing = state.playing;
                    }
                    return Row(mainAxisSize: MainAxisSize.min, children: [
                      IconButton(
                          icon: playing
                              ? Icon(Icons.pause)
                              : Icon(Icons.play_arrow),
                          onPressed: () {
                            if (playing) {
                              context.player.pause();
                            } else {
                              context.player.play();
                            }
                          }),
                      if (state.spiff.isStream() == false)
                        IconButton(
                            icon: Icon(Icons.skip_next),
                            onPressed: state.hasNext
                                ? () => context.player.skipToNext()
                                : null),
                    ]);
                  }),
                ]),
              ]),
          if (child != null) child else SizedBox.shrink(),
        ],
      ));
    });
  }
}
