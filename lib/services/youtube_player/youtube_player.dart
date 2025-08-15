import 'package:flutter/material.dart';
import 'package:wa_api/common/widgets/custom_shape/image/circular_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../utils/helpers/url_launcher_helper.dart';

class YouTubePlayerWidget extends StatefulWidget {
  final String youtubeUrl;
  final bool playInApp; // true = embed player, false = redirect to YouTube

  const YouTubePlayerWidget({
    super.key,
    required this.youtubeUrl,
    this.playInApp = false,
  });

  @override
  State<YouTubePlayerWidget> createState() => _YouTubePlayerWidgetState();
}

class _YouTubePlayerWidgetState extends State<YouTubePlayerWidget> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();

    if (widget.playInApp) {
      final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl);
      if (videoId != null) {
        _controller = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _redirectToYouTube() async {
    UrlLauncherHelper.openUrlInChrome(widget.youtubeUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.playInApp && _controller != null) {
      return YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
      );
    } else {
      final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl) ?? "";
      final thumbnailUrl = "https://img.youtube.com/vi/$videoId/maxresdefault.jpg";

      return GestureDetector(
        onTap: _redirectToYouTube,
        child: Stack(
          alignment: Alignment.center,
          children: [
            RoundedImage(
              isNetworkImage: true,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
              image: thumbnailUrl,
            ),
            // Image.network(thumbnailUrl, fit: BoxFit.cover),
            Icon(Icons.play_circle_fill, size: 64, color: Colors.white.withOpacity(0.8)),
          ],
        ),
      );
    }
  }
}
