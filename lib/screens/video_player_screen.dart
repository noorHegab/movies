import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YouTubePlayerScreen extends StatefulWidget {
  final String videoId;

  const YouTubePlayerScreen({
    required this.videoId,
    Key? key,
  }) : super(key: key);

  @override
  _YouTubePlayerScreenState createState() => _YouTubePlayerScreenState();
}

class _YouTubePlayerScreenState extends State<YouTubePlayerScreen> {
  late final YoutubePlayerController _controller;
  // int _likes = 0;
  // int _dislikes = 0;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        loop: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // void _handleLike() {
  //   setState(() {
  //     _likes++;
  //   });
  //   _showSnackBar('Liked!');
  // }
  //
  // void _handleDislike() {
  //   setState(() {
  //     _dislikes++;
  //   });
  //   _showSnackBar('Disliked!');
  // }
  //
  // void _handleShare() {
  //   // Implement sharing logic here (using share_plus or other packages)
  //   _showSnackBar('Share feature not implemented.');
  // }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // void _playVideo() {
  //   _controller.play(); // Start video playback
  // }
  //
  // void _skipForward() {
  //   final currentPosition = _controller.value.position;
  //   final newPosition = currentPosition + const Duration(seconds: 10);
  //   _controller.seekTo(newPosition);
  // }
  //
  // void _skipBackward() {
  //   final currentPosition = _controller.value.position;
  //   final newPosition = currentPosition - const Duration(seconds: 10);
  //   // Ensure the new position is not less than zero
  //   _controller
  //       .seekTo(newPosition < Duration.zero ? Duration.zero : newPosition);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blue,
        onReady: () {},
      ),
    );
  }
}
//
// const SizedBox(height: 10),
//
// // Video Title
// Text(
// widget.name,
// style: const TextStyle(
// fontSize: 20,
// fontWeight: FontWeight.bold,
// color: Colors.white,
// ),
// maxLines: 1,
// overflow: TextOverflow.ellipsis,
// ),
//
// // Video Description
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 16.0),
// child: Text(
// widget.description,
// style: const TextStyle(
// fontSize: 16,
// color: Colors.grey,
// ),
// textAlign: TextAlign.justify,
// maxLines: 2,
// overflow: TextOverflow.ellipsis,
// ),
// ),
//
// const SizedBox(height: 10),
//
// // Play Button
// ElevatedButton(
// onPressed: _playVideo,
// style: ElevatedButton.styleFrom(
// backgroundColor: Colors.blue, // Button color
// ),
// child: const Text('Play Video'),
// ),
//
// const SizedBox(height: 5),
//
// // Video Controls
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 10.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// IconButton(
// icon: const Icon(Icons.skip_previous, color: Colors.white),
// onPressed: _skipBackward,
// ),
// const SizedBox(width: 20),
// IconButton(
// icon: const Icon(Icons.thumb_up, color: Colors.blue),
// onPressed: _handleLike,
// ),
// const SizedBox(width: 20),
// IconButton(
// icon: const Icon(Icons.thumb_down, color: Colors.red),
// onPressed: _handleDislike,
// ),
// const SizedBox(width: 20),
// IconButton(
// icon: const Icon(Icons.share, color: Colors.white),
// onPressed: _handleShare,
// ),
// const SizedBox(width: 20),
// IconButton(
// icon: const Icon(Icons.skip_next, color: Colors.white),
// onPressed: _skipForward,
// ),
// ],
// ),
// ),
//
// // Like/Dislike Count
// Padding(
// padding: const EdgeInsets.symmetric(vertical: 10.0),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Text('Likes: $_likes',
// style: const TextStyle(color: Colors.blue)),
// const SizedBox(width: 20),
// Text('Dislikes: $_dislikes',
// style: const TextStyle(color: Colors.red)),
// ],
// ),
// ),
