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

import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:assistant/ambient/light.dart';
import 'package:assistant/app/context.dart';
import 'package:assistant/audio/volume.dart';
import 'package:assistant/battery/battery.dart';
import 'package:assistant/clock/clock.dart';
import 'package:assistant/home/home.dart';
import 'package:assistant/home/repository.dart';
import 'package:assistant/intent/android.dart';
import 'package:assistant/intent/model.dart';
import 'package:assistant/settings/repository.dart';
import 'package:assistant/settings/settings.dart';
import 'package:assistant/speech/model.dart';
import 'package:assistant/speech/speech.dart';
import 'package:assistant/torch/light.dart';
import 'package:colornames/colornames.dart';
import 'package:flutter/material.dart' hide Intent;
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nested/nested.dart';
import 'package:path_provider/path_provider.dart';
import 'package:takeout_lib/art/builder.dart';
import 'package:takeout_lib/cache/json_repository.dart';
import 'package:takeout_lib/client/repository.dart';
import 'package:takeout_lib/context/bloc.dart';
import 'package:takeout_lib/player/player.dart';
import 'package:takeout_lib/settings/repository.dart';
import 'package:takeout_lib/tokens/repository.dart';
import 'package:takeout_lib/tokens/tokens.dart';
import 'package:screen_brightness/screen_brightness.dart';

import 'app.dart';

class AppBloc extends TakeoutBloc {
  static final intents = SpeechModels();

  @override
  ClientRepository createClientRepository({
    required SettingsRepository settingsRepository,
    required TokenRepository tokenRepository,
    required JsonCacheRepository jsonCacheRepository,
    String? userAgent,
  }) {
    return super.createClientRepository(
      userAgent:
          'TakeoutFM-Assistant/$appVersion (takeoutfm.com; ${Platform.operatingSystem})',
      settingsRepository: settingsRepository,
      tokenRepository: tokenRepository,
      jsonCacheRepository: jsonCacheRepository,
    );
  }

  @override
  List<SingleChildWidget> repositories(Directory directory) {
    final settingsRepository = AssistantSettingsRepository();
    final ambientLightRepository = AmbientLightRepository();
    final speechRepository = SpeechRepository();
    final volumeRepository = VolumeRepository();
    final torchRepository = TorchLightRepository();
    final clockRepository =
        ClockRepository(displayType: settingsRepository.settings?.displayType);
    final homeRepository = HomeRepository();
    final batteryRepository = BatteryRepository();

    return [
      ...super.repositories(directory),
      RepositoryProvider(create: (_) => ambientLightRepository),
      RepositoryProvider(create: (_) => speechRepository),
      RepositoryProvider(create: (_) => volumeRepository),
      RepositoryProvider(create: (_) => torchRepository),
      RepositoryProvider(create: (_) => clockRepository),
      RepositoryProvider(create: (_) => settingsRepository),
      RepositoryProvider(create: (_) => homeRepository),
      RepositoryProvider(create: (_) => batteryRepository),
    ];
  }

  @override
  List<SingleChildWidget> blocs() {
    return [
      ...super.blocs(),
      BlocProvider(create: (_) => AppCubit()),
      BlocProvider(
          lazy: false,
          create: (context) {
            final settings = AssistantSettingsCubit();
            context.read<AssistantSettingsRepository>().init(settings);
            return settings;
          }),
      BlocProvider(
        lazy: false,
        create: (context) =>
            AmbientLightCubit(context.read<AmbientLightRepository>()),
      ),
      BlocProvider(
        lazy: false,
        create: (context) => SpeechCubit(),
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
        create: (context) => HomeCubit(
            repository: context.read<HomeRepository>(),
            assistantSettingsRepository:
                context.read<AssistantSettingsRepository>()),
      ),
      BlocProvider(
          lazy: false,
          create: (context) {
            final settings = AssistantSettingsCubit();
            context.read<AssistantSettingsRepository>().init(settings);
            context
                .read<ClockRepository>()
                .init(context.read<AssistantSettingsRepository>());
            context
                .read<SpeechRepository>()
                .init(context.read<AssistantSettingsRepository>());
            context.read<SpeechCubit>().init(context.read<SpeechRepository>());
            return settings;
          }),
      BlocProvider(
          lazy: false,
          create: (context) => BatteryCubit(context.read<BatteryRepository>())),
    ];
  }

  @override
  List<SingleChildWidget> listeners(BuildContext context) {
    return [
      ...super.listeners(context),
      BlocListener<TokensCubit, TokensState>(listener: (context, state) {
        if (state.tokens.authenticated) {
          context.app.authenticated();
        }
      }),
      BlocListener<AmbientLightCubit, AmbientLightState>(
          listenWhen: (prevState, state) {
        return prevState.isLight != state.isLight;
      }, listener: (context, state) {
        if (state.isDark) {
          print('dimming screen (${state.lux})');
          ScreenBrightness.instance.setScreenBrightness(0.0);
          context.clock.pause();
        } else if (state.isLight) {
          print('brightening screen ${state.lux})');
          ScreenBrightness.instance.setScreenBrightness(0.5);
          context.clock.resume();
        }
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
              _handleText(context, state);
            }
          }),
      BlocListener<AssistantSettingsCubit, AssistantSettingsState>(
        listenWhen: (prevState, state) {
          return prevState.settings.enableSpeechRecognition !=
              state.settings.enableSpeechRecognition;
        },
        listener: (context, state) {
          // pause/resume speech recognition based on settings
          if (state.settings.enableSpeechRecognition) {
            context.speech.resume();
          } else {
            context.speech.pause();
          }
        },
      ),
      BlocListener<Player, PlayerState>(
          listenWhen: (_, state) =>
              state is PlayerLoad || state is PlayerIndexChange,
          listener: (context, state) {
            if (state is PlayerLoad || state is PlayerIndexChange) {
              final image = state.currentTrack?.image ?? '';
              getImageBackgroundColor(context, image).then((color) {
                context.app.backgroundColor = color;
              });
            }
          }),
      BlocListener<AppCubit, AppState>(
        listenWhen: (prevState, state) =>
            prevState.backgroundColor != state.backgroundColor,
        listener: (context, state) {
          // update lights when bgcolor changes
          final color = state.backgroundColor;
          if (color != null) {
            print('bgcolor changed $color ${ColorNames.guess(color)}');
            _updateMusicZone(context);
          }
        },
      ),
      BlocListener<HomeCubit, HomeState>(
        listenWhen: (prevState, state) {
          print('home ${prevState.lights.length} -> ${state.lights.length}');
          return prevState.lights.length != state.lights.length;
        },
        listener: (context, state) {
          // update lights when # of lights changes
          _updateMusicZone(context);
        },
      ),
    ];
  }

  void _updateMusicZone(BuildContext context) {
    final settings = context.assistantSettings.state.settings;
    if (settings.enableMusicZone == false) {
      return;
    }

    final color = context.app.state.backgroundColor;
    final name = settings.musicZone;
    if (name != null && color != null) {
      // TODO
      // print('update zone $name color $color ${ColorNames.guess(color)}');
      // context.home.zoneColor(name, color);
      for (var light in context.home.state.lights) {
        print('light ${light.zones} with $name');
        if (light.zones.contains(name)) {
          print('set $light to $color');
          context.home.lightColor(light, color);
        }
      }
    }
  }

  // TODO can support text from non-speech as well
  void _handleText(BuildContext context, SpeechText state) {
    final language = context.assistantSettings.state.settings.language;
    final intent = intents.match(language, state.text);
    if (intent != null) {
      acknowledge(context, state.text);
      print(intent.name);
      print(intent.extras);
      _handleIntent(context, language, intent);
    } else {
      ignore(context, state.text);
    }
  }

  void _handleIntent(BuildContext context, String language, Intent intent) {
    _handleAndroid(context, intent) ||
        _handlePlaylist(context, intent) ||
        _handlePlayer(context, intent) ||
        _handleVolume(context, intent) ||
        _handleTorch(context, intent) ||
        _handleLights(context, intent);
  }

  bool _handleAndroid(BuildContext context, Intent intent) {
    bool handled = false;
    final androidAction = AndroidAction.build(intent);
    if (androidAction != null) {
      final androidIntent = AndroidIntent(
        action: androidAction.name,
        arguments: androidAction.extrasMap(),
      );
      androidIntent.launch().then((_) {
        // restore foreground after 5 seconds
        Future.delayed(const Duration(seconds: 5),
            () => FlutterForegroundTask.launchApp());
      });
      handled = true;
    }
    return handled;
  }

  bool _handlePlaylist(BuildContext context, Intent intent) {
    bool handled = true;
    switch (intent.name) {
      case IntentName.playerPlay:
        context.player.play();
      case IntentName.playerPause:
        context.player.pause();
      case IntentName.playerNext:
        context.player.skipToNext();
      default:
        handled = false;
    }
    return handled;
  }

  bool _handlePlayer(BuildContext context, Intent intent) {
    bool handled = false;
    final artist = intent[Extra.artist];
    final album = intent[Extra.album];
    final song = intent[Extra.song];
    final query = intent[Extra.query];
    final station = intent[Extra.station];
    var ref = '';

    switch (intent.name) {
      case IntentName.playArtistAlbum:
        ref = '/music/search?q=+artist:"$artist" +release:"$album"';
      case IntentName.playArtistSong:
        ref = '/music/search?q=+artist:"$artist" +title:"$song"';
      case IntentName.playArtistSongs:
      case IntentName.playArtistRadio:
        ref = '/music/search?q=+artist:"$artist"&radio=1';
      case IntentName.playArtistPopularSongs:
        ref = '/music/search?q=+artist:"$artist" +popularity:<11';
      case IntentName.playAlbum:
        ref = '/music/search?q=+release:"$album"';
      case IntentName.playSong:
        ref = '/music/search?q=+title:"$song"';
      case IntentName.playRadio:
        ref = '/music/radio/stations/$station';
      case IntentName.playSearch:
        if (query is String) {
          var match = '';
          if (query.contains(':') == false) {
            // assume best match with simple queries
            match = '&m=1';
          }
          ref = '/music/search?q=$query$match';
        }
      default:
    }
    if (ref.isNotEmpty) {
      context.playlist.replace(ref);
      handled = true;
    }
    return handled;
  }

  bool _handleVolume(BuildContext context, Intent intent) {
    var handled = true;
    if (intent.name == IntentName.volumeUp) {
      _volumeUp(context);
    } else if (intent.name == IntentName.volumeDown) {
      _volumeDown(context);
    } else if (intent.name == IntentName.volume) {
      final value = intent[Extra.volumeValue];
      if (value is double) {
        _setVolume(context, value);
      }
    } else {
      handled = false;
    }
    return handled;
  }

  bool _handleTorch(BuildContext context, Intent intent) {
    var handled = true;
    if (intent.name == IntentName.torchOn) {
      context.torch.enable();
    } else if (intent.name == IntentName.torchOff) {
      context.torch.disable();
    } else {
      handled = false;
    }
    return handled;
  }

  bool _handleLights(BuildContext context, Intent intent) {
    var handled = true;
    final name = intent[Extra.light] as String?;
    if (intent.name == IntentName.turnOnLight) {
      _doLight(context, name: name, on: true);
    } else if (intent.name == IntentName.turnOffLight) {
      _doLight(context, name: name, on: false);
    } else if (intent.name == IntentName.turnOnAllLights) {
      _doAllLights(context, on: true);
    } else if (intent.name == IntentName.turnOffAllLights) {
      _doAllLights(context, on: false);
    } else if (intent.name == IntentName.setLightBrightness) {
      final brightness = intent[Extra.brightnessValue];
      _doLight(context, name: name, brightness: brightness);
    } else if (intent.name == IntentName.setLightColor) {
      final color = intent[Extra.colorValue] as Color?;
      _doLight(context, name: name, color: color);
    } else {
      handled = false;
    }
    return handled;
  }

  void _doAllLights(BuildContext context,
      {bool? on, double? brightness, Color? color}) {
    final doit = (light) {
      if (on == true) {
        context.home.lightOn(light);
      } else if (on == false) {
        context.home.lightOff(light);
      }
      if (brightness != null) {
        context.home.lightBrightness(light, brightness);
      }
      if (color != null) {
        context.home.lightColor(light, color);
      }
    };
    for (var light in context.home.state.lights) {
      doit(light);
    }
  }
}

void _doLight(BuildContext context,
    {String? name, bool? on, double? brightness, Color? color}) {
  final defaultRoom = context.assistantSettings.state.settings.homeRoom;
  final doit = (light) {
    if (on == true) {
      context.home.lightOn(light);
    } else if (on == false) {
      context.home.lightOff(light);
    }
    if (brightness != null) {
      context.home.lightBrightness(light, brightness);
    }
    if (color != null) {
      context.home.lightColor(light, color);
    }
  };

  if (name != null) {
    String? defaultRoomLight;
    if (defaultRoom != null) {
      defaultRoomLight = '${defaultRoom.toLowerCase()} ${name.toLowerCase()}';
    }
    for (var light in context.home.state.lights) {
      if (light.qualifiedNames.contains(name.toLowerCase()) ||
          light.qualifiedNames.contains(defaultRoomLight)) {
        print('qualified matched ${light.name}');
        doit(light);
      }
    }
  } else {
    for (var light in context.home.state.lights) {
      if (light.room == defaultRoom) {
        print('room matched ${light.name}');
        doit(light);
      }
    }
  }
}

void _volumeUp(BuildContext context) {
  final factor = 0.4;
  var v = context.volume.state.volume;
  if (v == 0) {
    v = factor;
  } else {
    v += v * factor;
  }
  context.volume.setVolume(v);
}

void _volumeDown(BuildContext context) {
  final factor = 0.25;
  var v = context.volume.state.volume;
  v -= v * factor;
  if (v < 0) {
    v = 0;
  }
  context.volume.setVolume(v);
}

void _setVolume(BuildContext context, double volume) {
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

Future<void> ignore(BuildContext context, String msg) async {
  Fluttertoast.showToast(
      msg: '* $msg',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0);
}

mixin AppBlocState {
  void appInitState(BuildContext context) {
    if (context.tokens.state.tokens.authenticated) {
      // restore authenticated state
      context.app.authenticated();
    }
    // prune incomplete/partial downloads
    // pruneCache(context.spiffCache.repository, context.trackCache.repository);
  }

  void appDispose() {}
}
