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

import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takeout_lib/spiff/model.dart';

const appVersion = '0.4.0'; // #version#
const appSource = 'https://github.com/takeoutfm/takeout_assistant';
const appHome = 'https://takeoutfm.com/';

class AppState {
  final bool authenticated;
  final Spiff? nowPlaying;
  final Color? backgroundColor;

  AppState(this.nowPlaying, this.authenticated, {this.backgroundColor});

  factory AppState.initial() => AppState(null, false);

  AppState copyWith(
          {Spiff? nowPlaying, bool? authenticated, Color? backgroundColor}) =>
      AppState(
          nowPlaying ?? this.nowPlaying, authenticated ?? this.authenticated,
          backgroundColor: backgroundColor ?? this.backgroundColor);
}

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppState.initial());

  set backgroundColor(Color color) =>
      emit(state.copyWith(backgroundColor: color));

  void authenticated() => emit(state.copyWith(authenticated: true));

  void logout() => emit(state.copyWith(authenticated: false));

  void nowPlaying(Spiff spiff) => emit(state.copyWith(nowPlaying: spiff));
}
