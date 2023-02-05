import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagram_clone/views/components/constants/string.dart';
import 'package:instagram_clone/views/components/loading/loading_screen_controller.dart';

class LoadingScreen {
  //~Singleton
  LoadingScreen._sharedInstance();
  //*This will create only once instance in our app.
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  //*now sharing above created instance through factory method.
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? _controller;

  //if LoadingScreenController is null it doesn't have the update function then
  //we not going to get back true value so then we know we have to create overlay.
  void show(
    BuildContext context, {
    String text = Strings.loading,
  }) {
    //by this if condition we check if already displaying loading we return.
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(
        context,
        text: text,
      );
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController? showOverlay(
    BuildContext context, {
    required String text,
  }) {
    final state = Overlay.of(context);
    if (state == null) {
      return null;
    }

    final textController = StreamController<String>();
    textController.add(text);

    //Getting size of the Whole screen.
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(builder: (context) {
      return Material(
        color: Colors.black.withAlpha(150),
        child: Center(
          child: Container(
            constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<String>(
                        stream: textController.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.requireData,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: Colors.black),
                            );
                          } else {
                            return Container();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });

    state.insert(overlay);
    return LoadingScreenController(close: () {
      textController.close();
      overlay.remove();
      return true;
    }, update: (text) {
      textController.add(text);
      return true;
    });
  }
}
