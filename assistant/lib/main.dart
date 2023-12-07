import 'package:assistant/context/bloc.dart';
import 'package:assistant/context/context.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lava_clock/model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  await AppBloc.initStorage();
  runApp(const AssistantApp());
}

class AssistantApp extends StatelessWidget {
  const AssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBloc().init(context,
        child: MaterialApp(
            home: Stack(fit: StackFit.expand, children: [
          AssistantClock(),
          Align(
              alignment: Alignment.bottomLeft,
              child: SpeechButton(
                onPressed: _onNuman,
                text: 'Numan',
              )),
          Align(
              alignment: Alignment.bottomCenter,
              child: SpeechButton(
                onPressed: _torchOn,
                text: 'Play',
              )),
          Align(
              alignment: Alignment.topCenter,
              child: SpeechButton(
                onPressed: _torchOff,
                text: 'Pause',
              )),
          Align(
              alignment: Alignment.bottomRight,
              child: SpeechButton(
                onPressed: _onAlbum,
                text: 'Album',
              ))
        ])));
  }

  void _torchOn(BuildContext context) {
    context.speech.awake();
    context.speech.text('play');
    // context.clock.repository.setPaused(true);
  }

  void _torchOff(BuildContext context) {
    context.speech.awake();
    context.speech.text('pause');
    // context.clock.repository.setPaused(false);
  }

  void _onNuman(BuildContext context) {
    context.speech.awake();
    context.speech.text('play songs by gary numan');
  }

  void _onAlbum(BuildContext context) {
    context.speech.awake();
    context.speech.text('play album one more time');
  }
}

class SpeechButton extends StatelessWidget {
  final String text;
  final void Function(BuildContext) onPressed;

  SpeechButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Chip(
        onDeleted: () {},
        avatar: Icon(Icons.place_outlined),
        label: Text(text));
        // onPressed: () => onPressed(context));
  }
}

class AssistantClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return context.clock.repository.build(context);
  }
}
