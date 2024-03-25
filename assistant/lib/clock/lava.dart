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

import 'package:assistant/settings/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lava_clock/frame.dart';
import 'package:lava_clock/lava_clock.dart';
import 'package:lava_clock/model.dart';

import 'clock.dart';

class LavaClockProvider extends ClockProvider {
  @override
  Widget build(BuildContext context, {Widget? child}) {
    return BlocBuilder<AssistantSettingsCubit, AssistantSettingsState>(
        buildWhen: (prevState, state) =>
            prevState.settings.use24HourClock != state.settings.use24HourClock,
        builder: (context, state) {
          final model = ClockModel();
          model.is24HourFormat = state.settings.use24HourClock;
          return ClockFrame(
              key: clockFrameKey,
              child: (controller) => Stack(
                    fit: StackFit.expand,
                    children: [
                      LavaClock(model, animationController: controller),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: child,
                      )
                    ],
                  ));
        });
  }

  @override
  void setPaused(bool paused) {
    final controller = clockFrameKey.currentState?.animationController;
    if (paused) {
      if (controller?.isAnimating == true) {
        controller?.stop();
      }
    } else {
      if (controller?.isAnimating == false) {
        controller?.repeat();
      }
    }
  }
}
