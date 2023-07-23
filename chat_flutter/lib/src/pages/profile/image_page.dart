import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';

import '../../models/user.dart';

class StoryPage extends StatefulWidget {
  int img_portada;
  User user;
  StoryPage({required this.img_portada, required this.user});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late CarouselSliderController _sliderController;

  @override
  void initState() {
    _sliderController = CarouselSliderController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            height: double.infinity,
            color: Colors.black,
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: widget.img_portada == 1
                        ? Center(
                            child: PhotoView(
                              imageProvider: widget.user.img_portada != null
                                  ? NetworkImage(widget.user.img_portada!)
                                  : AssetImage('assets/img/man.png')
                                      as ImageProvider,
                            ),
                          )
                        : Center(
                            child: PhotoView(
                              imageProvider: widget.user.image != null
                                  ? NetworkImage(widget.user.image!)
                                  : AssetImage('assets/img/man.png')
                                      as ImageProvider,
                            ),
                          )),
                Positioned(
                    top: 50,
                    left: 8,
                    right: 8,
                    child: Container(
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back_ios),
                                  color: Colors.white,
                                  onPressed: () => Navigator.pop(context),
                                ),
                                SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.user.name ?? 'null name',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert),
                            color: Colors.white,
                            onPressed: () => print('More'),
                          ),
                        ],
                      ),
                    ))
              ],
            )));
  }
}
