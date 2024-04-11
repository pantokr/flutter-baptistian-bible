import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_view/photo_view.dart';

class MapImageView extends StatefulWidget {
  final imageUrl;
  final title;
  const MapImageView({super.key, this.title, this.imageUrl});

  @override
  State<MapImageView> createState() => _MapImageViewState();
}

class _MapImageViewState extends State<MapImageView> {
  String imageUrl = '';
  String title = '';

  @override
  void initState() {
    super.initState();

    imageUrl = widget.imageUrl;
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Center(
        child: PhotoView(
          imageProvider: AssetImage(imageUrl),
        ),
      ),
    );
  }
}
