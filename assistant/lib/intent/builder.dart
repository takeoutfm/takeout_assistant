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
import 'android.dart';

abstract class AndroidActionBuilder {
  AndroidAction? build(Intent intent);
}

class AlarmIntentBuilder implements AndroidActionBuilder {
  @override
  AndroidAction? build(Intent intent) {
    return switch (intent.name) {
      IntentName.setAlarm => AndroidAction(
          AndroidAction.setAlarm,
          extras: [
            AndroidExtra(AndroidExtra.alarmHour, intent[Extra.hour]),
            AndroidExtra(AndroidExtra.alarmMinutes, intent[Extra.minutes]),
          ],
        ),
      IntentName.dismissAlarm => AndroidAction(AndroidAction.dismissAlarm,
            extras: [
              AndroidExtra(
                  AndroidExtra.alarmSearchMode, AndroidExtra.searchModeNext)
            ]),
      _ => null
    };
  }
}

class TimerIntentBuilder implements AndroidActionBuilder {
  @override
  AndroidAction? build(Intent intent) {
    return switch (intent.name) {
      IntentName.setTimer => AndroidAction(
          AndroidAction.setTimer,
          extras: [
            AndroidExtra(AndroidExtra.alarmLength, intent[Extra.seconds]),
            AndroidExtra(AndroidExtra.alarmMessage, 'Takeout Assistant'),
          ],
        ),
      IntentName.dismissTimer =>
        AndroidAction(AndroidAction.dismissTimer, extras: [
          // AndroidExtra(AndroidExtra.alarmMessage, 'Takeout Assistant'),
          AndroidExtra(
              AndroidExtra.alarmSearchMode, AndroidExtra.searchModeNext)
        ]),
      _ => null
    };
  }
}

class TakeoutIntentBuilder implements AndroidActionBuilder {
  @override
  AndroidAction? build(Intent intent) {
    return switch (intent.name) {
      IntentName.playArtistSongs => AndroidAction(AndroidAction.playArtistSongs,
          extras: [AndroidExtra(AndroidExtra.artist, intent[Extra.artist])]),
      IntentName.playArtistSong =>
        AndroidAction(AndroidAction.playArtistSong, extras: [
          AndroidExtra(AndroidExtra.artist, intent[Extra.artist]),
          AndroidExtra(AndroidExtra.song, intent[Extra.song]),
        ]),
      IntentName.playArtistRadio => AndroidAction(AndroidAction.playArtistRadio,
          extras: [AndroidExtra(AndroidExtra.artist, intent[Extra.artist])]),
      IntentName.playArtistPopularSongs => AndroidAction(
          AndroidAction.playArtistPopularSongs,
          extras: [AndroidExtra(AndroidExtra.artist, intent[Extra.artist])]),
      IntentName.playArtistAlbum =>
        AndroidAction(AndroidAction.playArtistAlbum, extras: [
          AndroidExtra(AndroidExtra.artist, intent[Extra.artist]),
          AndroidExtra(AndroidExtra.album, intent[Extra.album])
        ]),
      IntentName.playSong => AndroidAction(AndroidAction.playSong,
          extras: [AndroidExtra(AndroidExtra.song, intent[Extra.song])]),
      IntentName.playAlbum => AndroidAction(AndroidAction.playAlbum,
          extras: [AndroidExtra(AndroidExtra.album, intent[Extra.album])]),
      IntentName.playRadio => AndroidAction(AndroidAction.playRadio,
          extras: [AndroidExtra(AndroidExtra.station, intent[Extra.station])]),
      IntentName.playSearch => AndroidAction(AndroidAction.playSearch,
          extras: [AndroidExtra(AndroidExtra.query, intent[Extra.query])]),
      IntentName.playerPlay => AndroidAction(AndroidAction.playerPlay),
      IntentName.playerPause => AndroidAction(AndroidAction.playerPause),
      IntentName.playerNext => AndroidAction(AndroidAction.playerNext),
      IntentName.playMovie => AndroidAction(AndroidAction.playMovie,
          extras: [AndroidExtra(AndroidExtra.title, intent[Extra.title])]),
      _ => null
    };
  }
}
