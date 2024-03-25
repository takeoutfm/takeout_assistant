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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:takeout_lib/art/cover.dart';
import 'package:takeout_lib/player/player.dart';

class PlayerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.watch<Player>().state;
    if (state is PlayerInit || state is PlayerReady || state is PlayerStop) {
      return const SizedBox.shrink();
    }

    final title = state.currentTrack?.title ?? '';
    final creator = state.currentTrack?.creator ?? '';
    final image = state.currentTrack?.image ?? '';
    double? position = null;
    bool showPosition = false;
    if (state is PlayerPositionState) {
      showPosition = true;
      if (state.buffering == false) {
        position = state.progress;
      }
    } else if (state is PlayerLoad) {
      if (state.buffering) {
        showPosition = true;
      }
    }
    if (state.spiff.isStream()) {
      showPosition = false;
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ListTile(
            leading: image.isNotEmpty ? tileCover(context, image) : null,
            title: title.isNotEmpty ? Text(title) : null,
            subtitle: creator.isNotEmpty ? Text(creator) : null,
          ),
          if (showPosition) LinearProgressIndicator(value: position),
        ]);
  }
}
