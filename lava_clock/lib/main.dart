// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:lava_clock/custom_customizer.dart';
import 'package:lava_clock/frame.dart';
import 'package:flutter/services.dart';

import 'lava_clock.dart';
import 'model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  // await AppBloc.initStorage();
  // runApp(const App());

  //
  // runApp(CustomClockCustomizer((ClockModel model) =>
  //     ClockFrame(
  //         child: (controller) =>
  //             LavaClock(model, animationController: controller))));

  // Run without frame
  // runApp( CustomClockCustomizer((ClockModel model) => LavaClock(model)));
}

// class App extends StatelessWidget {
//   const App({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return AppBloc().init(context,
//         child: CustomClockCustomizer((ClockModel model) => ClockFrame(
//             child: (controller) =>
//                 LavaClock(model, animationController: controller))));
//   }
// }
