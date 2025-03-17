import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
    final String audioUrl;
  const HomeScreen({super.key, required this.audioUrl});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isPlaying = false;
  late final AudioPlayer player;
 
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    initPlayer();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  Future initPlayer() async {
    player = AudioPlayer();

    // Set a callback for duration change
    player.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });

    // Set a callback for position change
    player.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });

    // Set a callback for when audio ends
    player.onPlayerComplete.listen((_) {
      setState(() => _position = _duration);
    });
  }

  void playPause() async {
    if (isPlaying) {
      player.pause();
      isPlaying = false;
    } else {
      await player.play(UrlSource(widget.audioUrl)); // Play from URL
      isPlaying = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // const AudioInfo(),
              const Text("Audio Player",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Slider(
                value: _position.inSeconds.toDouble(),
                onChanged: (value) async {
                  await player.seek(Duration(seconds: value.toInt()));
                  setState(() {});
                },
                min: 0,
                max: _duration.inSeconds.toDouble(),
                inactiveColor: Colors.grey,
                activeColor: Colors.red,
              ),
              
    
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(_duration.toString().split('.').first),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      player.seek(Duration(seconds: _position.inSeconds - 10));
                      setState(() {});
                    },
                    child: const Icon(Icons.replay_10,
                        size: 50, color: Colors.red),
                  ),
                  const SizedBox(width: 15),
                  InkWell(
                    onTap: playPause,
                    child: Icon(
                      isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.red,
                      size: 80,
                    ),
                  ),
                  const SizedBox(width: 20),
                  InkWell(
                    onTap: () {
                      player.seek(Duration(seconds: _position.inSeconds + 10));
                      setState(() {});
                    },
                    child: const Icon(Icons.forward_10,
                        size: 50, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
        ),
      
    );
  }
}
