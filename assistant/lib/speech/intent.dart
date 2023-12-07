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

import 'intent_en.dart';

class Intent {
  static const play_artist_songs = 'play_artist_songs';
  static const play_artist_song = 'play_artist_song';
  static const play_artist_radio = 'play_artist_radio';
  static const play_artist_popular_songs = 'play_artist_popular_songs';
  static const play_artist_album = 'play_artist_album';
  static const play_song = 'play_song';
  static const play_album = 'play_album';
  static const player_play = 'player_play';
  static const player_pause = 'player_pause';
  static const player_next = 'player_next';
  static const torch_on = 'torch_on';
  static const torch_off = 'torch_off';

  final String name;
  final Map<String, String> fields;

  Intent(this.name, this.fields);
}

class IntentModel {
  final String name;
  final List<String> fields;
  final List<String> keywords;
  final List<String> required;
  final List<RegExp> regexps;

  IntentModel({
    required this.name,
    this.fields = const [],
    required this.keywords,
    required this.required,
    required this.regexps,
  });
}

abstract class IntentLanguage {
  String get language;

  List<IntentModel> get intents;
}

class SpeechIntents {
  final _intents = <String, List<IntentModel>>{};

  SpeechIntents() {
    register(EnglishIntents());
  }

  void register(IntentLanguage lang) {
    _intents[lang.language] = lang.intents;
  }

  Map<String, String> extract(String phrase, RegExp regex) {
    final result = <String, String>{};
    final matches = regex.allMatches(phrase);
    for (var m in matches) {
      for (var g = 1; g < m.groupCount; g++) {
        for (var n in m.groupNames) {
          final value = m.namedGroup(n);
          if (value != null) {
            result[n] = value;
          }
        }
      }
    }
    return result;
  }

  bool matches(String phrase, RegExp regexp) {
    return regexp.hasMatch(phrase);
  }

  Intent? match(String language, String phrase) {
    Intent? result;
    final intents = _intents[language];
    if (intents == null) {
      return result;
    }
    final words = phrase.split(' ');
    for (var i in intents) {
      var hits = 0;
      var required = 0;
      for (var w in words) {
        w = w.toLowerCase();
        if (i.keywords.contains(w)) {
          hits++;
        }
        if (i.required.contains(w)) {
          required++;
        }
      }
      // print('$hits $required - ${i.name}');
      var best = 0;
      if (required == i.required.length) {
        for (var r in i.regexps) {
          if (i.fields.length > 0) {
            final fields = extract(phrase, r);
            if (fields.isNotEmpty) {
              if (hits > best) {
                best = hits;
                result = Intent(i.name, fields);
                // print('hits $best - ${i.name} $fields');
              }
            }
          } else if (matches(phrase, r)) {
            result = Intent(i.name, {});
            // print('match - ${i.name}');
          }
        }
      }
    }
    return result;
  }
}

