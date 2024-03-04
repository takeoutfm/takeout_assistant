import 'dart:ui';

import 'package:assistant/speech/model.dart';
import 'package:assistant/intent/model.dart';
import 'package:test/test.dart';

void main() {
  test('english volume', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.volume, {'volume': 'five', 'scaled_volume': 0.5}),
      speech.match('en', 'set volume to five'),
    );
    expect(
      Intent(IntentName.volume, {'volume': 'zero', 'scaled_volume': 0.0}),
      speech.match('en', 'set volume to zero'),
    );
    expect(
      Intent(IntentName.volume, {'volume': 'max', 'scaled_volume': 1.0}),
      speech.match('en', 'set volume to max'),
    );
    expect(
      Intent(IntentName.volume, {'volume': 'min', 'scaled_volume': 0.0}),
      speech.match('en', 'set volume to min'),
    );
  });

  test('english volume_up', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.volumeUp, {}),
      speech.match('en', 'turn it up'),
    );
  });

  test('english volume_down', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.volumeDown, {}),
      speech.match('en', 'turn it down'),
    );
  });

  test('english player_play', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playerPlay, {}),
      speech.match('en', 'resume'),
    );
  });

  test('english player_pause', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playerPause, {}),
      speech.match('en', 'pause'),
    );
  });

  test('english play_artist_songs', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playArtistSongs, {'artist': 'gary numan'}),
      speech.match('en', 'play songs by gary numan'),
    );
  });

  test('english play_artist_song', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playArtistSong,
          {'artist': 'gary numan', 'song': 'the pleasure principle'}),
      speech.match('en', 'play song the pleasure principle by gary numan'),
    );
  });

  test('english play_search', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playSearch, {'q': 'bagel radio'}),
      speech.match('en', 'play bagel radio'),
    );
    expect(
      Intent(IntentName.playSearch, {'q': 'alternative rock'}),
      speech.match('en', 'play alternative rock'),
    );
  });

  test('english play_radio', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playRadio, {'station': 'indie rock'}),
      speech.match('en', 'play station indie rock'),
    );
    expect(
      Intent(IntentName.playRadio, {'station': 'groove salad'}),
      speech.match('en', 'play groove salad station'),
    );
  });

  test('english play_artist_album', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playArtistAlbum,
          {'artist': 'led zeppelin', 'album': 'physical graffiti'}),
      speech.match('en', 'play album physical graffiti by led zeppelin'),
    );
  });

  test('english play_album', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playAlbum, {'album': 'physical graffiti'}),
      speech.match('en', 'play album physical graffiti'),
    );
  });

  test('english set_alarm', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.setAlarm, {'hour': 10, 'minutes': 0, 'time': 'ten am'}),
      speech.match('en', 'set alarm for ten am'),
    );
    expect(
      Intent(IntentName.setAlarm, {'hour': 22, 'minutes': 0, 'time': 'ten pm'}),
      speech.match('en', 'set alarm for ten pm'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 10, 'minutes': 15, 'time': 'ten fifteen am'}),
      speech.match('en', 'set alarm for ten fifteen am'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 22, 'minutes': 15, 'time': 'ten fifteen pm'}),
      speech.match('en', 'set alarm for ten fifteen pm'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 10, 'minutes': 40, 'time': 'ten forty'}),
      speech.match('en', 'set alarm for ten forty'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 10, 'minutes': 45, 'time': 'ten forty five'}),
      speech.match('en', 'set alarm for ten forty five'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 10, 'minutes': 45, 'time': 'ten forty five am'}),
      speech.match('en', 'set alarm for ten forty five am'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 22, 'minutes': 45, 'time': 'ten forty five pm'}),
      speech.match('en', 'set alarm for ten forty five pm'),
    );

    expect(
      Intent(
          IntentName.setAlarm, {'hour': 14, 'minutes': 0, 'time': 'fourteen'}),
      speech.match('en', 'set alarm for fourteen'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 23, 'minutes': 30, 'time': 'twenty three thirty'}),
      speech.match('en', 'set alarm for twenty three thirty'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 21, 'minutes': 35, 'time': 'twenty one thirty five'}),
      speech.match('en', 'set alarm for twenty one thirty five'),
    );

    expect(
      Intent(IntentName.setAlarm,
          {'hour': 5, 'minutes': 0, 'time': 'zero five hundred hours'}),
      speech.match('en', 'set alarm for zero five hundred hours'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 10, 'minutes': 0, 'time': 'ten hundred'}),
      speech.match('en', 'set alarm for ten hundred'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 16, 'minutes': 0, 'time': 'sixteen hundred'}),
      speech.match('en', 'set alarm for sixteen hundred'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {'hour': 21, 'minutes': 0, 'time': 'twenty one hundred hours'}),
      speech.match('en', 'set alarm for twenty one hundred hours'),
    );
  });

  test('english set_timer', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.setTimer, {'seconds': 10, 'duration': 'ten seconds'}),
      speech.match('en', 'set timer for ten seconds'),
    );
    expect(
      Intent(IntentName.setTimer, {'seconds': 300, 'duration': 'five minutes'}),
      speech.match('en', 'set timer for five minutes'),
    );
    expect(
      Intent(IntentName.setTimer, {'seconds': 7200, 'duration': 'two hours'}),
      speech.match('en', 'set timer for two hours'),
    );
    expect(
      Intent(IntentName.setTimer, {
        'seconds': 3600 + 120 + 3,
        'duration': 'one hour two minutes three seconds'
      }),
      speech.match('en', 'set timer for one hour two minutes three seconds'),
    );
    expect(
      Intent(IntentName.setTimer,
          {'seconds': 3600 + 120, 'duration': 'one hour two minutes'}),
      speech.match('en', 'set timer for one hour two minutes'),
    );
    expect(
      Intent(IntentName.setTimer,
          {'seconds': 3600 + 3, 'duration': 'one hour three seconds'}),
      speech.match('en', 'set timer for one hour three seconds'),
    );
    expect(
      Intent(IntentName.setTimer,
          {'seconds': 120 + 3, 'duration': 'two minutes three seconds'}),
      speech.match('en', 'set timer for two minutes three seconds'),
    );
  });

  test('english dismiss_alarm', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.dismissAlarm, {}),
      speech.match('en', 'dismiss alarm'),
    );
  });

  test('english dismiss_timer', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.dismissTimer, {}),
      speech.match('en', 'dismiss timer'),
    );
  });

  test('english torch_on', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.torchOn, {}),
      speech.match('en', 'turn on the torch'),
    );
    expect(
      Intent(IntentName.torchOn, {}),
      speech.match('en', 'turn torch on'),
    );
    expect(
      Intent(IntentName.torchOn, {}),
      speech.match('en', 'torch on'),
    );
    expect(
      Intent(IntentName.torchOn, {}),
      speech.match('en', 'flash on'),
    );
  });

  test('english torch_off', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.torchOff, {}),
      speech.match('en', 'turn off the torch'),
    );
    expect(
      Intent(IntentName.torchOff, {}),
      speech.match('en', 'turn torch off'),
    );
    expect(
      Intent(IntentName.torchOff, {}),
      speech.match('en', 'torch off'),
    );
    expect(
      Intent(IntentName.torchOff, {}),
      speech.match('en', 'flash off'),
    );
  });

  test('turn on light', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.turnOnLight, {}),
      speech.match('en', 'turn on the light'),
    );
    expect(
      Intent(IntentName.turnOnLight, {}),
      speech.match('en', 'turn on light'),
    );
    expect(
      Intent(IntentName.turnOnLight, {}),
      speech.match('en', 'light on'),
    );
    expect(
      Intent(IntentName.turnOnLight, {'light': 'lamp'}),
      speech.match('en', 'turn on the lamp'),
    );
    expect(
      Intent(IntentName.turnOnLight, {'light': 'office'}),
      speech.match('en', 'turn on the office light'),
    );
    expect(
      Intent(IntentName.turnOnLight, {'light': 'office desk'}),
      speech.match('en', 'turn on the office desk light'),
    );
  });

  test('turn off light', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.turnOffLight, {}),
      speech.match('en', 'turn off the light'),
    );
    expect(
      Intent(IntentName.turnOffLight, {}),
      speech.match('en', 'turn off light'),
    );
    expect(
      Intent(IntentName.turnOffLight, {}),
      speech.match('en', 'light off'),
    );
    expect(
      Intent(IntentName.turnOffLight, {'light': 'lamp'}),
      speech.match('en', 'turn off the lamp'),
    );
    expect(
      Intent(IntentName.turnOffLight, {'light': 'office'}),
      speech.match('en', 'turn off the office light'),
    );
    expect(
      Intent(IntentName.turnOffLight, {'light': 'office desk'}),
      speech.match('en', 'turn off the office desk light'),
    );
  });

  test('turn on all lights', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.turnOnAllLights, {}),
      speech.match('en', 'turn on lights'),
    );
    expect(
      Intent(IntentName.turnOnAllLights, {}),
      speech.match('en', 'turn on all lights'),
    );
    expect(
      Intent(IntentName.turnOnAllLights, {}),
      speech.match('en', 'lights on'),
    );
  });

  test('turn off all lights', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.turnOffAllLights, {}),
      speech.match('en', 'turn off lights'),
    );
    expect(
      Intent(IntentName.turnOffAllLights, {}),
      speech.match('en', 'turn off all lights'),
    );
    expect(
      Intent(IntentName.turnOffAllLights, {}),
      speech.match('en', 'lights off'),
    );
  });

  test('set light color', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.setLightColor,
          {'light': 'family room lamp', 'color': 'red'}),
      without(speech.match('en', 'set family room lamp color to red'),
          ['color_value']),
    );
    expect(
      Intent(IntentName.setLightColor, {'light': 'lamp', 'color': 'red'}),
      without(speech.match('en', 'set lamp color to red'), ['color_value']),
    );
    expect(
      Intent(IntentName.setLightColor, {'color': 'red'}),
      without(speech.match('en', 'set color to red'), ['color_value']),
    );
    expect(
      Intent(IntentName.setLightColor, {'color': 'red'}),
      without(speech.match('en', 'color red'), ['color_value']),
    );
  });

  test('set light brightness', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.setLightBrightness, {
        'light': 'family room lamp',
        'brightness': 'seventy five',
        'brightness_value': 75.0
      }),
      speech.match('en', 'set family room lamp brightness to seventy five'),
    );
    expect(
      Intent(IntentName.setLightBrightness, {
        'light': 'lamp',
        'brightness': 'seventy five',
        'brightness_value': 75.0
      }),
      speech.match('en', 'set lamp brightness to seventy five'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {'brightness': 'seventy five', 'brightness_value': 75.0}),
      speech.match('en', 'set brightness to seventy five'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {'brightness': 'twenty one', 'brightness_value': 21.0}),
      speech.match('en', 'brightness twenty one'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {'brightness': 'fifty', 'brightness_value': 50.0}),
      speech.match('en', 'brightness fifty'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {'brightness': 'low', 'brightness_value': 10.0}),
      speech.match('en', 'brightness low'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {'brightness': 'max', 'brightness_value': 100.0}),
      speech.match('en', 'brightness max'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {'brightness': '45', 'brightness_value': 45.0}),
      speech.match('en', 'brightness 45'),
    );
  });
}

Intent? dump(Intent? intent) {
  if (intent == null) {
    print(intent);
    return intent;
  }
  print('intent name=${intent.name} extras=${intent.extras}');
  return intent;
}

Intent? without(Intent? intent, List<String> keys) {
  if (intent == null) {
    return null;
  }
  final extras = <String, dynamic>{};
  for (var e in intent.extras.entries) {
    if (keys.contains(e.key) == false) {
      extras[e.key] = e.value;
    }
  }
  return Intent(intent.name, extras);
}
