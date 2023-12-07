import 'package:assistant/ambient/light.dart';
import 'package:assistant/audio/volume.dart';
import 'package:assistant/clock/clock.dart';
import 'package:assistant/playing/playing.dart';
import 'package:assistant/speech/speech.dart';
import 'package:assistant/torch/light.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension AppContext on BuildContext {
  AmbientLightCubit get ambientLight => read<AmbientLightCubit>();

  PlayingCubit get playing => read<PlayingCubit>();

  VolumeCubit get volume => read<VolumeCubit>();

  SpeechCubit get speech => read<SpeechCubit>();

  TorchLightCubit get torch => read<TorchLightCubit>();

  ClockCubit get clock => read<ClockCubit>();
}
