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

import 'package:picovoice_flutter/picovoice.dart';
import 'package:picovoice_flutter/picovoice_error.dart';
import 'package:picovoice_flutter/picovoice_manager.dart';
import 'package:porcupine_flutter/porcupine.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:cheetah_flutter/cheetah.dart';
import 'package:cheetah_flutter/cheetah_error.dart';
import 'package:flutter_voice_processor/flutter_voice_processor.dart';
import 'package:flutter/services.dart';

import 'speech.dart';

class PicovoiceSpeechProvider implements SpeechProvider {
  // PorcupineManager? porcupine;
  CheetahManager? cheetah;

  StreamController<SpeechEvent> _streamController =
      StreamController.broadcast();

  static const accessKey = '';

  void init() async {
    try {
      // porcupine = await PorcupineManager.fromBuiltInKeywords(
      //   accessKey,
      //   [BuiltInKeyword.ALEXA, BuiltInKeyword.COMPUTER],
      //   onWakeWord,
      // );

      String modelPath = "assets/models/cheetah_params.pv";
      cheetah = await CheetahManager.create(
          accessKey, modelPath, onTranscription, onCheetahError);

      start();
    } catch (e, stack) {
      print(e);
      print(stack);
    }
  }

  void onWakeWord(int index) {
    _streamController.add(WakeWordEvent());
  }

  void onTranscription(String text) {
    if (text.isNotEmpty) {
      print('cheetah $text');
    }
  }

  void onCheetahError(CheetahException e) {
    print('cheetah error $e');
  }

  @override
  Stream<SpeechEvent> get stream => _streamController.stream;

  @override
  void start() {
    cheetah?.startProcess();
  }

  @override
  void stop() {
    cheetah?.stopProcess();
  }

  @override
  void pause() {}

  @override
  void resume() {}
}

typedef TranscriptCallback = Function(String transcript);

typedef ProcessErrorCallback = Function(CheetahException error);

class CheetahManager {
  VoiceProcessor? _voiceProcessor;
  Cheetah? _cheetah;

  final TranscriptCallback _transcriptCallback;

  static Future<CheetahManager> create(
      String accessKey,
      String modelPath,
      TranscriptCallback transcriptCallback,
      ProcessErrorCallback processErrorCallback) async {
    Cheetah cheetah = await Cheetah.create(accessKey, modelPath,
        enableAutomaticPunctuation: true);
    return CheetahManager._(cheetah, transcriptCallback, processErrorCallback);
  }

  CheetahManager._(this._cheetah, this._transcriptCallback,
      ProcessErrorCallback processErrorCallback)
      : _voiceProcessor = VoiceProcessor.instance {
    _voiceProcessor?.addFrameListener((List<int> frame) async {
      if (!(await _voiceProcessor?.isRecording() ?? false)) {
        return;
      }
      if (_cheetah == null) {
        processErrorCallback(CheetahInvalidStateException(
            "Cannot process with Cheetah - resources have already been released"));
        return;
      }

      try {
        CheetahTranscript partialResult = await _cheetah!.process(frame);

        if (partialResult.isEndpoint) {
          CheetahTranscript remainingResult = await _cheetah!.flush();
          String finalTranscript =
              partialResult.transcript + remainingResult.transcript;
          if (remainingResult.transcript.isNotEmpty) {
            finalTranscript += " ";
          }
          _transcriptCallback(finalTranscript);
        } else {
          _transcriptCallback(partialResult.transcript);
        }
      } on CheetahException catch (error) {
        processErrorCallback(error);
      }
    });

    _voiceProcessor?.addErrorListener((VoiceProcessorException error) {
      processErrorCallback(CheetahException(error.message));
    });
  }

  Future<void> startProcess() async {
    if (await _voiceProcessor?.isRecording() ?? false) {
      return;
    }

    if (_cheetah == null || _voiceProcessor == null) {
      throw CheetahInvalidStateException(
          "Cannot start Cheetah - resources have already been released");
    }

    if (await _voiceProcessor?.hasRecordAudioPermission() ?? false) {
      try {
        await _voiceProcessor?.start(
            _cheetah!.frameLength, _cheetah!.sampleRate);
      } on PlatformException catch (e) {
        throw CheetahRuntimeException(
            "Failed to start audio recording: ${e.message}");
      }
    } else {
      throw CheetahRuntimeException(
          "User did not give permission to record audio.");
    }
  }

  Future<void> stopProcess() async {
    if (_cheetah == null || _voiceProcessor == null) {
      throw CheetahInvalidStateException(
          "Cannot start Cheetah - resources have already been released");
    }

    if (await _voiceProcessor?.isRecording() ?? false) {
      try {
        await _voiceProcessor?.stop();
      } on PlatformException catch (e) {
        throw CheetahRuntimeException(
            "Failed to stop audio recording: ${e.message}");
      }

      CheetahTranscript cheetahTranscript = await _cheetah!.flush();
      _transcriptCallback((cheetahTranscript.transcript) + " ");
    }
  }

  Future<void> delete() async {
    await stopProcess();
    _voiceProcessor = null;

    _cheetah?.delete();
    _cheetah = null;
  }
}
