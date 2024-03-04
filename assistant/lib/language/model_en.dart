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

import 'dart:ui';

import 'package:assistant/speech/model.dart';
import 'package:assistant/intent/model.dart';
import 'colors_en.dart';

class EnglishModel extends SpeechModel {
  String get language => 'en';

  static final Map<String, double> _volumeTable = {
    // numbers
    'zero': 0,
    'one': 0.1,
    'two': 0.2,
    'three': 0.3,
    'four': 0.4,
    'five': 0.5,
    'six': 0.6,
    'seven': 0.7,
    'eight': 0.8,
    'nine': 0.9,
    'ten': 1.0,
    'eleven': 1.0,
    // others
    'min': 0.0,
    'off': 0.0,
    'mute': 0.0,
    'low': 0.3,
    'max': 1.0,
  };

  static final Map<String, double> _brightnessTable = {
    'min': 0.0,
    'low': 10.0,
    'dim': 20.0,
    'half': 50.0,
    'medium': 50.0,
    'high': 90.0,
    'max': 100.0,
  };

  static final Map<String, int> _numberTable = {
    'zero': 0,
    'one': 1,
    'two': 2,
    'three': 3,
    'four': 4,
    'five': 5,
    'six': 6,
    'seven': 7,
    'eight': 8,
    'nine': 9,
    'ten': 10,
    'eleven': 11,
    'twelve': 12,
    'thirteen': 13,
    'fourteen': 14,
    'fifteen': 15,
    'sixteen': 16,
    'seventeen': 17,
    'eighteen': 18,
    'nineteen': 19,
    'twenty': 20,
    'twenty-one': 21,
    'twenty-two': 22,
    'twenty-three': 23,
    'twenty-four': 24,
    'twenty-five': 25,
    'twenty-six': 26,
    'twenty-seven': 27,
    'twenty-eight': 28,
    'twenty-nine': 29,
    'thirty': 30,
    'thirty-one': 21,
    'thirty-two': 22,
    'thirty-three': 23,
    'thirty-four': 24,
    'thirty-five': 25,
    'thirty-six': 26,
    'thirty-seven': 27,
    'thirty-eight': 28,
    'thirty-nine': 29,
    'forty': 40,
    'forty-one': 21,
    'forty-two': 22,
    'forty-three': 23,
    'forty-four': 24,
    'forty-five': 25,
    'forty-six': 26,
    'forty-seven': 27,
    'forty-eight': 28,
    'forty-nine': 29,
    'fifty': 50,
    'fifty-one': 51,
    'fifty-two': 52,
    'fifty-three': 53,
    'fifty-four': 54,
    'fifty-five': 55,
    'fifty-six': 56,
    'fifty-seven': 57,
    'fifty-eight': 58,
    'fifty-nine': 59,
    'sixty': 60,
    'sixty-one': 61,
    'sixty-two': 62,
    'sixty-three': 63,
    'sixty-four': 64,
    'sixty-five': 65,
    'sixty-six': 66,
    'sixty-seven': 67,
    'sixty-eight': 68,
    'sixty-nine': 69,
    'seventy': 70,
    'seventy-one': 71,
    'seventy-two': 72,
    'seventy-three': 73,
    'seventy-four': 74,
    'seventy-five': 75,
    'seventy-six': 76,
    'seventy-seven': 77,
    'seventy-eight': 78,
    'seventy-nine': 79,
    'eighty': 80,
    'eighty-one': 81,
    'eighty-two': 82,
    'eighty-three': 83,
    'eighty-four': 84,
    'eighty-five': 85,
    'eighty-six': 86,
    'eighty-seven': 87,
    'eighty-eight': 88,
    'eighty-nine': 89,
    'ninety': 90,
    'ninety-one': 91,
    'ninety-two': 92,
    'ninety-three': 93,
    'ninety-four': 94,
    'ninety-five': 95,
    'ninety-six': 96,
    'ninety-seven': 97,
    'ninety-eight': 98,
    'ninety-nine': 99,
    'one-hundred': 100,
  };

  String _hyphenate(String text) {
    // forty five -> forty-five
    final sub = RegExp(
        r'(one|twenty|thirty|forty|fifty|sixty|seventy|eighty|ninety) (one|two|three|four|five|six|seven|eight|nine|hundred)');
    text = text.replaceAllMapped(
        sub, (match) => '${match.group(1)}-${match.group(2)}');
    return text;
  }

  Map<String, dynamic> _matchTimeGroups(RegExp regexp, String text) {
    text = _hyphenate(text);
    final fields = <String, dynamic>{};
    final match = regexp.firstMatch(text);
    if (match != null) {
      for (var n in match.groupNames) {
        final value = match.namedGroup(n);
        if (value != null) {
          final num = _numberTable[value] ?? int.tryParse(value) ?? value;
          fields[n] = num;
        }
      }
    }
    return fields;
  }

  String _militaryTime(String phrase) {
    // zero five hundred -> 5 am
    // oh five hundred hours -> 5 am
    final military1 = RegExp(
        r'^(zero|oh|o) (one|two|three|four|five|six|seven|eight|nine) hundred( hours)?$');
    phrase =
        phrase.replaceAllMapped(military1, (match) => '${match.group(2)} am');
    // ten hundred -> ten
    // twenty hundred -> twenty
    final military2 = RegExp(
        r'^(ten|eleven|twelve|thirteen|forteen|fifteen|sixteen|seventeen|eighteen|nineteen|twenty) hundred( hours)?$');
    phrase = phrase.replaceAllMapped(military2, (match) => '${match.group(1)}');
    // twenty one hundred -> twenty-one
    final military3 =
        RegExp(r'^(twenty)[ -]?(one|two|three|four) hundred( hours)?$');
    phrase = phrase.replaceAllMapped(
        military3, (match) => '${match.group(1)}-${match.group(2)}');
    return phrase;
  }

  DateTime? _time(String phrase) {
    phrase = _militaryTime(phrase);
    final regexps = [
      // one fifteen pm
      RegExp(r'^(?<hours>([\w-]+)) (?<minutes>[\w- ]+) (?<ampm>(am|pm))$'),
      // one
      // one pm
      RegExp(r'^(?<hours>([\w-]+)) ?(?<ampm>(am|pm|))$'),
      // one fifteen
      RegExp(r'^(?<hours>([\w-]+)) (?<minutes>[\w -]+)$'),
    ];
    for (var r in regexps) {
      if (r.hasMatch(phrase)) {
        final fields = _matchTimeGroups(r, phrase);
        if (fields.isNotEmpty) {
          var hours = (fields['hours'] is int) ? fields['hours'] : 0;
          final minutes = (fields['minutes'] is int) ? fields['minutes'] : 0;
          if (fields['ampm'] == 'pm') {
            hours += 12;
          }
          return DateTime.now().copyWith(
              hour: hours, minute: minutes, second: 0, millisecond: 0);
        }
      }
    }
    return null;
  }

  Duration? _duration(String phrase) {
    final regexps = [
      RegExp(
          r'^(?<hours>([\w-]+)) hour(s)? (?<minutes>[\w-]+) minute(s)? (?<seconds>[\w-]+) second(s)?$'),
      RegExp(r'^(?<hours>([\w-]+)) hour(s)? (?<minutes>[\w-]+) minute(s)?$'),
      RegExp(r'^(?<hours>([\w-]+)) hour(s)? (?<seconds>[\w-]+) seconds(s)?$'),
      RegExp(r'^(?<minutes>[\w-]+) minute(s)? (?<seconds>[\w-]+) seconds(s)?$'),
      RegExp(r'^(?<hours>[\w-]+) hour(s)?$'),
      RegExp(r'^(?<minutes>[\w-]+) minute(s)?$'),
      RegExp(r'^(?<seconds>[\w-]+) seconds(s)?$'),
    ];
    for (var regexp in regexps) {
      final fields = _matchTimeGroups(regexp, phrase);
      if (fields.isNotEmpty) {
        final minutes = (fields['minutes'] is int) ? fields['minutes'] : 0;
        final hours = (fields['hours'] is int) ? fields['hours'] : 0;
        final seconds = (fields['seconds'] is int) ? fields['seconds'] : 0;
        return Duration(hours: hours, minutes: minutes, seconds: seconds);
      }
    }
    return null;
  }

  double? _volume(String word) {
    var value = _volumeTable[word];
    if (value != null) {
      if (value > 1.0) {
        value = 1.0;
      } else if (value < 0.0) {
        value = 0.0;
      }
    }
    return value;
  }

  double? _brightness(String level) {
    double? value = double.tryParse(level);
    if (value == null) {
      value = _brightnessTable[level];
    }
    if (value == null) {
      level = _hyphenate(level);
      value = _numberTable[level]?.toDouble();
    }
    if (value != null) {
      if (value > 100) {
        value = 100;
      } else if (value < 0.0) {
        value = 0.0;
      }
    }
    return value;
  }

  Color? _color(String name) {
    final value = colorTable[name] ?? colorTable['clear day'];
    if (value != null) {
      return Color(value);
    }
    return null;
  }

  String? describe(Intent intent) {
    switch (intent.name) {
      case IntentName.playArtistAlbum:
        return 'playing ${intent.extras['album']}';
      case IntentName.playArtistPopularSongs:
        return 'popular ${intent.extras['artist']}';
      case IntentName.playArtistRadio:
        return 'playing ${intent.extras['artist']} mix';
      case IntentName.playArtistSong:
        return 'playing ${intent.extras['song']}';
      case IntentName.playArtistSongs:
        return 'playing ${intent.extras['artist']}';
      case IntentName.playAlbum:
        return 'playing ${intent.extras['album']}';
      case IntentName.playSong:
        return 'playing ${intent.extras['song']}';
      case IntentName.playRadio:
        return 'playing ${intent.extras['station']}';
      case IntentName.playSearch:
        return 'playing';
      case IntentName.playerPlay:
        return 'playing';
      case IntentName.playerPause:
        return 'pausing';
      case IntentName.playerNext:
        return 'next';
      case IntentName.volume:
        return 'volume ${intent.extras['volume']}';
      case IntentName.volumeUp:
        return 'volume up';
      case IntentName.volumeDown:
        return 'volume down';
      case IntentName.torchOn:
        return 'light on';
      case IntentName.torchOff:
        return 'light off';
      default:
        return 'TODO'; // TODO
    }
  }

  List<IntentModel> get intents => [
        IntentModel(
          name: IntentName.playArtistSongs,
          // play songs by [artist]
          // play [artist] songs
          keywords: ['play', 'by', 'songs'],
          required: ['play', 'songs'],
          regexps: [
            RegExp(r'^play songs by (?<artist>[\w ]+)$'),
            RegExp(r'^play (?<artist>[\w ]+) songs$'),
          ],
        ),
        IntentModel(
          name: IntentName.playArtistSongs,
          // play tracks by [artist]
          // play [artist] tracks
          keywords: ['play', 'by', 'tracks'],
          required: ['play', 'tracks'],
          regexps: [
            RegExp(r'^play tracks by (?<artist>[\w ]+)$'),
            RegExp(r'^play (?<artist>[\w ]+) tracks$'),
          ],
        ),
        IntentModel(
          name: IntentName.playArtistRadio,
          // play [artist] mix
          keywords: ['play', 'mix'],
          required: ['play', 'mix'],
          regexps: [
            RegExp(r'^play (?<artist>[\w ]+) mix$'),
          ],
        ),
        IntentModel(
          name: IntentName.playArtistPopularSongs,
          // play popular songs by [artist]
          // play [artist] popular songs
          keywords: ['play', 'by', 'songs', 'popular'],
          required: ['play', 'popular'],
          regexps: [
            RegExp(r'^play popular songs by (?<artist>[\w ]+)$'),
            RegExp(r'^play (?<artist>[\w ]+) popular( songs)?$'),
          ],
        ),
        IntentModel(
          name: IntentName.playAlbum,
          // play album [album]
          keywords: ['play', 'album'],
          required: ['play', 'album'],
          regexps: [
            RegExp(r'^play album (?<album>[\w ]+)$'),
          ],
        ),
        IntentModel(
          name: IntentName.playArtistAlbum,
          // play album [album] by [artist]
          keywords: ['play', 'album', 'by'],
          required: ['play', 'album', 'by'],
          regexps: [
            RegExp(r'^play album (?<album>[\w ]+) by (?<artist>[\w ]+)$'),
          ],
        ),
        IntentModel(
          name: IntentName.playSong,
          // play song [song]
          keywords: ['play', 'song'],
          required: ['play', 'song'],
          regexps: [
            RegExp(r'^play song (?<song>[\w ]+)$'),
          ],
        ),
        IntentModel(
          name: IntentName.playArtistSong,
          // play song [song] by [artist]
          keywords: ['play', 'song', 'by'],
          required: ['play', 'song', 'by'],
          regexps: [
            RegExp(r'^play song (?<song>[\w ]+) by (?<artist>[\w ]+)$'),
          ],
        ),
        IntentModel(
          name: IntentName.playRadio,
          // play [station] station
          keywords: ['play', 'station'],
          required: ['play', 'station'],
          regexps: [
            RegExp(r'^play (?<station>[\w ]+) station'),
            RegExp(r'^play station (?<station>[\w ]+)$'),
          ],
        ),
        IntentModel(
          name: IntentName.playSearch,
          // play [q]
          keywords: ['play'],
          required: ['play'],
          regexps: [
            RegExp(r'^play (?<q>[\w ]+)$'),
          ],
        ),
        IntentModel(
          name: IntentName.playMovie,
          // watch movie [title]
          // watch
          keywords: ['watch', 'movie'],
          required: ['watch'],
          regexps: [
            RegExp(r'^watch (movie )?(?<title>[\w ]+)$'),
          ],
        ),
        IntentModel(
          name: IntentName.playMovie,
          // show movie [title]
          // show
          keywords: ['show', 'movie'],
          required: ['show'],
          regexps: [
            RegExp(r'^show (movie )?(?<title>[\w ]+)$'),
          ],
        ),
        IntentModel(
          name: IntentName.playMovie,
          // play movie [title]
          keywords: ['play', 'movie'],
          required: ['play', 'movie'],
          regexps: [
            RegExp(r'^play movie (?<title>[\w ]+)$'),
          ],
        ),
        //
        // keep torch/flash stuff above lights
        //
        IntentModel(
          name: IntentName.torchOn,
          keywords: ['turn', 'torch', 'on'],
          required: ['torch', 'on'],
        ),
        IntentModel(
          name: IntentName.torchOn,
          keywords: ['turn', 'flash', 'on'],
          required: ['flash', 'on'],
        ),
        IntentModel(
          name: IntentName.torchOff,
          keywords: ['turn', 'torch', 'off'],
          required: ['torch', 'off'],
        ),
        IntentModel(
          name: IntentName.torchOff,
          keywords: ['turn', 'flash', 'off'],
          required: ['flash', 'off'],
        ),
        IntentModel(
          name: IntentName.turnOnAllLights,
          // turn on all the lights
          keywords: ['turn', 'on', 'all', 'lights'],
          required: ['on', 'lights'],
        ),
        IntentModel(
          name: IntentName.turnOnLight,
          // turn on the light
          // turn on the [light]
          // turn on the [light] light
          keywords: ['turn', 'on', 'the', 'light'],
          required: ['on'],
          regexps: [
            RegExp(r'^turn on (the )?light$'),
            RegExp(r'^(turn )?light on$'),
            RegExp(r'^turn on the (?<light>[\w ]+) light$'),
            RegExp(r'^turn on the (?<light>[\w ]+)$'),
          ],
        ),
        IntentModel(
          name: IntentName.turnOffAllLights,
          // turn off the lights
          // turn off all the lights
          keywords: ['turn', 'off', 'all', 'lights'],
          required: ['off', 'lights'],
        ),
        IntentModel(
          name: IntentName.turnOffLight,
          // turn off the light
          // turn off the [light]
          // turn off the [light] light
          keywords: ['turn', 'off', 'the', 'light'],
          required: ['off'],
          regexps: [
            RegExp(r'^turn off (the )?light$'),
            RegExp(r'^(turn )?light off$'),
            RegExp(r'^turn off the (?<light>[\w ]+) light?$'),
            RegExp(r'^turn off the (?<light>[\w ]+)?$'),
          ],
        ),
        IntentModel(
          name: IntentName.setLightBrightness,
          // set [light] brightness to [brightness]
          keywords: ['set', 'brightness', 'to'],
          required: ['brightness'],
          regexps: [
            RegExp(r'^(set )?brightness (to )?(?<brightness>[\w ]+)$'),
            RegExp(
                r'^(set )?(?<light>[\w ]+) brightness (to )?(?<brightness>[\w ]+)$'),
          ],
          callback: (extras) {
            final v = _brightness(extras['brightness']);
            if (v != null) {
              extras['brightness_value'] = v;
            }
          },
        ),
        IntentModel(
          name: IntentName.setLightColor,
          // set [light] color to [color]
          // color [color]
          keywords: ['set', 'color', 'to'],
          required: ['color'],
          regexps: [
            RegExp(r'^(set )?color (to )?(?<color>[\w ]+)$'),
            RegExp(r'^(set )?(?<light>[\w ]+) color (to )?(?<color>[\w ]+)$'),
          ],
          callback: (extras) {
            final v = _color(extras['color']);
            if (v != null) {
              extras['color_value'] = v;
            }
          },
        ),
        IntentModel(
          name: IntentName.playerPlay,
          keywords: ['resume'],
          required: ['resume'],
        ),
        IntentModel(
          name: IntentName.playerPause,
          keywords: ['pause'],
          required: ['pause'],
        ),
        IntentModel(
          name: IntentName.playerNext,
          keywords: ['next'],
          required: ['next'],
        ),
        IntentModel(
          name: IntentName.volumeUp,
          keywords: ['turn', 'it', 'up'],
          required: ['turn', 'it', 'up'],
        ),
        IntentModel(
          name: IntentName.volumeDown,
          keywords: ['turn', 'it', 'down'],
          required: ['turn', 'it', 'down'],
        ),
        IntentModel(
          name: IntentName.volume,
          keywords: ['volume'],
          required: ['volume'],
          regexps: [
            RegExp(r'^(set )?volume (to )?(?<volume>[\w ]+)$'),
          ],
          callback: (extras) {
            final v = _volume(extras['volume']);
            if (v != null) {
              extras['scaled_volume'] = v;
            }
          },
        ),
        IntentModel(
          name: IntentName.setAlarm,
          keywords: ['set', 'alarm'],
          required: ['set', 'alarm'],
          regexps: [
            RegExp(r'^set (an )?alarm (for )?(?<time>[\w ]+)$'),
          ],
          callback: (extras) {
            final t = _time(extras['time']);
            if (t != null) {
              extras['hour'] = t.hour;
              extras['minutes'] = t.minute;
            }
          },
        ),
        IntentModel(
          name: IntentName.dismissAlarm,
          keywords: ['dismiss', 'alarm'],
          required: ['dismiss', 'alarm'],
        ),
        IntentModel(
          name: IntentName.setTimer,
          keywords: ['set', 'timer'],
          required: ['set', 'timer'],
          regexps: [
            RegExp(r'^set (a )?timer (for )?(?<duration>[\w ]+)$'),
          ],
          callback: (extras) {
            final d = _duration(extras['duration']);
            if (d != null) {
              extras['seconds'] = d.inSeconds;
            }
          },
        ),
        IntentModel(
          name: IntentName.dismissTimer,
          keywords: ['dismiss', 'timer'],
          required: ['dismiss', 'timer'],
        ),
      ];
}
