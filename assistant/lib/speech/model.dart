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

import 'package:assistant/intent/model.dart';
import 'package:assistant/language/model_en.dart';

abstract class SpeechModel {
  String get language;

  List<IntentModel> get intents;

  String? describe(Intent intent);
}

class Prompt {
  final DateTime dateTime;
  final String text;
  List<String>? _words;

  Prompt(this.dateTime, this.text);

  factory Prompt.text(String text) => Prompt(DateTime.now(), text);

  List<String> get words {
    _words ??= text.split(' ');
    return _words ?? [];
  }

  int hits(List<String> keywords) {
    var count = 0;
    for (var w in words) {
      w = w.toLowerCase();
      if (keywords.contains(w)) {
        count++;
      }
    }
    return count;
  }
}

class LearnedPrompts {
  final prompts = <String, IntentName>{};

  void add(IntentName intentName, Prompt prompt) {
    print('learning $intentName -> ${prompt.text}');
    prompts[prompt.text] = intentName;
  }

  IntentName? tryPrompt(Prompt prompt) {
    return prompts[prompt.text];
  }
}

class SpeechModels {
  final _models = <String, SpeechModel>{};
  final _unmatched = <Prompt>[];
  final _learning = LearnedPrompts();

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

  Intent? match(String language, String prompt) {
    IntentModel? intent;
    final model = _models[language];
    if (model == null) {
      return null;
    }
    var best = 0;
    for (var i in model.intents) {
      final score = i.match(prompt);
      if (score > best) {
        best = score;
        intent = i;
      }
    }
    if (intent != null) {
      print('matched ${intent.name} -> $prompt');
      // in progress adaptive learning code
      // final check = DateTime.now().subtract(Duration(seconds: 15));
      // for (var p in _unmatched) {
      //   if (p.dateTime.isAfter(check)) {
      //     var required = p.hits(intent.required);
      //     print('learn $required - ${intent.name} ${p.text}');
      //     if (required == intent.required.length) {
      //       bool add = false;
      //       var keywords = p.hits(intent.keywords);
      //       if (intent.keywords.length > intent.required.length &&
      //           keywords > required) {
      //         add = true;
      //       } //else if (keywords )
      //       // _learning.add(intent.name, p);
      //     }
      //   }
      // }
    }
    // else {
    //   _expire(Duration(minutes: 5));
    //   final p = Prompt.text(prompt);
    //   _unmatched.add(p);
    //   final intentName = _learning.tryPrompt(p);
    //   if (intentName != null) {
    //     for (var i in model.intents) {
    //       if (i.name == intentName) {
    //         print('trying $intentName with $i');
    //         intent = i;
    //         break;
    //       }
    //     }
    //   }
    // }
    return intent?.toIntent(prompt);
  }

  void _expire(Duration age) {
    final expiration = DateTime.now().subtract(age);
    _unmatched.removeWhere((p) => p.dateTime.isBefore(expiration));
  }
}
