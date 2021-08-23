part of "config.dart";

class Constants{
  static List<String> filterList = [
    "Photos", "Videos",
    "Docs", "Meets", "Projects"
  ];

  static Map<String, Widget> filterAvatar = {
    "Photos": AdaptiveIcon(
      android: Icons.image,
      iOS: CupertinoIcons.photo_fill,
      color: Colors.white, size: 20
    ),
    "Videos": AdaptiveIcon(
      android: Icons.videocam,
      iOS: CupertinoIcons.video_camera_solid,
      color: Colors.white, size: 20
    ),
    "Docs": SvgPicture.asset("assets/mdi_file-document.svg", height: 18, width: 18),
    "Meetings": SvgPicture.asset("assets/mdi_presentation-play.svg", height: 18, width: 18),
    "Services": SvgPicture.asset("assets/cart.svg", height: 18, width: 18, color: Colors.white),
  };

  static Map<String, Widget> mediaAvatar = {
    "Photos": AdaptiveIcon(
      android: Icons.image,
      iOS: CupertinoIcons.photo_fill,
      color: Colors.white, size: 30
    ),
    "Videos": AdaptiveIcon(
      android: Icons.videocam,
      iOS: CupertinoIcons.video_camera_solid,
      color: Colors.white, size: 30
    ),
    "Docs": SvgPicture.asset("assets/mdi_file-document.svg", height: 28, width: 28),
    "Meetings": SvgPicture.asset("assets/mdi_presentation-play.svg", height: 28, width: 28),
    "Services": SvgPicture.asset("assets/cart.svg", height: 30, width: 30, color: Colors.white),
    "Camera": AdaptiveIcon(
      android: Icons.photo_camera,
      iOS: CupertinoIcons.camera_fill,
      color: Colors.white, size: 28,
    ),
  };
  
}