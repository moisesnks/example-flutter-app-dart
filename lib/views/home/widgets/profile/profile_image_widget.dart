import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import './get_img_url.dart';

class ProfileImageWidget extends StatefulWidget {
  final Uint8List? image;
  final String? imageUrl;
  final Function(Uint8List) onImageSelected;

  ProfileImageWidget({
    this.image,
    this.imageUrl,
    required this.onImageSelected,
  });

  @override
  ProfileImageWidgetState createState() => ProfileImageWidgetState();
}

class ProfileImageWidgetState extends State<ProfileImageWidget> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _image = imageBytes;
      });
      widget.onImageSelected(imageBytes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FutureBuilder<String?>(
          future: widget.imageUrl != null
              ? getImgUrl(widget.imageUrl!)
              : Future.value(null),
          builder: (context, snapshot) {
            Widget imageWidget;
            if (_image != null) {
              imageWidget = CircleAvatar(
                  radius: 50, backgroundImage: MemoryImage(_image!));
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.data == null) {
              imageWidget = CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/default-avatar.png'));
            } else {
              imageWidget = CircleAvatar(
                  radius: 50, backgroundImage: NetworkImage(snapshot.data!));
            }
            return imageWidget;
          },
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: IconButton(
            icon: Icon(Icons.add_a_photo),
            onPressed: _pickImage,
          ),
        ),
      ],
    );
  }
}
