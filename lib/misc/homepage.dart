// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:podboi/Controllers/audio_controller.dart';
// import 'package:podboi/database.dart';

// class HomePage extends StatefulWidget {
//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text("Background Music"),
//         ),
//         body: SafeArea(
//           child: Container(
//             height: MediaQuery.of(context).size.height * 0.80,
//             child: Column(
//               children: [
                
//               ],
//             ),
//           ),
//         ));
//   }
// }

// /*
// Consumer(
//                   builder: (context, ref, child) {
//                     return Expanded(
//                       child: ListView.builder(
//                           itemCount: songList.length,
//                           itemBuilder: (context, index) {
//                             Song _song = songList[index];

//                             return GestureDetector(
//                               onTap: () {
//                                 ref
//                                     .read(audioController.notifier)
//                                     .playAction(index);
//                               },
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 120.0,
//                                     width: 120.0,
//                                     child: Image.network(
//                                       _song.icon,
//                                       fit: BoxFit.cover,
//                                     ),
//                                   ),
//                                   Text("${_song.name}")
//                                 ],
//                               ),
//                             );
//                           }),
//                     );
//                   },
//                 ),

// */

// /*

//  var _cont = ref.watch(audioController);
//                     //  await ref
//                     // .read(homeScreenViewController.notifier)
//                     // .loadMorePokemons();
//                     return Column(
//                       children: [
//                         StreamBuilder<MediaItem?>(
//                             stream: _cont.currentMediaItemStream,
//                             builder: (_, snapshot) {
//                               return Text(snapshot.data?.title ?? "title");
//                             }),
//                         StreamBuilder<PlaybackState>(
//                             stream: _cont.playbackStateStream,
//                             builder: (context, snapshot) {
//                               final playing = snapshot.data?.playing ?? false;
//                               if (playing)
//                                 return Row(
//                                   children: [
//                                     ElevatedButton(
//                                         child: Text("Pause"),
//                                         onPressed: () {
//                                           ref
//                                               .read(audioController.notifier)
//                                               .pauseAction();
//                                           // AudioService.pause();
//                                         }),
//                                     IconButton(
//                                         icon: Icon(Icons.stop),
//                                         onPressed: () {
//                                           ref
//                                               .read(audioController.notifier)
//                                               .stopAction();
//                                         })
//                                   ],
//                                 );
//                               else
//                                 return ElevatedButton(
//                                     child: Text("Play"),
//                                     onPressed: () {
//                                       ref
//                                           .read(audioController.notifier)
//                                           .playAction();
//                                       // if (AudioService.running) {
//                                       //   AudioService.play();
//                                       // } else {
//                                       //   AudioService.start(
//                                       //     backgroundTaskEntrypoint:
//                                       //         _backgroundTaskEntrypoint,
//                                       //   );
//                                       // }
//                                     });
//                             }),
//                         ElevatedButton(
//                             onPressed: () async {
//                               await ref
//                                   .read(audioController.notifier)
//                                   .skipToNext();
//                             },
//                             child: Text("Next Song")),
//                         ElevatedButton(
//                             onPressed: () async {
//                               await ref
//                                   .read(audioController.notifier)
//                                   .skipToPrevious();
//                             },
//                             child: Text("Previous Song")),
//                         StreamBuilder<Duration>(
//                           stream: _cont.positionStream,
//                           builder: (_, snapshot) {
//                             final mediaState = snapshot.data;
//                             return Slider(
//                               value: mediaState?.inSeconds.toDouble() ?? 0,
//                               min: 0,
//                               max: _cont.mediaItem?.duration?.inSeconds
//                                       .toDouble() ??
//                                   0.0,
//                               onChanged: (val) {
//                                 ref.read(audioController.notifier).seekTo(val);
//                               },
//                             );
//                           },
//                         )
//                       ],
//                     );

//                     */