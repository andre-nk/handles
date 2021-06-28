part of "widgets.dart";

class VideoChat extends StatefulWidget {
  final int index;
  final DateTime timestamp;
  final String sender;
  final String senderRole;
  final String videoURL;
  final String content;
  final bool isRecurring;
  final bool isPinned;

  const VideoChat({
    Key? key,
    required this.index,
    required this.timestamp,
    required this.sender,
    required this.senderRole,
    required this.videoURL,
    required this.isRecurring,
    required this.isPinned,
    required this.content
  }) : super(key: key);

  @override
  _VideoChatState createState() => _VideoChatState();
}

class _VideoChatState extends State<VideoChat> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {

    Future<String?> getThumbnail(String videoURL) async {
      final String? fileName = await VideoThumbnail.thumbnailFile(
        video: this.widget.videoURL,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxHeight: 180, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
        quality: 50,
      );

      return fileName;
    }

    return widget.sender == "a" //TODO: CHECK IF SENDER == USER ID
      ? Container(
          width: MQuery.width(1, context),
          margin: EdgeInsets.only(
            bottom: MQuery.width(0.01, context),
          ),
          padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MQuery.width(
                    this.widget.videoURL.length >= 30
                    ? 0.35
                    : this.widget.videoURL.length <= 12
                      ? 0.15
                      : this.widget.videoURL.length * 0.009
                    , context
                  ),
                  minWidth: MQuery.width(0.1, context),
                  minHeight: MQuery.height(0.045, context)
                ),
                child: Container(
                  padding: EdgeInsets.all(MQuery.height(0.01, context)),
                  decoration: BoxDecoration(
                    color: Palette.primary,
                    borderRadius: BorderRadius.only(
                      topRight: widget.isRecurring ? Radius.circular(7) : Radius.circular(0),
                      topLeft: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                      bottomLeft: Radius.circular(7)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Get.to(() => VideoPreviewer(
                                videoURL: this.widget.videoURL,
                                timeStamp: this.widget.timestamp,
                                sender: this.widget.sender,
                                heroTag: "image-${widget.index}",
                                content: this.widget.content
                              ));
                            },
                            child: Hero(
                              tag: "image-${widget.index}",
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  AspectRatio(
                                    aspectRatio: 1/1,
                                    child: FutureBuilder<String?>(
                                      future: getThumbnail(this.widget.videoURL),
                                      builder: (context, snapshot){
                                        return snapshot.hasData
                                        ? Container(
                                            width: MQuery.width(0.35, context),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                            ),
                                            child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Positioned.fill(
                                                  child: Image.file(
                                                    File(snapshot.data ?? ""),
                                                    fit: BoxFit.fill
                                                  ),
                                                ),
                                                Container(
                                                  width: MQuery.width(0.35, context),
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.4),
                                                    borderRadius: BorderRadius.all(Radius.circular(5))
                                                  )
                                                ),
                                                AdaptiveIcon(
                                                  android: Icons.play_arrow_rounded,
                                                  iOS: CupertinoIcons.play_arrow_solid,
                                                  size: 32,
                                                  color: Colors.white
                                                )
                                              ],
                                            )
                                          )
                                        : Container(
                                            width: MQuery.width(0.35, context),
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.5),
                                              borderRadius: BorderRadius.all(Radius.circular(5))
                                            ),
                                            child: Center(
                                              child: CircularProgressIndicator(
                                                color: Palette.primary,
                                              ),
                                            )
                                          );
                                      },
                                    )
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        widget.isPinned
                                        ? AdaptiveIcon(
                                            android: Icons.push_pin,
                                            iOS: CupertinoIcons.pin_fill,
                                            size: 12,
                                            color: Palette.handlesBackground,
                                          )
                                        : SizedBox(),
                                        Text(
                                          DateFormat.jm().format(widget.timestamp),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(1),
                                            fontWeight: FontWeight.w400,
                                            fontSize: 12
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      this.widget.content == ""
                      ? SizedBox()
                      : Column(
                        children: [
                          SizedBox(height: MQuery.height(0.0075, context)),
                          SelectableLinkify(
                            onOpen: (link) async {
                              print(link.url);
                              await launch(link.url);
                            },
                            text: this.widget.content,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              height: 1.25,
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                              fontSize: 15
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ),
              ),
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(math.pi),
                child: SvgPicture.asset(
                  "assets/tool_tip.svg",
                  color: widget.isRecurring ? Palette.handlesBackground : Palette.primary,
                  height: MQuery.height(0.02, context),
                  width: MQuery.height(0.02, context),
                ),
              ),
            ],
          ))
      : Container(
          width: MQuery.width(1, context),
          margin: EdgeInsets.only(
            bottom: MQuery.width(0.01, context)
          ),
          padding: EdgeInsets.symmetric(horizontal: MQuery.width(0.01, context)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                "assets/tool_tip.svg",
                height: MQuery.height(0.02, context),
                width: MQuery.height(0.02, context),
                color: widget.isRecurring ? Palette.handlesBackground : Colors.white
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MQuery.width(
                    this.widget.videoURL.length >= 30
                    ? 0.35
                    : this.widget.videoURL.length <= 12
                      ? 0.15
                      : this.widget.videoURL.length * 0.009
                    , context
                  ),
                  minWidth: MQuery.width(0.14, context),
                  minHeight: MQuery.height(0.045, context)
                ),
                child: Container(
                  padding: EdgeInsets.all(MQuery.height(0.01, context)),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: widget.isRecurring ? Radius.circular(7) : Radius.circular(0),
                      topRight: Radius.circular(7),
                      bottomRight: Radius.circular(7),
                      bottomLeft: Radius.circular(7)
                    )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          widget.isRecurring && widget.isPinned == false
                          ? SizedBox()
                          : RichText(
                              text: TextSpan(
                                text: "${this.widget.sender} ",
                                style: TextStyle(
                                  //TODO: DYNAMIC COLOR CREATION
                                  color: Palette.primary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15
                                ),
                                children: [
                                  TextSpan(
                                    text: "(${this.widget.senderRole})",
                                    style: TextStyle(
                                      color: Palette.primary,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15
                                    )
                                  ),
                                ],
                              ),
                            ),
                          widget.isPinned
                          ? AdaptiveIcon(
                              android: Icons.push_pin,
                              iOS: CupertinoIcons.pin_fill,
                              size: 12
                            )
                          : SizedBox()
                        ],
                      ),
                      SizedBox(height: MQuery.height(0.005, context)),
                      GestureDetector(
                        onTap: (){
                          Get.to(() => VideoPreviewer(
                            videoURL: this.widget.videoURL,
                            timeStamp: this.widget.timestamp,
                            sender: this.widget.sender,
                            heroTag: "image-${widget.index}",
                            content: this.widget.content
                          ));
                        },
                        child: Hero(
                          tag: "image-${widget.index}",
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              AspectRatio(
                                aspectRatio: 1/1,
                                child: FutureBuilder<String?>(
                                  future: getThumbnail(this.widget.videoURL),
                                  builder: (context, snapshot){
                                    return snapshot.hasData
                                    ? Container(
                                        width: MQuery.width(0.35, context),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(5))
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned.fill(
                                              child: Image.file(
                                                File(snapshot.data ?? ""),
                                                fit: BoxFit.fill
                                              ),
                                            ),
                                            Container(
                                              width: MQuery.width(0.35, context),
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.25),
                                                borderRadius: BorderRadius.all(Radius.circular(5))
                                              )
                                            ),
                                            AdaptiveIcon(
                                              android: Icons.play_arrow_rounded,
                                              iOS: CupertinoIcons.play_arrow_solid,
                                              size: 32,
                                              color: Colors.white
                                            )
                                          ],
                                        )
                                      )
                                    : Container(
                                        width: MQuery.width(0.35, context),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: BorderRadius.all(Radius.circular(5))
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: Palette.primary,
                                          ),
                                        )
                                      );
                                  },
                                )
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  DateFormat.jm().format(widget.timestamp),
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(1),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      this.widget.content == ""
                      ? SizedBox()
                      : Column(
                        children: [
                          SizedBox(height: MQuery.height(0.0075, context)),
                          SelectableLinkify(
                            onOpen: (link) async {
                              print(link.url);
                              await launch(link.url);
                            },
                            text: this.widget.content,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              height: 1.25,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        );
  }
}