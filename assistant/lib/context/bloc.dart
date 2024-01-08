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

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:assistant/ambient/light.dart';
import 'package:assistant/audio/volume.dart';
import 'package:assistant/clock/clock.dart';
import 'package:assistant/context/context.dart';
import 'package:assistant/settings/repository.dart';
import 'package:assistant/settings/settings.dart';
import 'package:assistant/speech/model.dart';
import 'package:assistant/speech/speech.dart';
import 'package:assistant/torch/light.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nested/nested.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppBloc {
  static late Directory _appDir;

  static final Map<String, String> _intent2action = {
    Intent.play_artist_songs: 'com.takeoutfm.action.PLAY_ARTIST',
    Intent.play_artist_song: 'com.takeoutfm.action.PLAY_ARTIST_SONG',
    Intent.play_artist_album: 'com.takeoutfm.action.PLAY_ARTIST_ALBUM',
    Intent.play_artist_radio: 'com.takeoutfm.action.PLAY_ARTIST_RADIO',
    Intent.play_artist_popular_songs:
        'com.takeoutfm.action.PLAY_ARTIST_POPULAR_SONGS',
    Intent.play_album: 'com.takeoutfm.action.PLAY_ALBUM',
    Intent.play_song: 'com.takeoutfm.action.PLAY_SONG',
    Intent.player_play: 'com.takeoutfm.action.PLAYER_PLAY',
    Intent.player_pause: 'com.takeoutfm.action.PLAYER_PAUSE',
    Intent.player_next: 'com.takeoutfm.action.PLAYER_NEXT',
  };

  static Future<void> initStorage() async {
    _appDir = await getApplicationDocumentsDirectory();
    final storageDir = Directory('${_appDir.path}/state');
    HydratedBloc.storage =
        await HydratedStorage.build(storageDirectory: storageDir);
  }

  static final intents = SpeechModels();

  Widget init(BuildContext context, {required Widget child}) {
    return MultiRepositoryProvider(
        providers: repositories(_appDir),
        child: MultiBlocProvider(
            providers: blocs(),
            child: MultiBlocListener(
                listeners: listeners(context), child: child)));
  }

  List<SingleChildWidget> repositories(Directory directory) {
    final settingsRepository = SettingsRepository();
    final ambientLightRepository = AmbientLightRepository();
    final speechRepository =
        SpeechRepository(settingsRepository: settingsRepository);
    final volumeRepository = VolumeRepository();
    final torchRepository = TorchLightRepository();
    final clockRepository = ClockRepository();

    return [
      RepositoryProvider(create: (_) => ambientLightRepository),
      RepositoryProvider(create: (_) => speechRepository),
      RepositoryProvider(create: (_) => volumeRepository),
      RepositoryProvider(create: (_) => torchRepository),
      RepositoryProvider(create: (_) => clockRepository),
      RepositoryProvider(create: (_) => settingsRepository),
    ];
  }

  List<SingleChildWidget> blocs() {
    return [
      BlocProvider(
          lazy: false,
          create: (context) {
            final settings = SettingsCubit();
            context.read<SettingsRepository>().init(settings);
            return settings;
          }),
      BlocProvider(
        lazy: false,
        create: (context) =>
            AmbientLightCubit(context.read<AmbientLightRepository>()),
      ),
      BlocProvider(
        lazy: false,
        create: (context) => SpeechCubit(context.read<SpeechRepository>()),
      ),
      BlocProvider(
        create: (context) => VolumeCubit(context.read<VolumeRepository>()),
      ),
      BlocProvider(
        create: (context) =>
            TorchLightCubit(context.read<TorchLightRepository>()),
      ),
      BlocProvider(
        lazy: false,
        create: (context) => ClockCubit(context.read<ClockRepository>()),
      ),
      BlocProvider(
          lazy: false,
          create: (context) {
            final settings = SettingsCubit();
            context.read<SettingsRepository>().init(settings);
            context
                .read<ClockRepository>()
                .init(context.read<SettingsRepository>());
            return settings;
          }),
    ];
  }

  List<SingleChildWidget> listeners(BuildContext context) {
    return [
      BlocListener<AmbientLightCubit, AmbientLightState>(
          listener: (context, state) {
        // print('ambient light lux is ${state.lux}');
      }),
      BlocListener<VolumeCubit, VolumeState>(listener: (context, state) {
        print('volume is ${state.volume}, was ${state.previousVolume}');
      }),
      BlocListener<TorchLightCubit, TorchLightState>(
          listener: (context, state) {
        print('torch is ${state.enabled}');
      }),
      BlocListener<SpeechCubit, SpeechState>(
          listenWhen: (_, state) =>
              state is SpeechAsleep ||
              state is SpeechAwake ||
              state is SpeechText,
          listener: (context, state) {
            if (state is SpeechAwake) {
              SystemSound.play(SystemSoundType.click);
              context.clock.pause();
            } else if (state is SpeechAsleep) {
              context.clock.resume();
            } else if (state is SpeechText) {
              handleText(context, state);
            }
          }),
    ];
  }

  void handleText(BuildContext context, SpeechText state) {
    final language = context.settings.state.settings.language;
    final intent = intents.match(language, state.text);
    if (intent != null) {
      handleIntent(context, language, intent);
    } else {
      print('unmatched - ${state.text}');
    }
  }

  void handleIntent(BuildContext context, String language, Intent intent) {
    acknowledge(context, intents.describe(language, intent) ?? 'ok').then((_) {
      String? action = _intent2action[intent.name];
      if (action != null) {
        final args = intent.fields;
        final i = AndroidIntent(
          action: action,
          arguments: args,
        );
        i.launch();
      } else if (intent.name == Intent.torch_on) {
        context.torch.enable();
      } else if (intent.name == Intent.torch_off) {
        context.torch.disable();
      } else if (intent.name == Intent.volume_up) {
        volumeUp(context);
      } else if (intent.name == Intent.volume_down) {
        volumeDown(context);
      } else if (intent.name == Intent.volume) {
        final value = intent.fields['volume'];
        if (value != null) {
          final volume = intents.volume(language, value);
          if (volume != null) {
            setVolume(context, volume);
          }
        }
      }
    });
  }

  void volumeUp(BuildContext context) {
    final factor = 0.4;
    var v = context.volume.state.volume;
    if (v == 0) {
      v = factor;
    } else {
      v += v * factor;
    }
    context.volume.setVolume(v);
  }

  void volumeDown(BuildContext context) {
    final factor = 0.25;
    var v = context.volume.state.volume;
    v -= v * factor;
    if (v < 0) {
      v = 0;
    }
    context.volume.setVolume(v);
  }

  void setVolume(BuildContext context, double volume) {
    context.volume.setVolume(volume);
  }

  Future<void> acknowledge(BuildContext context, String msg) async {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
