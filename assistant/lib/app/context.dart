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

import 'package:assistant/ambient/light.dart';
import 'package:assistant/audio/volume.dart';
import 'package:assistant/clock/clock.dart';
import 'package:assistant/home/home.dart';
import 'package:assistant/settings/settings.dart';
import 'package:assistant/speech/speech.dart';
import 'package:assistant/torch/light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:takeout_lib/tokens/tokens.dart';

import 'app.dart';

export 'package:takeout_lib/context/context.dart';

extension AppContext on BuildContext {
  AppLocalizations get strings => AppLocalizations.of(this)!;

  AppCubit get app => read<AppCubit>();

  AmbientLightCubit get ambientLight => read<AmbientLightCubit>();

  VolumeCubit get volume => read<VolumeCubit>();

  SpeechCubit get speech => read<SpeechCubit>();

  TorchLightCubit get torch => read<TorchLightCubit>();

  ClockCubit get clock => read<ClockCubit>();

  AssistantSettingsCubit get assistantSettings =>
      read<AssistantSettingsCubit>();

  HomeCubit get home => read<HomeCubit>();

  void logout() {
    read<TokensCubit>().removeAll();
    app.logout();
  }
}
