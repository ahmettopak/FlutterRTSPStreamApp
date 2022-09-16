import 'package:flutter/material.dart';
import 'package:vlc_flutter/vlcplayer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  VLCController _controller = VLCController(args: ["-vvv"]);
  String rtspUrl = "rtsp://rtsp.stream/pattern";

  @override
  void initState() {
    super.initState();
    _controller.onEvent.listen((event) {
      if (event.type == EventType.TimeChanged) {
        debugPrint("==[${event.timeChanged}]==");
      }
    });

    _controller.onPlayerState.listen((state) {
      debugPrint("--[$state]--");
    });

    load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  load() async {
    await _controller.setDataSource(uri: rtspUrl);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("RTSP Stream"),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: VLCVideoWidget(
                controller: _controller,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () async {
                    _controller.play();
                  },
                  icon: Icon(Icons.play_arrow_outlined),
                  iconSize: 50,
                ),
                IconButton(
                  onPressed: () async {
                    _controller.stop();
                  },
                  icon: Icon(Icons.stop_circle_outlined),
                  iconSize: 50,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
