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

import 'intent.dart';

class EnglishIntents extends IntentLanguage {
  String get language => 'en';

  List<IntentModel> get intents => [
        IntentModel(
          name: Intent.play_artist_songs,
          fields: ['artist'],
          // play songs by [artist]
          // play [artist] songs
          keywords: ['play', 'by', 'songs'],
          required: ['play', 'songs'],
          regexps: [
            RegExp(r'^play songs by ((?<artist>[\w ]+))$'),
            RegExp(r'^play ((?<artist>[\w ]+)) songs$'),
          ],
        ),
        IntentModel(
          name: Intent.play_artist_songs,
          fields: ['artist'],
          // play tracks by [artist]
          // play [artist] tracks
          keywords: ['play', 'by', 'tracks'],
          required: ['play', 'tracks'],
          regexps: [
            RegExp(r'^play tracks by ((?<artist>[\w ]+))$'),
            RegExp(r'^play ((?<artist>[\w ]+)) tracks$'),
          ],
        ),
        IntentModel(
          name: Intent.play_artist_radio,
          fields: ['artist'],
          // play [artist] radio
          keywords: ['play', 'radio'],
          required: ['play', 'radio'],
          regexps: [
            RegExp(r'^play ((?<artist>[\w ]+)) radio$'),
          ],
        ),
        IntentModel(
          name: Intent.play_artist_popular_songs,
          fields: ['artist'],
          // play popular songs by [artist]
          // play [artist] popular songs
          keywords: ['play', 'by', 'songs', 'popular'],
          required: ['play', 'popular'],
          regexps: [
            RegExp(r'^play popular songs by ((?<artist>[\w ]+))$'),
            RegExp(r'^play ((?<artist>[\w ]+)) popular( songs)?$'),
          ],
        ),
        IntentModel(
          name: Intent.play_album,
          fields: ['album'],
          // play album [album]
          keywords: ['play', 'album'],
          required: ['play', 'album'],
          regexps: [
            RegExp(r'^play album ((?<album>[\w ]+))$'),
          ],
        ),
        IntentModel(
          name: Intent.play_artist_album,
          fields: ['artist', 'album'],
          // play album [album] by [artist]
          keywords: ['play', 'album', 'by'],
          required: ['play', 'album', 'by'],
          regexps: [
            RegExp(r'^play album ((?<album>[\w ]+)) by ((?<artist>[\w ]+))$'),
          ],
        ),
        IntentModel(
          name: Intent.play_song,
          fields: ['song'],
          // play song [song]
          keywords: ['play', 'song'],
          required: ['play', 'song'],
          regexps: [
            RegExp(r'^play song ((?<song>[\w ]+))$'),
          ],
        ),
        IntentModel(
          name: Intent.play_artist_song,
          fields: ['artist', 'song'],
          // play song [song] by [artist]
          keywords: ['play', 'song', 'by'],
          required: ['play', 'song', 'by'],
          regexps: [
            RegExp(r'^play song ((?<song>[\w ]+)) by ((?<artist>[\w ]+))$'),
          ],
        ),
        IntentModel(
          name: 'play',
          fields: ['name'],
          // play [something]
          keywords: ['play'],
          required: ['play'],
          regexps: [RegExp(r'play foobar')],
        ),
        IntentModel(
          name: 'turn_on_all_lights',
          // turn on the lights
          // turn on all the lights
          keywords: ['turn', 'on', 'lights'],
          required: ['turn', 'on', 'lights'],
          regexps: [RegExp(r'^turn on (all )?the lights$')],
        ),
        IntentModel(
          name: 'turn_on_light',
          fields: ['light'],
          // turn on the [light] light
          keywords: ['turn', 'on', 'light'],
          required: ['turn', 'on', 'light'],
          regexps: [
            RegExp(r'^turn on the ((?<light>[\w ]+)) light$'),
          ],
        ),
        IntentModel(
          name: 'turn_off_all_lights',
          // turn off the lights
          // turn off all the lights
          keywords: ['turn', 'off', 'lights'],
          required: ['turn', 'off', 'lights'],
          regexps: [RegExp(r'^turn off (all )?the lights$')],
        ),
        IntentModel(
          name: 'turn_off_light',
          fields: ['light'],
          // turn off the [light] light
          keywords: ['turn', 'off', 'light'],
          required: ['turn', 'off', 'light'],
          regexps: [
            RegExp(r'^turn off the ((?<light>[\w ]+)) light$'),
          ],
        ),
        IntentModel(
          name: Intent.torch_on,
          keywords: ['torch', 'on'],
          required: ['torch', 'on'],
          regexps: [
            RegExp(r'^torch on$'),
            RegExp(r'^turn torch on$'),
            RegExp(r'^turn on (the )?torch$'),
          ],
        ),
        IntentModel(
          name: Intent.torch_on,
          keywords: ['flash', 'on'],
          required: ['flash', 'on'],
          regexps: [
            RegExp(r'^flash on$'),
            RegExp(r'^turn flash on$'),
            RegExp(r'^turn on (the )?flash$'),
          ],
        ),
        IntentModel(
          name: Intent.torch_off,
          keywords: ['torch', 'off'],
          required: ['torch', 'off'],
          regexps: [
            RegExp(r'^torch off$'),
            RegExp(r'^turn torch off$'),
            RegExp(r'^turn off (the )?torch$'),
          ],
        ),
        IntentModel(
          name: Intent.torch_off,
          keywords: ['flash', 'off'],
          required: ['flash', 'off'],
          regexps: [
            RegExp(r'^flash off$'),
            RegExp(r'^turn flash off$'),
            RegExp(r'^turn off (the )?flash$'),
          ],
        ),
        IntentModel(
          name: Intent.player_play,
          keywords: ['play'],
          required: ['play'],
          regexps: [
            RegExp(r'^play$'),
          ],
        ),
        IntentModel(
          name: Intent.player_pause,
          keywords: ['pause'],
          required: ['pause'],
          regexps: [
            RegExp(r'^pause$'),
          ],
        ),
        IntentModel(
          name: Intent.player_next,
          keywords: ['next'],
          required: ['next'],
          regexps: [
            RegExp(r'^next$'),
          ],
        ),
      ];
}
