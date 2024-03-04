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

import 'package:assistant/ambient/light.dart';
import 'package:assistant/audio/volume.dart';
import 'package:assistant/clock/clock.dart';
import 'package:assistant/home/home.dart';
import 'package:assistant/settings/settings.dart';
import 'package:assistant/speech/speech.dart';
import 'package:assistant/torch/light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension AppContext on BuildContext {
  AmbientLightCubit get ambientLight => read<AmbientLightCubit>();

  VolumeCubit get volume => read<VolumeCubit>();

  SpeechCubit get speech => read<SpeechCubit>();

  TorchLightCubit get torch => read<TorchLightCubit>();

  ClockCubit get clock => read<ClockCubit>();

  SettingsCubit get settings => read<SettingsCubit>();

  HomeCubit get home => read<HomeCubit>();
}
