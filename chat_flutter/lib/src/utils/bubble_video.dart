import 'package:chat_flutter/src/utils/my_colors.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class BubbleVideo extends StatefulWidget {
  BubbleVideo({this.message = '', this.time = '', this.delivered, this.isMe, this.url = '', this.status = '', this.playVideo, this.videoController});

  final String message, time, url, status;
  final delivered, isMe;

  bool isLoading = false;

  Function? playVideo;
  VideoPlayerController? videoController;
  ChewieController? chewieController;

  @override
  State<BubbleVideo> createState() => _BubbleVideoState();
}

class _BubbleVideoState extends State<BubbleVideo> {
  @override
  Widget build(BuildContext context) {
    final bg = widget.isMe ? Colors.white : MyColors.primaryColorLight;
    final align = widget.isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = widget.status == 'ENVIADO' ? Icons.done : widget.status == 'RECIBIDO' ? Icons.done_all : Icons.done_all;
    final radius = widget.isMe
        ? BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(10.0),
      bottomRight: Radius.circular(5.0),
    )
        : BorderRadius.only(
      topLeft: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(10.0),
    );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin:  EdgeInsets.only(right: widget.isMe == true ? 3 : 70, left: widget.isMe == true ? 70 : 3, top: 5, bottom: 5),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(bottom: 22),
                child: GestureDetector(
                  onTap: () {

                    if (widget.videoController == null) {

                      setState(() { widget.isLoading = true; });

                      widget.videoController = VideoPlayerController.network(widget.url)..initialize().then((_) {
                        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                        widget.isLoading = false;

                        widget.chewieController = ChewieController(
                          videoPlayerController: widget.videoController!,
                          autoPlay: true,
                          looping: true,
                        );

                        setState(() {});
                      });
                    }
                    else {
                      if (widget.videoController?.value.isPlaying == true) {
                        widget.videoController?.pause();
                      }
                      else {
                        widget.videoController?.play();
                      }
                    }
                  },
                  child: Stack(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                          child: widget.videoController?.value.isInitialized == true
                              ? AspectRatio(
                                aspectRatio: widget.videoController?.value.aspectRatio as double,
                                // child:  VideoPlayer(widget.videoController!),
                                child:  Chewie(
                                  controller: widget.chewieController!,
                                ),
                              )
                              : _buildImageWait(context)
                      ),
                      widget.videoController?.value.isInitialized == true
                          ? Container(
                            alignment: Alignment.centerRight,
                            margin: EdgeInsets.all(20),
                            child: Icon(
                                widget.videoController?.value.isPlaying == true
                                    ? Icons.pause : Icons.play_arrow,
                                color: Colors.black,
                                size: 30
                            )
                          )
                          : Container()
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(widget.time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    widget.isMe == true ? Icon(
                      icon,
                      size: 12.0,
                      color: widget.status == 'VISTO' ? Colors.blue : Colors.black38,
                    ) : Container()
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildImageWait(BuildContext context) {
    return widget.isLoading == true
      ? Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: Text('Cargando video...'),
     )
     : Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: Icon(Icons.video_library, color: Colors.grey[600], size: 100,),
      )
    ;
  }

  void initController(String link) {
    widget.videoController = VideoPlayerController.network(link)
      ..initialize().then((_) {
        setState(() {});
      });
  }

  Future<void> onControllerChange(String link) async {
    if (widget.videoController == null) {
      // If there was no controller, just create a new one
      initController(link);
    } else {
      // If there was a controller, we need to dispose of the old one first
      final oldController = widget.videoController;

      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        await oldController?.dispose();

        // Initing new controller
        initController(link);
      });

      // Making sure that controller is not used by setting it to null
      setState(() {
        widget.videoController = null;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    widget.videoController?.dispose();
    widget.chewieController?.dispose();
    widget.videoController = null;
    widget.chewieController = null;
    widget.isLoading = false;

  }
}