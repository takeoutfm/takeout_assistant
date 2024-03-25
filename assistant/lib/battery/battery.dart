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

import 'dart:async';

import 'package:battery_plus/battery_plus.dart' as battery_plus;
import 'package:flutter_bloc/flutter_bloc.dart';

enum ChargingState {
  full,
  charging,
  connectedNotCharging,
  discharging,
  unknown;
}

class BatteryState {
  final ChargingState chargingState;
  final int batteryLevel;

  BatteryState(this.chargingState, this.batteryLevel);

  factory BatteryState.initial() {
    return BatteryState(ChargingState.unknown, 0);
  }

  BatteryState copyWith({ChargingState? chargingState, int? batteryLevel}) =>
      BatteryState(chargingState ?? this.chargingState,
          batteryLevel ?? this.batteryLevel);
}

class BatteryCubit extends Cubit<BatteryState> {
  final BatteryRepository repository;
  StreamSubscription<ChargingState>? _subscription;

  BatteryCubit(this.repository) : super(BatteryState.initial()) {
    _init();
  }

  void _init() {
    _subscription = repository.stream.listen((chargingState) async {
      final batteryLevel = await repository.batteryLevel;
      emit(state.copyWith(
          chargingState: chargingState, batteryLevel: batteryLevel));
    });
    _poll();
  }

  void _poll() {
    Future.delayed(Duration(minutes: 3), () async {
      final batterLevel = await repository.batteryLevel;
      if (batterLevel != state.batteryLevel) {
        emit(state.copyWith(batteryLevel: batterLevel));
      }
      _poll();
    });
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}

class BatteryRepository {
  final BatteryProvider _provider;
  StreamSubscription<ChargingState>? _subscription;
  ChargingState? _chargingState;

  BatteryRepository({BatteryProvider? provider})
      : _provider = provider ?? DefaultBatteryProvider() {
    _init(_provider.stream);
  }

  void _init(Stream<ChargingState> stream) {
    _subscription = stream.listen((state) {
      _chargingState = state;
    });
  }

  void dispose() {
    _subscription?.cancel();
  }

  Stream<ChargingState> get stream => _provider.stream;

  ChargingState? get chargingState => _chargingState;

  Future<int> get batteryLevel => _provider.batteryLevel;
}

abstract class BatteryProvider {
  Future<int> get batteryLevel;

  Stream<ChargingState> get stream;
}

class DefaultBatteryProvider extends BatteryProvider {
  final _battery = battery_plus.Battery();

  @override
  Future<int> get batteryLevel => _battery.batteryLevel;

  @override
  Stream<ChargingState> get stream =>
      _battery.onBatteryStateChanged.map((state) {
        return switch (state) {
          battery_plus.BatteryState.full => ChargingState.full,
          battery_plus.BatteryState.charging => ChargingState.charging,
          battery_plus.BatteryState.connectedNotCharging =>
            ChargingState.connectedNotCharging,
          battery_plus.BatteryState.discharging => ChargingState.discharging,
          battery_plus.BatteryState.unknown => ChargingState.unknown
        };
      });
}
