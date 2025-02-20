// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class AudioPlayerUrl extends StatefulWidget {
//   const AudioPlayerUrl({super.key});

//   @override
//   _AudioPlayerUrlState createState() => _AudioPlayerUrlState();
// }

// class _AudioPlayerUrlState extends State<AudioPlayerUrl> {
//   AudioPlayer audioPlayer = AudioPlayer();
//   PlayerState audioPlayerState = PlayerState.paused;
//   String aUrl =
//       'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';

//   int timeProgress = 0;
//   int audioDuration = 0;

//   @override
//   void initState() {
//     super.initState();

//     audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
//       setState(() {
//         audioPlayerState = state;
//       });
//     });

//     audioPlayer.setSource(UrlSource(aUrl));

//     audioPlayer.onDurationChanged.listen((Duration duration) {
//       setState(() {
//         audioDuration = duration.inSeconds;
//       });
//     });

//     audioPlayer.onPositionChanged.listen((Duration position) {
//       setState(() {
//         timeProgress = position.inSeconds;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     audioPlayer.release();
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   playMusic() async {
//     await audioPlayer.play(UrlSource(aUrl));
//   }

//   pauseMusic() async {
//     await audioPlayer.pause();
//   }

//   void seekToSec(int sec) {
//     audioPlayer.seek(Duration(seconds: sec));
//   }

//   String getTimeString(int seconds) {
//     String minuteString = '${(seconds ~/ 60).toString().padLeft(2, '0')}';
//     String secondString = '${(seconds % 60).toString().padLeft(2, '0')}';
//     return '$minuteString:$secondString';
//   }

//   Widget slider() {
//     return SizedBox(
//       width: 300.0,
//       child: Slider.adaptive(
//         value: timeProgress.toDouble(),
//         max: audioDuration > 0 ? audioDuration.toDouble() : 1,
//         onChanged: (value) {
//           seekToSec(value.toInt());
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IconButton(
//               iconSize: 50,
//               onPressed: () {
//                 audioPlayerState == PlayerState.playing
//                     ? pauseMusic()
//                     : playMusic();
//               },
//               icon: Icon(audioPlayerState == PlayerState.playing
//                   ? Icons.pause_rounded
//                   : Icons.play_arrow_rounded),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(getTimeString(timeProgress)),
//                 const SizedBox(width: 20),
//                 slider(),
//                 const SizedBox(width: 20),
//                 Text(getTimeString(audioDuration)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
