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

import 'package:assistant/intent/model.dart';
import 'package:assistant/language/model_en.dart';

abstract class SpeechModel {
  String get language;

  List<IntentModel> get intents;

  String? describe(Intent intent);
}

class SpeechModels {
  final _models = <String, SpeechModel>{};

  SpeechModels() {
    final list = [
      EnglishModel(),
    ];
    for (var l in list) {
      register(l);
    }
  }

  void register(SpeechModel model) {
    _models[model.language] = model;
  }

  String? describe(String language, Intent intent) {
    return _models[language]?.describe(intent);
  }

  Intent? match(String language, String phrase) {
    IntentModel? intent;
    final model = _models[language];
    if (model == null) {
      return null;
    }
    var best = 0;
    for (var i in model.intents) {
      final score = i.match(phrase);
      if (score > best) {
        best = score;
        intent = i;
      }
    }
    return intent?.toIntent(phrase);
  }
}
