// Copyright 2023 defsub
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

import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

import 'model.dart';

part 'settings.g.dart';

@JsonSerializable()
class AssistantSettingsState {
  final AssistantSettings settings;

  AssistantSettingsState(this.settings);

  factory AssistantSettingsState.fromJson(Map<String, dynamic> json) =>
      _$AssistantSettingsStateFromJson(json);

  Map<String, dynamic> toJson() => _$AssistantSettingsStateToJson(this);
}

class AssistantSettingsCubit extends HydratedCubit<AssistantSettingsState> {
  AssistantSettingsCubit()
      : super(AssistantSettingsState(AssistantSettings.initial()));

  void add({
    List<String>? wakeWords,
  }) =>
      emit(AssistantSettingsState(state.settings.copyWith(
        wakeWords: wakeWords,
      )));

  set enableWakeWords(bool enabled) {
    emit(AssistantSettingsState(
        state.settings.copyWith(enableWakeWords: enabled)));
  }

  set enableSpeechRecognition(bool enabled) {
    emit(AssistantSettingsState(
        state.settings.copyWith(enableSpeechRecognition: enabled)));
  }

  void toggleSpeechRecognition() {
    emit(AssistantSettingsState(state.settings.copyWith(
        enableSpeechRecognition: !state.settings.enableSpeechRecognition)));
  }

  set wakeWords(List<String> wakeWords) {
    emit(AssistantSettingsState(state.settings.copyWith(wakeWords: wakeWords)));
  }

  set use24HourClock(bool value) {
    emit(
        AssistantSettingsState(state.settings.copyWith(use24HourClock: value)));
  }

  set language(String language) {
    emit(AssistantSettingsState(state.settings.copyWith(language: language)));
  }

  set displayType(DisplayType displayType) {
    emit(AssistantSettingsState(
        state.settings.copyWith(displayType: displayType)));
  }

  set homeRoom(String homeRoom) {
    emit(AssistantSettingsState(state.settings.copyWith(homeRoom: homeRoom)));
  }

  set enableMusicZone(bool enabled) {
    emit(AssistantSettingsState(
        state.settings.copyWith(enableMusicZone: enabled)));
  }

  set musicZone(String musicZone) {
    emit(AssistantSettingsState(state.settings.copyWith(musicZone: musicZone)));
  }

  set bridgeAddress(String? address) {
    emit(AssistantSettingsState(
        state.settings.copyWith(bridgeAddress: address)));
  }

  set showPlayer(bool enabled) {
    emit(AssistantSettingsState(state.settings.copyWith(showPlayer: enabled)));
  }

  @override
  AssistantSettingsState fromJson(Map<String, dynamic> json) =>
      AssistantSettingsState.fromJson(json['settings'] as Map<String, dynamic>);

  @override
  Map<String, dynamic>? toJson(AssistantSettingsState state) =>
      {'settings': state.toJson()};
}
