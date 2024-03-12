import 'package:assistant/intent/model.dart';
import 'package:assistant/speech/model.dart';
import 'package:test/test.dart';

void main() {
  test('english volume', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.volume, {Extra.volume: 'five', Extra.volumeValue: 0.5}),
      speech.match('en', 'set volume to five'),
    );
    expect(
      Intent(IntentName.volume, {Extra.volume: 'zero', Extra.volumeValue: 0.0}),
      speech.match('en', 'set volume to zero'),
    );
    expect(
      Intent(IntentName.volume, {Extra.volume: 'max', Extra.volumeValue: 1.0}),
      speech.match('en', 'set volume to max'),
    );
    expect(
      Intent(IntentName.volume, {Extra.volume: 'min', Extra.volumeValue: 0.0}),
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
      Intent(IntentName.playArtistSongs, {Extra.artist: 'gary numan'}),
      speech.match('en', 'play songs by gary numan'),
    );
  });

  test('english play_artist_song', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playArtistSong,
          {Extra.artist: 'gary numan', Extra.song: 'the pleasure principle'}),
      speech.match('en', 'play song the pleasure principle by gary numan'),
    );
  });

  test('english play_search', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playSearch, {Extra.query: 'bagel radio'}),
      speech.match('en', 'play bagel radio'),
    );
    expect(
      Intent(IntentName.playSearch, {Extra.query: 'alternative rock'}),
      speech.match('en', 'play alternative rock'),
    );
  });

  test('english play_radio', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playRadio, {Extra.station: 'indie rock'}),
      speech.match('en', 'play station indie rock'),
    );
    expect(
      Intent(IntentName.playRadio, {Extra.station: 'groove salad'}),
      speech.match('en', 'play groove salad station'),
    );
  });

  test('english play_artist_album', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playArtistAlbum,
          {Extra.artist: 'led zeppelin', Extra.album: 'physical graffiti'}),
      speech.match('en', 'play album physical graffiti by led zeppelin'),
    );
  });

  test('english play_album', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.playAlbum, {Extra.album: 'physical graffiti'}),
      speech.match('en', 'play album physical graffiti'),
    );
  });

  test('english set_alarm', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 10, Extra.minutes: 0, Extra.time: 'ten am'}),
      speech.match('en', 'set alarm for ten am'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 22, Extra.minutes: 0, Extra.time: 'ten pm'}),
      speech.match('en', 'set alarm for ten pm'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 10, Extra.minutes: 15, Extra.time: 'ten fifteen am'}),
      speech.match('en', 'set alarm for ten fifteen am'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 22, Extra.minutes: 15, Extra.time: 'ten fifteen pm'}),
      speech.match('en', 'set alarm for ten fifteen pm'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 10, Extra.minutes: 40, Extra.time: 'ten forty'}),
      speech.match('en', 'set alarm for ten forty'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 10, Extra.minutes: 45, Extra.time: 'ten forty five'}),
      speech.match('en', 'set alarm for ten forty five'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 10, Extra.minutes: 45, Extra.time: 'ten forty five am'}),
      speech.match('en', 'set alarm for ten forty five am'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 22, Extra.minutes: 45, Extra.time: 'ten forty five pm'}),
      speech.match('en', 'set alarm for ten forty five pm'),
    );

    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 14, Extra.minutes: 0, Extra.time: 'fourteen'}),
      speech.match('en', 'set alarm for fourteen'),
    );
    expect(
      Intent(IntentName.setAlarm, {
        Extra.hour: 23,
        Extra.minutes: 30,
        Extra.time: 'twenty three thirty'
      }),
      speech.match('en', 'set alarm for twenty three thirty'),
    );
    expect(
      Intent(IntentName.setAlarm, {
        Extra.hour: 21,
        Extra.minutes: 35,
        Extra.time: 'twenty one thirty five'
      }),
      speech.match('en', 'set alarm for twenty one thirty five'),
    );

    expect(
      Intent(IntentName.setAlarm, {
        Extra.hour: 5,
        Extra.minutes: 0,
        Extra.time: 'zero five hundred hours'
      }),
      speech.match('en', 'set alarm for zero five hundred hours'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 10, Extra.minutes: 0, Extra.time: 'ten hundred'}),
      speech.match('en', 'set alarm for ten hundred'),
    );
    expect(
      Intent(IntentName.setAlarm,
          {Extra.hour: 16, Extra.minutes: 0, Extra.time: 'sixteen hundred'}),
      speech.match('en', 'set alarm for sixteen hundred'),
    );
    expect(
      Intent(IntentName.setAlarm, {
        Extra.hour: 21,
        Extra.minutes: 0,
        Extra.time: 'twenty one hundred hours'
      }),
      speech.match('en', 'set alarm for twenty one hundred hours'),
    );
  });

  test('english set_timer', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.setTimer,
          {Extra.seconds: 10, Extra.duration: 'ten seconds'}),
      speech.match('en', 'set timer for ten seconds'),
    );
    expect(
      Intent(IntentName.setTimer,
          {Extra.seconds: 300, Extra.duration: 'five minutes'}),
      speech.match('en', 'set timer for five minutes'),
    );
    expect(
      Intent(IntentName.setTimer,
          {Extra.seconds: 7200, Extra.duration: 'two hours'}),
      speech.match('en', 'set timer for two hours'),
    );
    expect(
      Intent(IntentName.setTimer, {
        Extra.seconds: 3600 + 120 + 3,
        Extra.duration: 'one hour two minutes three seconds'
      }),
      speech.match('en', 'set timer for one hour two minutes three seconds'),
    );
    expect(
      Intent(IntentName.setTimer,
          {Extra.seconds: 3600 + 120, Extra.duration: 'one hour two minutes'}),
      speech.match('en', 'set timer for one hour two minutes'),
    );
    expect(
      Intent(IntentName.setTimer,
          {Extra.seconds: 3600 + 3, Extra.duration: 'one hour three seconds'}),
      speech.match('en', 'set timer for one hour three seconds'),
    );
    expect(
      Intent(IntentName.setTimer, {
        Extra.seconds: 120 + 3,
        Extra.duration: 'two minutes three seconds'
      }),
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
      Intent(IntentName.turnOnLight, {Extra.light: 'lamp'}),
      speech.match('en', 'turn on the lamp'),
    );
    expect(
      Intent(IntentName.turnOnLight, {Extra.light: 'office'}),
      speech.match('en', 'turn on the office light'),
    );
    expect(
      Intent(IntentName.turnOnLight, {Extra.light: 'office desk'}),
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
      Intent(IntentName.turnOffLight, {Extra.light: 'lamp'}),
      speech.match('en', 'turn off the lamp'),
    );
    expect(
      Intent(IntentName.turnOffLight, {Extra.light: 'office'}),
      speech.match('en', 'turn off the office light'),
    );
    expect(
      Intent(IntentName.turnOffLight, {Extra.light: 'office desk'}),
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
          {Extra.light: 'family room lamp', Extra.color: 'red'}),
      without(speech.match('en', 'set family room lamp color to red'),
          [Extra.colorValue]),
    );
    expect(
      Intent(
          IntentName.setLightColor, {Extra.light: 'lamp', Extra.color: 'red'}),
      without(speech.match('en', 'set lamp color to red'), [Extra.colorValue]),
    );
    expect(
      Intent(IntentName.setLightColor, {Extra.color: 'red'}),
      without(speech.match('en', 'set color to red'), [Extra.colorValue]),
    );
    expect(
      Intent(IntentName.setLightColor, {Extra.color: 'red'}),
      without(speech.match('en', 'color red'), [Extra.colorValue]),
    );
  });

  test('set light brightness', () {
    final speech = SpeechModels();
    expect(
      Intent(IntentName.setLightBrightness, {
        Extra.light: 'family room lamp',
        Extra.brightness: 'seventy five',
        Extra.brightnessValue: 75.0
      }),
      speech.match('en', 'set family room lamp brightness to seventy five'),
    );
    expect(
      Intent(IntentName.setLightBrightness, {
        Extra.light: 'lamp',
        Extra.brightness: 'seventy five',
        Extra.brightnessValue: 75.0
      }),
      speech.match('en', 'set lamp brightness to seventy five'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {Extra.brightness: 'seventy five', Extra.brightnessValue: 75.0}),
      speech.match('en', 'set brightness to seventy five'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {Extra.brightness: 'twenty one', Extra.brightnessValue: 21.0}),
      speech.match('en', 'brightness twenty one'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {Extra.brightness: 'fifty', Extra.brightnessValue: 50.0}),
      speech.match('en', 'brightness fifty'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {Extra.brightness: 'low', Extra.brightnessValue: 10.0}),
      speech.match('en', 'brightness low'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {Extra.brightness: 'max', Extra.brightnessValue: 100.0}),
      speech.match('en', 'brightness max'),
    );
    expect(
      Intent(IntentName.setLightBrightness,
          {Extra.brightness: '45', Extra.brightnessValue: 45.0}),
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

Intent? without(Intent? intent, List<Extra> keys) {
  if (intent == null) {
    return null;
  }
  final extras = <Extra, dynamic>{};
  for (var e in intent.extras.entries) {
    if (keys.contains(e.key) == false) {
      extras[e.key] = e.value;
    }
  }
  return Intent(intent.name, extras);
}
