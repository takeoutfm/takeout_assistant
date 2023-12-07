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

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nowplaying/nowplaying.dart';

class PlayingState {
  final String? album;
  final String? artist;
  final String? title;
  final String? source;
  final Duration position;
  final Duration? duration;
  final bool playing;

  PlayingState(
      {this.album,
      this.artist,
      this.title,
      this.source,
      this.playing = true,
      this.position = Duration.zero,
      this.duration});

  factory PlayingState.initial() {
    return PlayingState(playing: false);
  }
}

class PlayingCubit extends Cubit<PlayingState> {
  final PlayingRepository repository;
  StreamSubscription<NowPlayingTrack>? _subscription;

  PlayingCubit(this.repository) : super(PlayingState.initial()) {
    _init();
  }

  void _init() async {
    await repository.start();
    repository.stream.listen((event) {
      _emit(event);
    });
  }

  void _emit(NowPlayingTrack track) {
    emit(PlayingState(
      artist: track.artist,
      album: track.album,
      title: track.title,
      source: track.source,
      position: track.position,
      duration: track.duration,
      playing: track.state == NowPlayingState.playing,
    ));
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

class PlayingRepository {
  StreamSubscription<NowPlayingTrack>? _subscription;
  NowPlayingTrack? _track;
  NowPlaying _nowPlaying;

  PlayingRepository() : _nowPlaying = NowPlaying.instance {
    start();
  }

  Future<void> start() async {
    bool result = await NowPlaying.instance.requestPermissions();
    if (result) {
      await _nowPlaying.start();
      dispose();
      _subscription = stream.listen((track) {
        _track = track;
        print('repo got $track');
      });
    }
  }

  void stop() {
    _nowPlaying.stop();
  }

  void dispose() {
    _subscription?.cancel();
  }

  Stream<NowPlayingTrack> get stream => _nowPlaying.stream;

  NowPlayingTrack? get track => _track;
}
