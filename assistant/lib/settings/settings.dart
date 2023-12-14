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

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import 'model.dart';

part 'settings.g.dart';

@JsonSerializable()
class SettingsState {
  final Settings settings;

  SettingsState(this.settings);

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsStateToJson(this);
}

class SettingsCubit extends HydratedCubit<SettingsState> {
  SettingsCubit() : super(SettingsState(Settings.initial()));

  void add({
    List<String>? wakeWords,
  }) =>
      emit(SettingsState(state.settings.copyWith(
        wakeWords: wakeWords,
      )));

  set wakeWords(List<String> wakeWords) {
    emit(SettingsState(state.settings.copyWith(wakeWords: wakeWords)));
  }

  set use24HourClock(bool value) {
    emit(SettingsState(state.settings.copyWith(use24HourClock: value)));
  }

  @override
  SettingsState fromJson(Map<String, dynamic> json) =>
      SettingsState.fromJson(json['settings'] as Map<String, dynamic>);

  @override
  Map<String, dynamic>? toJson(SettingsState state) =>
      {'settings': state.toJson()};
}
