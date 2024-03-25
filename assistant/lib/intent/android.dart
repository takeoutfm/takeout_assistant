// Copyright 2024 defsub
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

import 'model.dart';
import 'builder.dart';

class AndroidAction {
  // takeout
  static final playArtistSongs = 'com.takeoutfm.action.PLAY_ARTIST';
  static final playArtistSong = 'com.takeoutfm.action.PLAY_ARTIST_SONG';
  static final playArtistAlbum = 'com.takeoutfm.action.PLAY_ARTIST_ALBUM';
  static final playArtistRadio = 'com.takeoutfm.action.PLAY_ARTIST_RADIO';
  static final playArtistPopularSongs =
      'com.takeoutfm.action.PLAY_ARTIST_POPULAR_SONGS';
  static final playAlbum = 'com.takeoutfm.action.PLAY_ALBUM';
  static final playSong = 'com.takeoutfm.action.PLAY_SONG';
  static final playRadio = 'com.takeoutfm.action.PLAY_RADIO';
  static final playSearch = 'com.takeoutfm.action.PLAY_SEARCH';
  static final playerPlay = 'com.takeoutfm.action.PLAYER_PLAY';
  static final playerPause = 'com.takeoutfm.action.PLAYER_PAUSE';
  static final playerNext = 'com.takeoutfm.action.PLAYER_NEXT';
  static final playMovie = 'com.takeoutfm.action.PLAY_MOVIE';

  // alarm clock
  static final dismissAlarm = 'android.intent.action.DISMISS_ALARM';
  static final dismissTimer = 'android.intent.action.DISMISS_TIMER';
  static final setAlarm = 'android.intent.action.SET_ALARM';
  static final setTimer = 'android.intent.action.SET_TIMER';

  static final _builders = <AndroidActionBuilder>[
    // TakeoutIntentBuilder(),
    AlarmIntentBuilder(),
    TimerIntentBuilder(),
  ];

  final String name;
  final List<AndroidExtra>? extras;

  AndroidAction(this.name, {this.extras});

  Map<String, dynamic>? extrasMap() {
    final list = extras;
    if (list == null) {
      return null;
    }
    final map = <String, dynamic>{};
    for (var e in list) {
      map[e.name] = e.value;
    }
    return map;
  }

  static AndroidAction? build(Intent intent) {
    AndroidAction? action;
    for (var b in _builders) {
      action = b.build(intent);
      if (action != null) {
        break;
      }
    }
    return action;
  }
}

class AndroidExtra {
  // takeout
  static final artist = 'artist';
  static final album = 'album';
  static final song = 'song';
  static final station = 'station';
  static final query = 'q';
  static final title = 'title';

  // alarm clock
  static final alarmHour = 'android.intent.extra.alarm.HOUR';
  static final alarmMinutes = 'android.intent.extra.alarm.MINUTES';
  static final alarmLength = 'android.intent.extra.alarm.LENGTH';
  static final alarmMessage = 'android.intent.extra.alarm.MESSAGE';
  static final alarmSearchMode = 'android.intent.extra.alarm.SEARCH_MODE';

  // search mode
  static final searchModeLabel = 'android.label';
  static final searchModeNext = 'android.next';

  final String name;
  final dynamic value;

  AndroidExtra(this.name, this.value);
}
