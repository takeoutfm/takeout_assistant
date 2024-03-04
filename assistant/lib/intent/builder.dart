// Copyright 2024 defsub
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

import 'model.dart';
import 'android.dart';

abstract class AndroidActionBuilder {
  AndroidAction? build(Intent intent);
}

class AlarmIntentBuilder implements AndroidActionBuilder {
  @override
  AndroidAction? build(Intent intent) {
    switch (intent.name) {
      case IntentName.setAlarm:
        return AndroidAction(
          AndroidAction.setAlarm,
          extras: [
            AndroidExtra(AndroidExtra.alarmHour, intent.extras['hour']),
            AndroidExtra(AndroidExtra.alarmMinutes, intent.extras['minutes']),
          ],
        );
      case IntentName.dismissAlarm:
        return AndroidAction(AndroidAction.dismissAlarm, extras: [
          AndroidExtra(
              AndroidExtra.alarmSearchMode, AndroidExtra.searchModeNext)
        ]);
      default:
        return null;
    }
  }
}

class TimerIntentBuilder implements AndroidActionBuilder {
  @override
  AndroidAction? build(Intent intent) {
    switch (intent.name) {
      case IntentName.setTimer:
        return AndroidAction(
          AndroidAction.setTimer,
          extras: [
            AndroidExtra(AndroidExtra.alarmLength, intent.extras['seconds']),
            AndroidExtra(AndroidExtra.alarmMessage, 'Takeout Assistant'),
          ],
        );
      case IntentName.dismissTimer:
        return AndroidAction(AndroidAction.dismissTimer, extras: [
          // AndroidExtra(AndroidExtra.alarmMessage, 'Takeout Assistant'),
          AndroidExtra(
              AndroidExtra.alarmSearchMode, AndroidExtra.searchModeNext)
        ]);
      default:
        return null;
    }
  }
}

class TakeoutIntentBuilder implements AndroidActionBuilder {
  @override
  AndroidAction? build(Intent intent) {
    switch (intent.name) {
      case IntentName.playArtistSongs:
        return AndroidAction(AndroidAction.playArtistSongs, extras: [
          AndroidExtra(AndroidExtra.artist, intent.extras['artist'])
        ]);
      case IntentName.playArtistSong:
        return AndroidAction(AndroidAction.playArtistSong, extras: [
          AndroidExtra(AndroidExtra.artist, intent.extras['artist']),
          AndroidExtra(AndroidExtra.song, intent.extras['song'])
        ]);
      case IntentName.playArtistRadio:
        return AndroidAction(AndroidAction.playArtistRadio, extras: [
          AndroidExtra(AndroidExtra.artist, intent.extras['artist'])
        ]);
      case IntentName.playArtistPopularSongs:
        return AndroidAction(AndroidAction.playArtistPopularSongs, extras: [
          AndroidExtra(AndroidExtra.artist, intent.extras['artist'])
        ]);
      case IntentName.playArtistAlbum:
        return AndroidAction(AndroidAction.playArtistAlbum, extras: [
          AndroidExtra(AndroidExtra.artist, intent.extras['artist']),
          AndroidExtra(AndroidExtra.album, intent.extras['album'])
        ]);
      case IntentName.playSong:
        return AndroidAction(AndroidAction.playSong,
            extras: [AndroidExtra(AndroidExtra.song, intent.extras['song'])]);
      case IntentName.playAlbum:
        return AndroidAction(AndroidAction.playAlbum,
            extras: [AndroidExtra(AndroidExtra.album, intent.extras['album'])]);
      case IntentName.playRadio:
        return AndroidAction(AndroidAction.playRadio, extras: [
          AndroidExtra(AndroidExtra.station, intent.extras['station'])
        ]);
      case IntentName.playSearch:
        return AndroidAction(AndroidAction.playSearch,
            extras: [AndroidExtra(AndroidExtra.query, intent.extras['q'])]);
      case IntentName.playerPlay:
        return AndroidAction(AndroidAction.playerPlay);
      case IntentName.playerPause:
        return AndroidAction(AndroidAction.playerPause);
      case IntentName.playerNext:
        return AndroidAction(AndroidAction.playerNext);
      case IntentName.playMovie:
        return AndroidAction(AndroidAction.playMovie,
            extras: [AndroidExtra(AndroidExtra.title, intent.extras['title'])]);
      default:
        return null;
    }
  }
}
