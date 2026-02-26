import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Fullscreen video player using media_kit.
///
/// Requires [MediaKit.ensureInitialized] to be called in the app's `main()`.
class FullscreenVideoPlayer extends StatefulWidget {
  final String source;

  const FullscreenVideoPlayer({super.key, required this.source});

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  late final Player player = Player();
  late final VideoController controller = VideoController(player);

  // A [GlobalKey<VideoState>] is required to access the programmatic fullscreen interface.
  late final GlobalKey<VideoState> key = GlobalKey<VideoState>();

  @override
  void initState() {
    super.initState();
    MediaKit.ensureInitialized();
    player.open(Media(widget.source));
    player.stream.error.listen((error) => debugPrint(error));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      maintainBottomViewPadding: true,
      child: MaterialVideoControlsTheme(
        normal: MaterialVideoControlsThemeData(topButtonBar: topBar(context)),
        fullscreen: MaterialVideoControlsThemeData(
          topButtonBar: topBar(context),
        ),
        child: Video(
          key: key,
          controller: controller,
        ),
      ),
    );
  }

  List<Widget> topBar(BuildContext context) {
    return [
      MaterialDesktopCustomButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          if (key.currentState?.isFullscreen() ?? false) {
            key.currentState?.exitFullscreen();
          }
          Navigator.of(context).pop();
          // Navigator.of(context).popUntil((route) => route.isFirst);
        },
      ),
      const Spacer(),
    ];
  }
}
