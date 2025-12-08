import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../resources/resources.dart';
import 'package:video_player/video_player.dart';
class SeeAllProductHighlights extends StatefulWidget {
  const SeeAllProductHighlights({super.key});

  @override
  State<SeeAllProductHighlights> createState() =>
      _SeeAllProductHighlightsState();
}

class _SeeAllProductHighlightsState extends State<SeeAllProductHighlights> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
            ),
          )
          ..initialize().then((_) {
            setState(() {});
            _controller.setLooping(true);
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Widget videoCard(String title, String duration) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _controller.value.isInitialized
                    ? AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      )
                    : const SizedBox(
                        height: 130,
                        child: Center(child: CircularProgressIndicator()),
                      ),
              ),
              IconButton(
                icon: Icon(
                  _controller.value.isPlaying
                      ? Icons.pause_circle
                      : Icons.play_circle,
                  color: Colors.white,
                  size: 40,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
            ],
          ),

          SizedBox(height: 10),

          Text(
            title,
            style: R.textStyles.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),

          SizedBox(height: 5),

          Text(
            duration,
            style: R.textStyles.poppins(
              color: R.color.commonLightGrey,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.color.backGroundColor,
      appBar: AppBar(
        backgroundColor: R.color.backGroundColor,
        elevation: 0,
        title: Text(
          "All Product Highlights",
          style: R.textStyles.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (_, index) {
            return videoCard(
              "Highlights Video ${index + 1}",
              "2:${30 + index}",
            );
          },
        ),
      ),
    );
  }
}
