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

import 'package:flutter/material.dart';

import 'battery.dart';

Icon batteryIcon(BatteryState state) {
  if (state.chargingState == ChargingState.full) {
    return Icon(Icons.battery_full);
  }
  if (state.chargingState == ChargingState.charging) {
    return Icon(Icons.battery_charging_full);
  }
  if (state.chargingState == ChargingState.discharging) {
    // levels - 20, 30, 50, 60, 80, 90%.
    return switch (state.batteryLevel) {
      == 100 => Icon(Icons.battery_full),
      >= 90 && <= 99 => Icon(Icons.battery_6_bar),
      >= 80 && <= 89 => Icon(Icons.battery_5_bar),
      >= 60 && <= 79 => Icon(Icons.battery_4_bar),
      >= 50 && <= 59 => Icon(Icons.battery_3_bar),
      >= 30 && <= 49 => Icon(Icons.battery_2_bar),
      >= 20 && <= 29 => Icon(Icons.battery_1_bar),
      _ => Icon(Icons.battery_alert)
    };
  }
  // ChargingState.connectedNotCharging
  return Icon(Icons.battery_unknown);
}
