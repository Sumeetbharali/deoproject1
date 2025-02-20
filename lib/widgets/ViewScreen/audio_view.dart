import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

// class AudioPlayerScreen extends StatefulWidget {
//   final String url;
//   const AudioPlayerScreen({super.key, required this.url});

//   @override
//   State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
// }

// class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool isPlaying = false;

//   @override
//   void dispose() {
//     _audioPlayer.dispose();
//     super.dispose();
//   }

//   void _togglePlayPause() async {
//     if (isPlaying) {
//       await _audioPlayer.pause();
//     } else {
//       await _audioPlayer.play(UrlSource(widget.url));
//     }
//     setState(() => isPlaying = !isPlaying);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Audio Player")),
//       body: Center(
//         child: IconButton(
//           icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 50),
//           onPressed: _togglePlayPause,
//         ),
//       ),
//     );
//   }
// }


class AudioPlayerBottomSheet extends StatefulWidget {
  final String url;
  const AudioPlayerBottomSheet({super.key, required this.url});

  @override
  State<AudioPlayerBottomSheet> createState() => _AudioPlayerBottomSheetState();
}

class _AudioPlayerBottomSheetState extends State<AudioPlayerBottomSheet> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();

    // Listen for total duration
    _audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() => _duration = d);
    });

    // Listen for position updates
    _audioPlayer.onPositionChanged.listen((Duration p) {
      setState(() => _position = p);
    });

    // Reset when audio completes
    _audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        _position = Duration.zero;
      });
    });

    _audioPlayer.setSourceUrl(widget.url);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play(UrlSource(widget.url));
    }
    setState(() => isPlaying = !isPlaying);
  }

  void _seekAudio(double value) async {
    final newPosition = Duration(seconds: value.toInt());
    await _audioPlayer.seek(newPosition);
    setState(() => _position = newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Audio Player",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Slider.adaptive(
                  min: 0,
                  max: _duration.inSeconds.toDouble().clamp(1.0, double.infinity),
                  value: _position.inSeconds
                      .toDouble()
                      .clamp(0.0, _duration.inSeconds.toDouble()),
                  onChanged: (value) {
                    setState(() => _position =
                        Duration(seconds: value.toInt())); // Update UI smoothly
                  },
                  onChangeEnd: (value) => _seekAudio(value), // Seek after release
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
                          size: 40),
                      onPressed: _togglePlayPause,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
